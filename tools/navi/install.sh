# https://github.com/denisidoro/navi/blob/master/docs/cheatsheet_syntax.md
echo "Setup navi"

brew install navi

mkdir -p ~/Library/Application\ Support/navi/
ln -sfn $(pwd)/tools/navi/config.yaml ~/Library/Application\ Support/navi/config.yaml

mkdir -p ~/.navi/
ln -sfn $(pwd)/tools/navi/cheats ~/.navi/cheats
