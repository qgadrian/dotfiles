brew install docker docker-compose docker-buildx docker-credential-helper
brew install colima

# Docker only finds Homebrew's plugins when they are linked or configured
mkdir -p ~/.docker/cli-plugins
for plugin in docker-buildx docker-compose; do
  ln -sfn "$(brew --prefix)/opt/$plugin/bin/$plugin" ~/.docker/cli-plugins/$plugin
done

# Generated, not symlinked: cpu and memory differ per device. Defaults to half the
# machine; an existing file is kept, so local tuning survives a re-run.
colima_config=~/.colima/default/colima.yaml
if [ ! -e "$colima_config" ]; then
  mkdir -p ~/.colima/default
  cpu=$(($(sysctl -n hw.ncpu) / 2))
  memory=$(($(sysctl -n hw.memsize) / 1073741824 / 2))
  sed -E "s/^cpu: .*/cpu: $cpu/; s/^memory: .*/memory: $memory/" \
    "$(pwd)/containers/colima/colima.yml" >"$colima_config"
fi

# enable autostart
brew services start colima
