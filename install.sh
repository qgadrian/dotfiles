#!/bin/sh

set -e

echo "\n########################"
echo "########################"
echo "Start setting up the system"
echo "########################"
echo "########################\n"

source ./brew/install.sh

source ./mac/config.sh

source ./zsh/install.sh

source ./asdf/install.sh

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
echo "########################"
echo "########################\n"
