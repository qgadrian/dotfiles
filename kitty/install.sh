echo "Install kitty"

if ! command -v kitty &> /dev/null; then
  brew install kitty
fi

ln -sf $(pwd)/kitty/.config/kitty ~/.config/

# set custom icon for kitty app
# https://sw.kovidgoyal.net/kitty/faq/#i-do-not-like-the-kitty-icon
# https://github.com/k0nserv/kitty-icon
CONFIG_PATH=~/.config/kitty
ICNS_PATH=$CONFIG_PATH/kitty.app.icns
PNG_PATH=$CONFIG_PATH/kitty.app.png
ICON_NAME=neue_toxic

wget https://github.com/k0nserv/kitty-icon/raw/main/build/$ICON_NAME.icns -O $ICNS_PATH
wget https://raw.githubusercontent.com/k0nserv/kitty-icon/main/build/$ICON_NAME.iconset/icon_256x256.png -O $PNG_PATH

kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' $ICNS_PATH
kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' $PNG_PATH /Applications/kitty.app

rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
