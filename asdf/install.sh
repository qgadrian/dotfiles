echo "Install asdf"

# install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0

# setup zsh
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

# setup asdf deps
brew coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc

echo "Install asdf plugins"

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
