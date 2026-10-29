echo "==> Installing Docker CLI & Compose (if needed)…"
brew install docker docker-compose

echo "==> Installing OrbStack…"
brew install --cask orbstack

echo "==> Starting OrbStack VM (headless)…"
if command -v orb &>/dev/null; then
  orb start
else
  echo "⚠️  'orb' not found in PATH; open OrbStack.app once to finish setup."
fi
