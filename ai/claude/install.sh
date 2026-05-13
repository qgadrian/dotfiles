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
SRC_SCRIPT="$(pwd)/ai/claude/statusline-command.sh"
DST_SCRIPT="$CLAUDE_DIR/statusline-command.sh"

mkdir -p "$CLAUDE_DIR"

# Back up any pre-existing real file (not a symlink) so we don't lose it.
if [ -f "$DST_SCRIPT" ] && [ ! -L "$DST_SCRIPT" ]; then
  TS=$(date +%Y%m%d%H%M%S)
  echo "Backing up existing $DST_SCRIPT -> $DST_SCRIPT.old.$TS"
  mv "$DST_SCRIPT" "$DST_SCRIPT.old.$TS"
fi

echo "Linking $SRC_SCRIPT -> $DST_SCRIPT"
ln -sf "$SRC_SCRIPT" "$DST_SCRIPT"

# Merge the statusLine block into settings.json without clobbering other keys.
NEW_BLOCK='{
  "type": "command",
  "command": "bash $HOME/.claude/statusline-command.sh",
  "refreshInterval": 60
}'

if [ ! -f "$SETTINGS" ]; then
  echo "Creating $SETTINGS"
  echo '{}' > "$SETTINGS"
fi

TMP=$(mktemp)
if jq --argjson block "$NEW_BLOCK" '.statusLine = $block' "$SETTINGS" > "$TMP"; then
  mv "$TMP" "$SETTINGS"
  echo "Updated $SETTINGS .statusLine"
else
  rm -f "$TMP"
  echo "WARNING: failed to merge statusLine into $SETTINGS (left untouched)"
fi

echo "Claude Code status line installed."
