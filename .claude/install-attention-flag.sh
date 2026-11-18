#!/usr/bin/env bash
# Idempotently install the Claude Code attention-flag integration on this
# machine. Safe to run multiple times. Run once after cloning these dotfiles.
#
# What it does:
#   1. Symlinks <dotfiles>/.claude/hooks/claude-attention-flag.sh into
#      ~/.claude/hooks/ so changes in dotfiles propagate (the script runs
#      claude_attention.py from the dotfiles folder it links to).
#   2. Patches ~/.claude/settings.json so every event the hook handles calls
#      it once: removes older entries for this hook, adds one per event.
#      Everything else in settings.json is preserved.
#
# After running, the nvim tabline integration in nvim/lua/config/autocmds.lua
# shows ❓ / ❌ / 🔧 / 🟢 / ⏰ on tab names per Claude session state
# (:ClaudeTabDebug explains each tab).
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
SETTINGS="$CLAUDE_DIR/settings.json"
HOOK_SOURCE="$DOTFILES_DIR/hooks/claude-attention-flag.sh"
HOOK_TARGET="$CLAUDE_DIR/hooks/claude-attention-flag.sh"

if [ ! -f "$HOOK_SOURCE" ]; then
  echo "error: hook source not found at $HOOK_SOURCE" >&2
  exit 1
fi

mkdir -p "$CLAUDE_DIR/hooks"

# --- step 1: symlink the hook script ---------------------------------------
if [ -L "$HOOK_TARGET" ]; then
  if [ "$(readlink "$HOOK_TARGET")" = "$HOOK_SOURCE" ]; then
    echo "hook: already linked"
  else
    echo "hook: WARNING — $HOOK_TARGET is a symlink to something else; not touching"
  fi
elif [ -e "$HOOK_TARGET" ]; then
  if cmp -s "$HOOK_TARGET" "$HOOK_SOURCE"; then
    mv "$HOOK_TARGET" "$HOOK_TARGET.bak.$(date +%s)"
    ln -s "$HOOK_SOURCE" "$HOOK_TARGET"
    echo "hook: replaced identical file with symlink (backup kept)"
  else
    echo "hook: WARNING — $HOOK_TARGET exists with different content; not touching" >&2
    echo "      diff against dotfiles version:" >&2
    diff "$HOOK_TARGET" "$HOOK_SOURCE" || true
  fi
else
  ln -s "$HOOK_SOURCE" "$HOOK_TARGET"
  echo "hook: linked $HOOK_TARGET -> $HOOK_SOURCE"
fi

# --- step 2: patch ~/.claude/settings.json ---------------------------------
python3 - "$HOOK_TARGET" "$SETTINGS" <<'PY'
import json, os, sys, tempfile

hook_path, settings_path = sys.argv[1], sys.argv[2]

if os.path.exists(settings_path):
    with open(settings_path) as fd:
        data = json.load(fd)
else:
    data = {"$schema": "https://json.schemastore.org/claude-code-settings.json"}

hooks = data.setdefault("hooks", {})

EVENTS = [
    "PermissionRequest", "Notification", "PostToolUse", "PostToolUseFailure",
    "UserPromptSubmit", "Stop", "SubagentStart", "SubagentStop",
    "SessionStart", "SessionEnd",
]
command = hook_path  # the hook dispatches on hook_event_name; no arguments

# Drop every older entry for this hook (e.g. `... write notify`, `... clear`)
removed = 0
for event, arr in list(hooks.items()):
    for block in arr:
        before = len(block.get("hooks", []))
        block["hooks"] = [
            h for h in block.get("hooks", [])
            if os.path.basename(h.get("command", "").split()[0] if h.get("command") else "")
            != "claude-attention-flag.sh"
        ]
        removed += before - len(block["hooks"])
    hooks[event] = [b for b in arr if b.get("hooks")]
    if not hooks[event]:
        del hooks[event]

added = []
for event in EVENTS:
    hooks.setdefault(event, []).append({
        "matcher": "",
        "hooks": [{
            "type": "command",
            "command": command,
            "timeout": 5,
            "async": True,
        }],
    })
    added.append(event)

# Atomic write — never leave settings.json half-written
tmp_fd, tmp_path = tempfile.mkstemp(prefix="settings.", suffix=".json", dir=os.path.dirname(settings_path) or ".")
with os.fdopen(tmp_fd, "w") as fd:
    json.dump(data, fd, indent=2, ensure_ascii=False)
    fd.write("\n")
if os.path.exists(settings_path):
    os.chmod(tmp_path, os.stat(settings_path).st_mode & 0o777)
os.replace(tmp_path, settings_path)

print(f"settings: replaced {removed} old entries; hook now on: {', '.join(added)}")
PY

echo "done — restart Claude Code sessions for hooks to take effect"
