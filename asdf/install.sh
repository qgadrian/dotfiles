echo "Install asdf"

# asdf team had the wonderful idea of return non 0 exit codes when plugins exist or
# are installed
set +e

# install asdf dependencies
brew install coreutils curl git openssl
# install ruby dependencies
brew install openssl

# install asdf
brew install asdf

# asdf is automatically configured via the `oh-my-zsh` plugin
# check the ZSH manual configuration here: https://asdf-vm.com/guide/getting-started.html
# if you are not using `oh-my-zsh` you can add the following line to your `.zshrc` file
# echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc

# Support legacy files
echo 'legacy_version_file = yes' >>~/.asdfrc

# setup asdf deps
brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc

echo "Install asdf plugins"

# Needed for Erlang
brew install autoconf wxmac

# exclude java deps with erlang installation
# echo "\n#Disable jvm when installing asdf plugins\n\nexport KERL_CONFIGURE_OPTIONS=\"--disable-debug --without-javac\"" >> ~/.zshrc

# options needed for ruby to install
export RUBY_CONFIGURE_OPTS="--disable-install-doc --with-openssl-dir=$(brew --prefix openssl)"

asdf plugin add erlang
asdf plugin add elixir
asdf plugin add ruby # if having any problem with ruby, try run `asdf reshim ruby`
asdf plugin add terraform
asdf plugin add haskell
asdf plugin add rust
# asdf plugin-add postgres
# To update GPG keys run:
# ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf plugin add nodejs
asdf plugin add pnpm
asdf plugin add golang
asdf plugin add kubectl
asdf plugin add python

ELIXIR_VERSION=latest
ERLANG_VERSION=latest
RUST_VERSION=latest
TERRAFORM_VERSION=latest
POSTGRES_VERSION=latest
NODEJS_VERSION=latest
RUBY_VERSION=latest
GOLANG_VERSION=latest
KUBECTL_VERSION=latest
PYTHON_VERSION=latest
PNPM_VERSION=latest

asdf install elixir $ELIXIR_VERSION
asdf install erlang $ERLANG_VERSION
asdf install terraform $TERRAFORM_VERSION
asdf install rust $RUST_VERSION
asdf install postgres $POSTGRES_VERSION
asdf install nodejs $NODEJS_VERSION
asdf install ruby $RUBY_VERSION
asdf install golang $GOLANG_VERSION
asdf install kubectl $KUBECTL_VERSION
asdf install python $PYTHON_VERSION

asdf set -u erlang $ERLANG_VERSION
asdf set -u elixir $ELIXIR_VERSION
asdf set -u terraform $TERRAFORM_VERSION
asdf set -u rust $RUST_VERSION
# asdf set postgres $POSTGRES_VERSION
asdf set -u nodejs $NODEJS_VERSION
asdf set -u pnpm $PNPM_VERSION
asdf set -u ruby $RUBY_VERSION
asdf set -u golang $GOLANG_VERSION
asdf set -u kubectl $KUBECTL_VERSION
asdf set -u python $PYTHON_VERSION

# for refefence, if ever want to install java (e.g. android development)
# asdf plugin add java
# asdf install java temurin-17.0.11+9
# asdf global java temurin-17.0.11+9

# If there is a permissions problem with asdf
# sudo chown -R $(whoami) ~/.asdf

# To make ruby work with ARM a host
# /usr/local/Homebrew/bin/brew install libffi libyaml zlib readline

set -e
