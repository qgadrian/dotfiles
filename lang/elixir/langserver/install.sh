echo "Install Elixir LS"

OLD_PWD=$(pwd)

mkdir ~/.vim/elixir-ls
git clone https://github.com/elixir-lsp/elixir-ls.git ~/.vim/elixir-ls/

cd ~/.vim/elixir-ls

mix deps.get
mix compile

MIX_ENV=prod mix elixir_ls.release -o ./rel

cd $OLD_PWD
