echo "Install tools"

brew install \
  ack \
  automake \
  bat \
  dive \
  firefox \
  fzf \
  ffmpeg \
  gettext \
  gh go-jira \
  graphviz \
  gsed \
  htop \
  launchcontrol \
  lsd \
  lsusb \
  mcfly \
  nmap \
  npm \
  peco \
  rename \
  ripgrep \
  rpl \
  smartmontools \
  speedtest-cli \
  telnet \
  terminal-notifier \
  trash \
  viu \
  watch \
  watchman \
  wget

brew install --cask \
  openvpn-connect \
  appcleaner

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

read -p "Install apps from the AppStore? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  source $(pwd)/tools/mas/install.sh
fi

source $(pwd)/tools/navi/install.sh
source $(pwd)/tools/slack/install.sh
source $(pwd)/tools/peco/install.sh
