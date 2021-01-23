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
  ripgrep \
  lsd \
  navi \
  dive \
  prettier \
  graphviz \
  rename \
  github/gh/gh \
  go-jira \

brew cask install \
  bettertouchtool \
  slack \
  dash \
  firefox \
  activitywatch \

brew link --force gettext

# enhancd
# https://github.com/b4b4r07/enhancd#installation
brew tap jhawthorn/fzy
git clone https://github.com/b4b4r07/enhancd
mv enhancd ~/.enhancd

# alt
# https://github.com/uptech/alt
brew tap "uptech/homebrew-oss"
brew install uptech/oss/alt

# https://github.com/sharkdp/fd
brew install fd
