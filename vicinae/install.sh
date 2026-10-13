echo "Install Vicinae"

if [ ! -d /Applications/Vicinae.app ]; then
  brew install --cask vicinae
fi

# Shared config: import this repo's file from the local, GUI-managed settings.json.
SETTINGS=~/.config/vicinae/settings.json
mkdir -p ~/.config/vicinae
if [ ! -f "$SETTINGS" ]; then
  printf '{\n  "imports": ["%s"]\n}\n' "$(pwd)/vicinae/vicinae.jsonc" > "$SETTINGS"
elif ! grep -q 'vicinae/vicinae.jsonc' "$SETTINGS"; then
  echo "\t* Add \"$(pwd)/vicinae/vicinae.jsonc\" to the imports array in $SETTINGS"
fi

# Personal data synced via iCloud Drive. Only link files that already exist there:
# a dangling link would make Vicinae write an empty file into iCloud.
DATA=~/Documents/work/files/vicinae
LOCAL=~/.local/share/vicinae
link() {
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    echo "\t* $2 exists and is not a link, move its contents to $1 first"
  elif [ -e "$1" ]; then
    mkdir -p "$(dirname "$2")"
    ln -sfn "$1" "$2"
  else
    echo "\t* Missing $1 (iCloud not synced yet?), skipped linking $2"
  fi
}
link "$DATA/data/shortcuts.json" "$LOCAL/shortcuts/shortcuts.json"
link "$DATA/data/snippets.json" "$LOCAL/snippets/snippets.json"
link "$DATA/scripts" "$LOCAL/scripts"
