brew install mas

echo "Please sign in in the AppStore first"

read -p "Did you sign in in the AppStore? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Fast RAW preview
    mas install 963507809
    # Quick calendar
    mas install 1004514425
    # Darkroom
    mas install 953286746
    # Pixelmator Pro
    mas install 1289583905
fi
