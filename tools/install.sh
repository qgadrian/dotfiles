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
  bat \

brew cask install \
  bettertouchtool \
  slack \
  dash \
  firefox \

brew link --force gettext

# enhancd
# https://github.com/b4b4r07/enhancd#installation
brew tap jhawthorn/fzy
git clone https://github.com/b4b4r07/enhancd
mv enhancd ~/.enhancd
