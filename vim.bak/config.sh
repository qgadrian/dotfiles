echo "Install vimrc"

brew install neovim

# dependencies for some plugins
brew install make cmake

######
# Package manager
#####

# packer.nvim
git clone https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# If python crashes at start: ./install.py --clang-completer

if [ -d ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.old.$(date +%Y%m%d%H%M%S)
fi

ln -sf $(pwd)/vim/vimrc ~/.vimrc
ln -sf $(pwd)/vim/config/vim ~/.config/
ln -sf $(pwd)/vim/config/nvim ~/.config/

mkdir -p ~/.vim/backup
mkdir -p ~/.vim/swp
mkdir -p ~/.vim/undo
mkdir -p ~/.vim/sessions

vim +PluginInstall +qall

#
# Fuzzy search deps
#

brew install the_silver_searcher

#
# Nerd fonts
#

#echo "Install nerd fonts"

#brew tap caskroom/fonts
#brew install font-meslo-nerd-font

# Needed by markdown preview
brew install grip

echo "Install spell checks"
rm -rf ~/.vim/spell
ln -s $(pwd)/vim/spell ~/.vim/spell

# Neded by command-t
# cd /Users/adrian/.vim/bundle/command-t && rake make

# neovim
pip3 install neovim-remote

# wget its a dependency to get the docsets
# w3m its needed to display the results
brew install wget w3m
