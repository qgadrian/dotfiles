echo "###################################"
echo "###################################"
echo "\t\tCONFIGURING GIT"
echo "###################################"
echo "###################################"

echo "Setting git configuration..."

git config --global core.editor 'nvr --remote-wait-silent'

ln -sf $(pwd)/git/.global_gitignore $HOME/
git config --global core.excludesfile $HOME/.global_gitignore

git config --global user.email "qgadrian@users.noreply.github.com"
git config --global user.name "Adrian Quintas"

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
git config --global alias.lt 'log --graph --oneline --all --decorate'

git config --global log.follow true

git config --global init.defaultBranch main

echo "Enable recursive cloning..."

git config --global submodule.recurse true

echo "Enable follow tags option"

git config --global push.followTags true

echo "Add git scripts"

mkdir -p $HOME/.bin

ln -sf $(pwd)/git/scripts/git-gone.sh $HOME/.bin/git-gone
ln -sf $(pwd)/git/scripts/git-new.sh $HOME/.bin/git-new

echo "Configure better diff tool"

brew install diff-so-fancy

git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta"
git config --global color.diff.commit     "yellow"
git config --global color.diff.old        "red"
git config --global color.diff.new        "green"
git config --global color.diff.whitespace "red reverse"
