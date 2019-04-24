echo "Install chunkwm"

# https://koekeishiya.github.io/chunkwm/docs/userguide.html

brew tap koekeishiya/formulae
brew install chunkwm
ln -sf $(pwd)/window_management/chunkwmrc ~/.chunkwmrc
brew services start chunkwm

echo "Install skhd"

brew install koekeishiya/formulae/skhd
ln -sf $(pwd)/window_management/skhdrc ~/.skhdrc
brew services start skhd
