echo "Install fonts"

find . -type f -exec sudo cp '{}' ~/Library/Fonts/ \;

# monaspace: https://github.com/githubnext/monaspace#macos
brew tap homebrew/cask-fonts
brew install font-monaspace
