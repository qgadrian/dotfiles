read -p "Install xcode? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    XCODE_APP_ID=497799835

    mas install $XCODE_APP_ID

    sudo xcodebuild -license accept
fi
