echo "Install zsh and ohmyzsh"

brew install zsh

echo "Setting zsh as default shell"

# WARNING: The installation script will change the console and it will require to relaunch the installation script
if [ -f ~/.oh-my-zsh ]; then
  echo "Install oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

#echo "Install zplug"

#curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

echo "Install powerline"

#sh -c "$(curl -fsSL https://raw.githubusercontent.com/powerline/fonts/master/install.sh)"

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
./fonts/install.sh
rm -rf fonts

echo "Cleaning old zsh data"
OLD_MV_TIMESTAMP=$(date +%Y%m%d%H%M%S)

#cp .zshrc ~/.zshrc
if [ -f ~/.zshrc ]; then
  echo "Moving old .zshrc to .zshrc.old.deleteme"
  mv ~/.zshrc ~/.zshrc.old.$OLD_MV_TIMESTAMP
fi

if [ -d ~/.zsh ]; then
  echo "Moving old .zsh/ to .zsh.old.deleteme/"
  mv ~/.zsh ~/.zsh.old.$OLD_MV_TIMESTAMP
fi

if [ ! -d ~/.zsh ]; then
  mkdir ~/.zsh
fi

ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/zsh/profiles ~/.zsh/

# Themes

echo "Install ZSH themes"

export ZSH_CUSTOM="$ZSH/custom"

rm -rf $ZSH_CUSTOM/themes/powerlevel10k
rm -rf $ZSH_CUSTOM/themes/lambda-zsh/

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/cdimascio/lambda-zsh-theme.git $ZSH_CUSTOM/themes/lambda-zsh/

# Pure power theme for powerlevel10k
ln -sf $(pwd)/zsh/.purepower ~/.zsh/.purepower

#brew install npm
#npm install -g spaceship-prompt pure-prompt
