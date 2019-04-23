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
  slack \
  peco \

brew cask install \
  bettertouchtool \
  dash \
  firefox \

brew link --force gettext
