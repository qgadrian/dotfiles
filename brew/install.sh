echo "Install brew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$(whoami)/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

brew tap homebrew/cask
