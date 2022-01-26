# https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md
echo "Setup navi"

brew install navi

ln -sf $(pwd)/tools/navi/config.yaml ~/Library/Application\ Support/navi/config.yaml

mkdir -p ~/.navi/
ln -sf $(pwd)/tools/navi/cheats ~/.navi/cheats
