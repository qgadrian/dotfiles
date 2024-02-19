echo "Installing peco..."

brew install peco

mkdir -p ~/.config/peco
ln -sf $(pwd)/tools/peco/config.json ~/.config/peco/config.json
