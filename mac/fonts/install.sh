echo "Install fonts"

# find . -type f -exec sudo cp '{}' ~/Library/Fonts/ \;

# monaspace: https://github.com/githubnext/monaspace#macos
# regular fonts, not nerd fonts
# brew tap homebrew/cask-fonts
# brew install font-monaspace

# patched nerd fonts
CURRENT_DIR=$(pwd)/mac/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Monaspace.zip -O $CURRENT_DIR/Monaspace.zip
unzip $CURRENT_DIR/Monaspace.zip -d $CURRENT_DIR/Monaspace
cp $CURRENT_DIR/Monaspace/*.otf ~/Library/Fonts/
rm -rf $CURRENT_DIR/Monaspace.zip $CURRENT_DIR/Monaspace
