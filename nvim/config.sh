echo "Install nvim"

brew install neovim

# dependencies for some plugins
brew install make cmake luarocks

######
# Package manager
#####

# packer.nvim
# git clone https://github.com/wbthomason/packer.nvim \
#  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
#
# # If python crashes at start: ./install.py --clang-completer
#
# if [ -d ~/.vimrc ]; then
#   mv ~/.vimrc ~/.vimrc.old.$(date +%Y%m%d%H%M%S)
# fi

ln -sf $(pwd)/nvim ~/.config/nvim
rm -rf ~/.config/nvim/.git
# ln -sf $(pwd)/vim/config/vim ~/.config/
# ln -sf $(pwd)/vim/config/nvim ~/.config/

mkdir -p ~/.config/nvim/backup
mkdir -p ~/.config/nvim/swp
mkdir -p ~/.config/nvim/undo
mkdir -p ~/.config/nvim/sessions

# vim +PluginInstall +qall

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

# echo "Install spell checks"
# rm -rf ~/.config/nvim/spell
# ln -s $(pwd)/nvim/spell ~/.config/nvim/spell

# Neded by command-t
# cd /Users/adrian/.vim/bundle/command-t && rake make

# neovim
# pip3 install neovim-remote

# wget its a dependency to get the docsets
# w3m its needed to display the results
brew install wget w3m
