echo "Install tools"

brew install \
  watch \
  wget \
  htop \
  gettext \
  ack \
  automake \
  nmap \
  telnet \
  npm \
  gh\
  bat \
  ripgrep \
  fzf \
  lsd \
  dive \
  graphviz \
  rename \
  gh \
  go-jira \
  firefox \
  smartmontools \
  watchman \
  terminal-notifier \
  speedtest-cli \
  rpl \
  viu \
  lsusb \
  gsed \
  mcfly \
  zoxide \

brew install --cask \
  openvpn-connect \
  appcleaner \

brew link --force gettext

# mqtt cli
brew install emqx/mqttx/mqttx-cli

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

read -p "Install apps from the AppStore? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    source $(pwd)/tools/mas/install.sh
fi

source $(pwd)/tools/navi/install.sh
source $(pwd)/tools/slack/install.sh
source $(pwd)/tools/peco/install.sh
