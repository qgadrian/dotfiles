#!/bin/bash

read -p "Configure the Keyboard? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
      defaults write -g ApplePressAndHoldEnabled -bool true
      defaults write -g InitialKeyRepeat -int 10
      defaults write -g KeyRepeat -int 1

  echo "Changes will be applied after restart"
fi

echo "Setting macOS configurations (restart required to apply some of them)"

# Disable auto rearrange spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# killall Dock

# Hide removable media on desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowPathbar -bool false

# Enable tap to click preference (restart required)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Trackpad speed
defaults write -g com.apple.trackpad.scaling -float 1

read -p "Install rosetta? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Install rosetta"
    sudo softwareupdate --install-rosetta --agree-to-license
fi

read -p "Install command line tools? (the install will fail if already installed) " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Install command line tools"
    xcode-select --install
fi

# Automatic Restart on System Freeze
#sudo systemsetup -setrestartfreeze on

# Enable Firewall
#sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Show All File Extensions
#defaults write -g AppleShowAllExtensions -bool true

# Show Full Path in Finder Title
#defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

source $(pwd)/mac/plugins/install.sh

source $(pwd)/mac/window_management/install.sh

read -p "Install fonts? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    source $(pwd)/mac/fonts/install.sh
fi

