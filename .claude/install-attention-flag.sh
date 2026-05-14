#!/usr/bin/env bash
# Idempotently install the Claude Code attention-flag integration on this
# machine. Safe to run multiple times. Run once after cloning these dotfiles.
#
# What it does:
#   1. Symlinks <dotfiles>/.claude/hooks/claude-attention-flag.sh into
#      ~/.claude/hooks/ so changes in dotfiles propagate.
#   2. Additively patches ~/.claude/settings.json with the 6 hook entries
#      (PermissionRequest/Notification write; UserPromptSubmit/Stop/
#      PostToolUse/PostToolUseFailure clear). Preserves everything else
#      already in settings.json.
#
# After running, the nvim tabline integration in nvim/lua/config/autocmds.lua
# will surface 🟢 / 💬 / ⚠️ / 🔔 / ❌ on tab names per Claude session state.
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

ENTRIES = [
    ("PermissionRequest",  f"{hook_path} write action_needed"),
    ("Notification",       f"{hook_path} write notify"),
    ("UserPromptSubmit",   f"{hook_path} clear"),
    ("Stop",               f"{hook_path} clear"),
    ("PostToolUse",        f"{hook_path} clear"),
    ("PostToolUseFailure", f"{hook_path} clear"),
]

added = []
for event, command in ENTRIES:
    arr = hooks.setdefault(event, [])
    already = any(
        h.get("command") == command
        for block in arr
        for h in block.get("hooks", [])
    )
    if already:
        continue
    arr.append({
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
    json.dump(data, fd, indent=2)
    fd.write("\n")
os.replace(tmp_path, settings_path)

if added:
    print(f"settings: added hook entries for: {', '.join(added)}")
else:
    print("settings: all hook entries already present; nothing to do")
PY

echo "done — restart Claude Code sessions for hooks to take effect"
