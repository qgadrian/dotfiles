echo "Install automatic map change from caps lock to escape"

ln -s $(pwd)/mac/keyboard/com.capslockEsc.plist ~/Library/LaunchAgents/com.capslockEsc.plist
launchctl load com.capslockEsc.plist
