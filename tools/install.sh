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
  gh\
  peco \
  bat \
  ripgrep \
  lsd \
  dive \
  prettier \
  graphviz \
  rename \
  github/gh/gh \
  go-jira \
  bettertouchtool \
  slack \
  firefox \
  activitywatch \
  smartmontools \
  watchman \
  terminal-notifier \
  speedtest-cli \
  rpl \
  viu \

brew link --force gettext

# enhancd
# https://github.com/b4b4r07/enhancd#installation
brew tap jhawthorn/fzy

rm -rf ~/.enhancd
git clone https://github.com/b4b4r07/enhancd ~/.enhancd

# alt
# https://github.com/uptech/alt
brew tap "uptech/homebrew-oss"
brew install uptech/oss/alt

# https://github.com/sharkdp/fd
brew install fd

source $(pwd)/tools/mas/install.sh

source $(pwd)/tools/navi/install.sh
