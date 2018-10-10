echo "Install zsh and ohmyzsh"

brew install zsh

echo "Setting zsh as default shell"

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install powerline"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/powerline/fonts/master/install.sh)"
