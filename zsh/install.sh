echo "Install zsh and ohmyzsh"

brew install zsh

echo "Setting zsh as default shell"

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install zplug"

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo "Install powerline"

#sh -c "$(curl -fsSL https://raw.githubusercontent.com/powerline/fonts/master/install.sh)"

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts

#cp .zshrc ~/.zshrc
if [ -f ~/.zshrc ]; then
	mv ~/.zshrc ~/.zshrc.old.deleteme
fi

if [ -d ~/.zsh ]; then
  mv ~/.zsh ~/.zsh.old.deleteme
fi

ln -s $(pwd)/.zshrc ~/.zshrc
mkdir ~/.zsh
ln -s $(pwd)/profiles ~/.zsh
