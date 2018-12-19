# Lang
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Android SDK bins
export ANDROID_HOME=~/workspace/lib/android-sdk-macosx
#export PATH="$HOME/Library/Android/sdk/platform-tools/adb:$PATH"

# Fastlane mobile builder
export PATH="$HOME/.fastlane/bin:$PATH"

# Python
PYTHONPATH=/usr/local/lib/python2.7/site-packages

# added by travis gem
[ -f /Users/adrian/.travis/travis.sh ] && source /Users/adrian/.travis/travis.sh

# Export gpg tty
export GPG_TTY=$(tty)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Import custom zshrcs
# Notice that the order will matter, and zsh should be the first one

# vim ycm workaround
export DYLD_FORCE_FLAT_NAMESPACE=1

source ~/.zsh/profiles/zsh
source ~/.zsh/profiles/aliases
source ~/.zsh/profiles/powerline
source ~/.zsh/profiles/asdf
source ~/.zsh/profiles/derivco
source ~/.zsh/profiles/brew
source ~/.zsh/profiles/macports
