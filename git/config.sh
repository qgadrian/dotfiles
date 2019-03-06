echo "Setting git default editor..."

git config --global core.editor 'nvr --remote-wait-silent'

echo "Setting git aliases..."

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.cl "clone --recursive"
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.cia 'commit --amend'
git config --global alias.ciar 'commit --amend --reset-author'
git config --global alias.p 'pull'
git config --global alias.pr 'pull --rebase'
git config --global alias.ap 'add -p'

echo "Enable recursive cloning..."

git config --global submodule.recurse true

echo "Enable follow tags option"

git config --global push.followTags true

echo "Add git gone scrip to /usr/bin"

chmod +x ./scripts/git-gone.sh

ln -sf $(pwd)/scripts/git-gone.sh /usr/bin/git-gone.sh
