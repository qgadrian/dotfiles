echo "Install vimrc"

brew install macvim

#brew cask install xquartz
#brew install vim --with-client-server

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Needed by 'youcompleteme'
brew install cmake
# mkdir YouCompleteMe/ycmbuild
# cd YouCompleteMe/ycmbuild
# cmake -G "Unix Makefiles" . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/
# make ycm_core

# If python crashses at start: ./install.py --clang-completer

mv ~/.vimrc ~/.vimrc.old.deleteme
# ln -s .vimrc_suggestion ~/.vimrc
cp .vimrc_suggestion ~/.vimrc

mkdir ~/.vim/backup
mkdir ~/.vim/swp
mkdir ~/.vim/undo

vim +PluginInstall +qall
