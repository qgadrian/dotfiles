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
#ENABLE_CORRECTION="true"

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

# Export gpg tty
export GPG_TTY=$(tty)

#echo "Import aliases"
for file in ~/.zsh/profiles/*; do
  source "$file"
done

export ZSH_THEME=powerlevel10k/powerlevel10k

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/python@3.7/bin:$PATH"

# yarn global path
export PATH="$HOME/.yarn/bin:$PATH"

. $HOME/.asdf/asdf.sh

. $HOME/.asdf/completions/asdf.bash

#Disable jvm when installing asdf plugins

export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

if [[ $OSTYPE == darwin* && $CPUTYPE == arm64 ]]; then
  export PATH=/opt/homebrew/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/bin:/Users/adrian/.asdf/shims:/Users/adrian/.asdf/shims:/Users/adrian/.asdf/bin:/usr/local/opt/python@3.7/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/adrian/Library/Android/sdk/emulator:/Users/adrian/Library/Android/sdk/tools:/Users/adrian/Library/Android/sdk/tools/bin:/Users/adrian/Library/Android/sdk/platform-tools
fi


export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim
# NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim &
# remote vim connections to this host. WIP
# export NVIM_LISTEN_ADDRESS=127.0.0.1:6666
