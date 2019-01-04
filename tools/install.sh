echo "Install tools"

brew install \
	watch \
	htop \
	gettext \
	ack \
	automake \
  nmap \

brew cask install \
	bettertouchtool \
	dash \

brew link --force gettext

