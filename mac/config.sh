#!/bin/bash

read -p "Configure the Keyboard? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
      defaults write -g ApplePressAndHoldEnabled -bool true
      defaults write -g InitialKeyRepeat -int 10
      defaults write -g KeyRepeat -int 1

  echo "Changes will be applied after restart"
fi

echo "Disable auto rearrange spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false
# killall Dock

source $(pwd)/mac/plugins/install.sh

source $(pwd)/mac/window_management/install.sh

source $(pwd)/mac/fonts/install.sh
