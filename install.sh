#!/bin/sh

set -e

echo "\n########################\n"
echo "########################\n"
echo "Start configuring system"
echo "########################\n"
echo "########################\n"

source ./mac/config.sh

source ./brew/install.sh

source ./asdf/install.sh

source ./zsh/install.sh

source ./git/config.sh

source ./docker/install.sh

#source ./iterm2/install.sh

source ./kitty/install.sh

source ./plugins/install.sh

source ./tools/install.sh

source ./ansible/install.sh

source ./vim/config.sh

source ./window_manager/install.sh

echo "\n########################\n"
echo "########################\n"
echo "Done setting up the system"
echo "########################\n"
echo "########################\n"
