echo "Install tools"

brew install \
	watch \
	htop \
	gettext \
	dash \
	ack \

brew cask install bettertouchtool

brew link --force gettext

