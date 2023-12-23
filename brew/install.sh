
if [ ! -d /opt/homebrew/ ]; then
  echo "Install brew"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -d /opt/homebrew/ ]; then
  echo "brew is already installed, skipping"
fi

echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

# Needed for ARM chips
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc