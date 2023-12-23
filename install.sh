#!/bin/sh

set -e

echo "\n########################"
echo "########################"
echo "Start setting up the system"
echo "########################"
echo "########################\n"

source ./brew/install.sh

# git-crypt is not fully ready yet
# source ./before_setup.sh

source ./mac/config.sh

source ./zsh/install.sh

source ./asdf/install.sh

source ./alfred/install.sh

source ./lang/config.sh

source ./git/config.sh

source ./docker/install.sh

source ./kitty/install.sh

source ./tools/install.sh

source ./vim/config.sh

source ./karabiner/install.sh

echo "\n########################"
echo "########################"
echo "Done!"
echo "\n\nThings to do now:\n"
echo "\n\t* Restart the computer"
echo "\n\t* Start accepting the \"unverified developer madness\""
echo "\n\t* Setup signed commits"
echo "\n\t* Open KarabinerElements and complete the setup"
echo "\n\t* Update Firefox to avoid exit full screen on escape (about:config ->
browser.fullscreen.exit_on_escape)"
echo "\n"
echo "########################"
echo "########################\n"
