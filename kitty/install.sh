echo "Install kitty"

brew install kitty

mkdir -p ~/.config/kitty
ln -sf $(pwd)/kitty/.config/kitty ~/.config/kitty
