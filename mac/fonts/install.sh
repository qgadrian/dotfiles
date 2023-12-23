echo "Install fonts"

brew install wget 

find . -type f -exec sudo cp '{}' ~/Library/Fonts/ \;

wget https://github.com/githubnext/monaspace/releases/download/v1.000/monaspace-v1.000.zip
unzip monaspace-v1.000.zip
./monospace-v1.000/util/install_macos.sh
