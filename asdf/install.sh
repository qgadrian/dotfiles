echo "Install asdf"

# asdf team had the wonderful idea of return non 0 exit codes when plugins exist or
# are installed
set +e

# install asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
fi

# setup zsh
# echo '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
# echo '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
# echo '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
# echo '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

source ~/.bash_profile

# Support legacy files
echo 'legacy_version_file = yes' >> ~/.asdfrc

# setup asdf deps
brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc

echo "Install asdf plugins"

# Needed for Erlang
brew install autoconf wxmac

# exclude java deps with erlang installation
# echo "\n#Disable jvm when installing asdf plugins\n\nexport KERL_CONFIGURE_OPTIONS=\"--disable-debug --without-javac\"" >> ~/.zshrc

asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add ruby # if having any problem with ruby, try run `asdf reshim ruby`
asdf plugin-add terraform
asdf plugin-add haskell
asdf plugin-add rust
asdf plugin-add postgres
# To update GPG keys run:
# ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf plugin-add nodejs
asdf plugin-add golang
asdf plugin-add kubectl
asdf plugin-add python

ELIXIR_VERSION=1.13.2-otp-24
ERLANG_VERSION=24.2
HASKELL_VERSION=9.2.1
RUST_VERSION=1.58.1
TERRAFORM_VERSION=1.1.4
POSTGRES_VERSION=14.1
NODEJS_VERSION=17.4.0
RUBY_VERSION=2.7.2
GOLANG_VERSION=1.17.6
KUBECTL_VERSION=1.23.4
PYTHON_VERSION=2.7.18

asdf install elixir $ELIXIR_VERSION-otp-22
asdf install erlang $ERLANG_VERSION
asdf install terraform $TERRAFORM_VERSION
asdf install haskell $HASKELL_VERSION
asdf install rust $RUST_VERSION
asdf install postgres $POSTGRES_VERSION
asdf install nodejs $NODEJS_VERSION
asdf install ruby $RUBY_VERSION
asdf install golang $GOLANG_VERSION
asdf install kubectl $KUBECTL_VERSION
asdf install python $PYTHON_VERSION

asdf global erlang $ERLANG_VERSION
asdf global elixir $ELIXIR_VERSION-otp-22
asdf global terraform $TERRAFORM_VERSION
asdf global haskell $HASKELL_VERSION
asdf global rust $RUST_VERSION
asdf global postgres $POSTGRES_VERSION
asdf global nodejs $NODEJS_VERSION
asdf global ruby $RUBY_VERSION
asdf global golang $GOLANG_VERSION
asdf global kubectl $KUBECTL_VERSION
asdf global python $PYTHON_VERSION

# If there is a permissions problem with asdf
# sudo chown -R $(whoami) ~/.asdf

# To make ruby work with ARM a host
# /usr/local/Homebrew/bin/brew install libffi libyaml zlib readline

set -e
