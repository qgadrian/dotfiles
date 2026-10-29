brew install docker docker-compose
brew install colima

mkdir -p ~/.colima/default
ln -sf "$(pwd)/containers/colima/colima.yml" ~/.colima/default/colima.yaml

# enable autostart
brew services start colima
