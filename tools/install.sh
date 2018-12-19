echo "Install tools"

brew install \
	watch \
	htop \
	gettext \
	ack \

brew cask install \
	bettertouchtool \
	dash \

brew link --force gettext

