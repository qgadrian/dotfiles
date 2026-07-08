#!/bin/sh
# Claude Code: status line installer.
# - Ensures jq (the script depends on it).
# - Symlinks ~/.claude/statusline-command.sh to the dotfiles copy.
# - Merges the statusLine block into ~/.claude/settings.json without
#   touching any other key. Safe to re-run.

set -e

echo "\n# Claude Code status line"

# jq is required by the status line script (and by this installer).
if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq (required by statusline-command.sh)"
  brew install jq
fi

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

# Resolve the source script from THIS installer's own location, not $(pwd),
# so linking is correct no matter which directory the installer is run from.
# (Using $(pwd) previously created a dangling symlink whenever the installer
# ran from anywhere other than the dotfiles root.)
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)
SRC_SCRIPT="$SCRIPT_DIR/statusline-command.sh"
DST_SCRIPT="$CLAUDE_DIR/statusline-command.sh"
# Per-subagent row renderer for the agent panel (subagentStatusLine hook).
SRC_SUB="$SCRIPT_DIR/subagent-statusline-command.sh"
DST_SUB="$CLAUDE_DIR/subagent-statusline-command.sh"

# Never create a dangling link: fail loudly if either source is missing.
if [ ! -f "$SRC_SCRIPT" ]; then
  echo "ERROR: status line source not found at $SRC_SCRIPT" >&2
  echo "       run this from a complete dotfiles checkout." >&2
  return 1 2>/dev/null || exit 1
fi
if [ ! -f "$SRC_SUB" ]; then
  echo "ERROR: subagent status line source not found at $SRC_SUB" >&2
  echo "       run this from a complete dotfiles checkout." >&2
  return 1 2>/dev/null || exit 1
fi

mkdir -p "$CLAUDE_DIR"

# Back up any pre-existing real file (not a symlink) so we don't lose it.
if [ -f "$DST_SCRIPT" ] && [ ! -L "$DST_SCRIPT" ]; then
  TS=$(date +%Y%m%d%H%M%S)
  echo "Backing up existing $DST_SCRIPT -> $DST_SCRIPT.old.$TS"
  mv "$DST_SCRIPT" "$DST_SCRIPT.old.$TS"
fi

echo "Linking $SRC_SCRIPT -> $DST_SCRIPT"
ln -sf "$SRC_SCRIPT" "$DST_SCRIPT"

# Back up any pre-existing real subagent script (not a symlink) too.
if [ -f "$DST_SUB" ] && [ ! -L "$DST_SUB" ]; then
  TS=$(date +%Y%m%d%H%M%S)
  echo "Backing up existing $DST_SUB -> $DST_SUB.old.$TS"
  mv "$DST_SUB" "$DST_SUB.old.$TS"
fi

echo "Linking $SRC_SUB -> $DST_SUB"
ln -sf "$SRC_SUB" "$DST_SUB"

# Merge the statusLine + subagentStatusLine blocks into settings.json without
# clobbering other keys.
NEW_BLOCK='{
  "type": "command",
  "command": "bash $HOME/.claude/statusline-command.sh",
  "refreshInterval": 60
}'

# subagentStatusLine renders a custom row body per subagent in the agent panel.
# Its payload is task metadata only (no per-subagent model/context), so the
# script shows agent type/name + live token usage as the honest proxy.
SUB_BLOCK='{
  "type": "command",
  "command": "bash $HOME/.claude/subagent-statusline-command.sh"
}'

if [ ! -f "$SETTINGS" ]; then
  echo "Creating $SETTINGS"
  echo '{}' > "$SETTINGS"
fi

TMP=$(mktemp)
if jq --argjson block "$NEW_BLOCK" --argjson sub "$SUB_BLOCK" \
     '.statusLine = $block | .subagentStatusLine = $sub' "$SETTINGS" > "$TMP"; then
  mv "$TMP" "$SETTINGS"
  echo "Updated $SETTINGS .statusLine + .subagentStatusLine"
else
  rm -f "$TMP"
  echo "WARNING: failed to merge status line blocks into $SETTINGS (left untouched)"
fi

echo "Claude Code status line installed."
