echo "Install tools"

brew install \
	watch \
	htop \
	gettext \
	ack \
	automake \
  nmap \
  telnet \

brew cask install \
	bettertouchtool \
	dash \

brew link --force gettext

