echo "Setting git aliases..."

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cl "clone --recursive"
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'

echo "Enable recursive cloning..."

git config --global submodule.recurse true

echo "Enable follow tags option"

git config --global push.followTags true
