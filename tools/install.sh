echo "Install tools"

brew install \
  watch \
  htop \
  gettext \
  ack \
  automake \
  nmap \
  telnet \
  npm \
  peco \

brew cask install \
  bettertouchtool \
  slack \
  dash \
  firefox \

brew link --force gettext
