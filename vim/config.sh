echo "Install vimrc"

brew install neovim

# Vim-plug

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# If python crashes at start: ./install.py --clang-completer

if [ -d ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.old.$(date +%Y%m%d%H%M%S)
fi

ln -sf $(pwd)/vim/vimrc ~/.vimrc
ln -sf $(pwd)/vim/config/ ~/.vim/config
ln -sf $(pwd)/vim/.config/ ~/.config/nvim

mkdir ~/.vim/backup
mkdir ~/.vim/swp
mkdir ~/.vim/undo
mkdir ~/.vim/sessions

vim +PluginInstall +qall

#
# CoC needs to install LanguageServer engines
#
# Install CoC example:
# :CoCInstall coc-elixir

#
# Fuzzy search deps
#

brew install the_silver_searcher

#
# Nerd fonts
#

#echo "Install nerd fonts"

#brew tap caskroom/fonts
#brew cask install font-meslo-nerd-font

# Needed by markdown preview
brew install grip

echo "Install spell checks"
#mv ~/.vim/spell/ ~/.vim/spell.deleteme
mkdir ~/.vim/spell
ln -s $(pwd)/vim/spell ~/.vim/spell

# Neded by command-t
# cd /Users/adrian/.vim/bundle/command-t && rake make

#
# neovim
#

brew install neovim
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath = &runtimepath\nsource ~/.vimrc" > ~/.config/nvim/init.vim

# neovim
pip3 install neovim-remote

# dasht

git clone git@github.com:sunaku/dasht.git $(pwd)/vim

# wget its a depdency to get the docsets
# w3m its needed to display the results
brew install wget w3m

cp $(pwd)/vim/dasht/bin/* /usr/local/bin
cp $(pwd)/vim/dasht/man/man1/* /usr/local/share/man/man1

# install docsets
dasht-docsets-install elixir

#install rust fixer
rustup component add rustfmt
