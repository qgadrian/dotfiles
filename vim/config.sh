echo "Install vimrc"

brew install neovim

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# If python crashes at start: ./install.py --clang-completer

mv ~/.vimrc ~/.vimrc.old.deleteme
ln -s $(pwd)/vim/vimrc ~/.vimrc

mkdir ~/.vim/backup
mkdir ~/.vim/swp
mkdir ~/.vim/undo

vim +PluginInstall +qall

#
# linters
#

echo "Install Elixir LS"
OLD_PWD=$(pwd)
mkdir ~/.vim/elixir-ls
git clone https://github.com/JakeBecker/elixir-ls.git ~/.vim/elixir-ls/
cd ~/.vim/elixir-ls
mix deps.get
MIX_ENV=prod mix elixir_ls.release -o ./rel
cd $OLD_PWD

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
