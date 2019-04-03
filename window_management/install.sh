echo "Install chunkwm"

# https://koekeishiya.github.io/chunkwm/docs/userguide.html

brew tap koekeishiya/formulae
brew install chunkwm
ln -sf $(pwd)/chunkwmrc ~/.chunkwmrc
brew services start chunkwm

echo "Install skhd"

brew install koekeishiya/formulae/skhd
ln -sf $(pwd)/skhdrc ~/.skhdrc
brew services start skhd
