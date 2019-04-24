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

asdf install elixir 1.7
asdf install elixir 1.7-otp-21
asdf install erlang 20.3
asdf install erlang 21.2
asdf install ruby 2.3.7

asdf global erlang 21.2
asdf global elixir 1.7-otp-21
asdf global ruby 2.3.7

