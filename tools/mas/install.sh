if ! command -v mas &> /dev/null
then
  echo "mas could not be found, installing"
  brew install mas
fi

function search_and_install() {
  SELECTED_APP=$(mas search "$1" | peco | head -n 1 | awk '{print $1}')

  mas install $SELECTED_APP
}

echo "You will need to confirm which apps from the store you want to install"
echo "Please sign in in the AppStore first"

read -p "Did you sign in in the AppStore? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    search_and_install "raw right away"
    search_and_install "quick view calendar"
    search_and_install "Pixelmator Pro"
    search_and_install "Photomator"
    search_and_install "Slack for Desktop"
    search_and_install "Infuse Video Player"
    search_and_install "WhatsApp Desktop"
    search_and_install "Telegram"
fi
