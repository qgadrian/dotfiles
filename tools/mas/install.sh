brew install mas

echo "Please sign in in the AppStore first"

read -p "Did you sign in in the AppStore? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Fast RAW preview
    mas install $(mas search "raw right away" | head -n 1 | awk '{print $1}')
    # Quick View calendar
    mas install $(mas search "quick view calendar" | head -n 1 | awk '{print $1}')
    # Pixelmator Apps
    mas install $(mas search "pixelmator pro" | head -n 1 | awk '{print $1}')
    mas install $(mas search "photomator" | head -n 1 | awk '{print $1}')
    mas install $(mas search "Slack for Desktop" | head -n 1 | awk '{print $1}')
fi
