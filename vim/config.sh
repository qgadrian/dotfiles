echo "Install vimrc"

brew tap jason0x43/homebrew-neovim-nightly
brew cask install neovim-nightly

# for mac m1
#brew install cmake luarocks luv
#brew install -s --HEAD neovim

######
# Package manager
#####

# Vim-plug
#curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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
rm -rf ~/.vim/spell
ln -s $(pwd)/vim/spell ~/.vim/spell

# Neded by command-t
# cd /Users/adrian/.vim/bundle/command-t && rake make

# neovim
pip3 install neovim-remote

# wget its a depdency to get the docsets
# w3m its needed to display the results
brew install wget w3m

#install rust fixer
rustup component add rustfmt
