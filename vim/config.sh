echo "Install vimrc"

brew install macvim

#brew cask install xquartz
#brew install vim --with-client-server

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# If python crashses at start: ./install.py --clang-completer

mv ~/.vimrc ~/.vimrc.old.deleteme
ln -s $(pwd)/vimrc ~/.vimrc

mkdir ~/.vim/backup
mkdir ~/.vim/swp
mkdir ~/.vim/undo

vim +PluginInstall +qall

#
# You complete me
#

# Needed by 'youcompleteme'
brew install cmake

# mkdir YouCompleteMe/ycmbuild
mkdir ~/.vim/bundle/YouCompleteMe/ycmbuild
# cd YouCompleteMe/ycmbuild
# cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/
cmake -G "Unix Makefiles" -B ~/.vim/bundle/YouCompleteMe/ycmbuild -S ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/
# make ycm_core
make -C ~/.vim/bundle/YouCompleteMe/ycmbuild ycm_core

#
# Fuzzy search deps
#

brew install the_silver_searcher

#
# Nerd fonts
#

echo "Install nerd fonts"

brew tap caskroom/fonts
brew cask install font-meslo-nerd-font

# Needed by markdown preview
brew install grip

echo "Install spell checks"
#mv ~/.vim/spell/ ~/.vim/spell.deleteme
mkdir ~/.vim/spell
ln -s $(pwd)/spell ~/.vim/spell

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
pip3 install neovim-remote# map cmd+v        paste_from_clipboard
