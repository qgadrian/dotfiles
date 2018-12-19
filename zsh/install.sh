echo "Install zsh and ohmyzsh"

brew install zsh

echo "Setting zsh as default shell"

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install powerline"

#sh -c "$(curl -fsSL https://raw.githubusercontent.com/powerline/fonts/master/install.sh)"

# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

cp .zshrc ~/.zshrc
# mkdir ~/.zsh
cp -r ./profiles ~/.zsh
