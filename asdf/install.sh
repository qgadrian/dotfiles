echo "Install asdf"

# install asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
fi

# setup zsh
echo '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
echo '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
echo '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

source ~/.bash_profile

# setup asdf deps
brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc

echo "Install asdf plugins"

# Needed for Erlang
brew install autoconf wxmac

# exclude java deps with erlang installation
echo "\n#Disable jvm when installing asdf plugins\n\nexport KERL_CONFIGURE_OPTIONS=\"--disable-debug --without-javac\"" >> ~/.zshrc

asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add ruby
asdf plugin-add terraform
asdf plugin-add haskell
asdf plugin-add rust
asdf plugin-add elm

ELIXIR_VERSION=1.8
ERLANG_VERSION=21.3
HASKELL_VERSION=8.6.5
RUST_VERSION=1.34.1
TERRAFORM_VERSION=0.12.0
ELM_VERSION=0.19.0

asdf install elixir $ELIXIR_VERSION-otp-21
asdf install erlang $ERLANG_VERSION
asdf install terraform $TERRAFORM_VERSION
asdf install haskell $HASKELL_VERSION
asdf install rust $RUST_VERSION
asdf install elm $ELM_VERSION

asdf global erlang $ERLANG_VERSION
asdf global elixir $ELIXIR_VERSION-otp-21
asdf global terraform $TERRAFORM_VERSION
asdf global haskell $HASKELL_VERSION
asdf global rust $RUST_VERSION
asdf global elm $ELM_VERSION
