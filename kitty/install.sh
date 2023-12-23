echo "Install kitty"

brew install kitty

ln -sf $(pwd)/kitty/.config/kitty ~/.config/

# set custom icon for kitty app
# https://sw.kovidgoyal.net/kitty/faq/#i-do-not-like-the-kitty-icon
# https://github.com/k0nserv/kitty-icon
KITTY_CONFIG_PATH=~/.config/kitty
KITTY_ICNS_PATH=$KITTY_CONFIG_PATH/kitty.app.icns
KITTY_PNG_PATH=$KITTY_CONFIG_PATH/kitty.app.png

wget https://github.com/k0nserv/kitty-icon/raw/main/build/outrun.icns -O $KITTY_ICNS_PATH
wget https://github.com/k0nserv/kitty-icon/blob/7f631a61bcbdfb268cdf1c97992a5c077beec9d6/build/outrun.iconset/icon_512x512%402x.png -O $KITTY_PNG_PATH

kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' $KITTY_ICNS_PATH
kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' $KITTY_PNG_PATH /Applications/kitty.app

# rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
