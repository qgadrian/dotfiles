echo "Install yabai"

# https://github.com/koekeishiya/yabai

brew tap koekeishiya/formulae
brew install yabai jq
ln -sf $(pwd)/window_management/yabairc ~/.yabairc
#sudo yabai --install-sa
brew services start yabai

echo "Install skhd"

brew install koekeishiya/formulae/skhd
ln -sf $(pwd)/window_management/skhdrc ~/.skhdrc
brew services start skhd
