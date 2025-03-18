echo "Install zsh and ohmyzsh"

brew install zsh

echo "Setting zsh as default shell"

echo "WARNING: oh-my-zsh will be installed now. Once installed, type `exit` on the new terminal session to continue with the installation"
read -p "Type (c)ontinue now to proceed with the oh-my-zsh installation or other key to skip this step: " -n 1 -r; echo
  if [[ $REPLY =~ ^[Cc]$ ]]; then
    rm -rf $HOME/.oh-my-zsh
    echo "Install oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

echo "Cleaning old zsh data"
OLD_MV_TIMESTAMP=$(date +%Y%m%d%H%M%S)

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

ln -sf $(pwd)/zsh/.zshrc /Users/$(whoami)/.zshrc
ln -sf $(pwd)/zsh/profiles /Users/$(whoami)/.zsh/
ln -sf $(pwd)/zsh/local /Users/$(whoami)/.zsh/

mkdir /Users/$(whoami)/.zsh/local
touch /Users/$(whoami)/.zsh/local/example

# Themes

echo "Install ZSH themes"

export ZSH=~/.oh-my-zsh
export ZSH_CUSTOM="$ZSH/custom"

if [ ! -d $ZSH_CUSTOM/themes/powerlevel10k ]; then
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

if [ ! -d $ZSH_CUSTOM/themes/lambda-zsh/ ]; then
  git clone https://github.com/cdimascio/lambda-zsh-theme.git $ZSH_CUSTOM/themes/lambda-zsh/
fi

# Pure power theme for powerlevel10k
ln -sf $(pwd)/zsh/.purepower ~/.zsh/.purepower
