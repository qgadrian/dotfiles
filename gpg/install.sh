echo "Install GPG"

brew install gpg

# Use macos keychain for gpg
# https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e
read -p "Use macos keychain to unlock the GPG key? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install pinentry-mac
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    echo "use-agent" >> ~/.gnupg/gpg.conf
    chmod 700 ~/.gnupg
fi

# Gen GPG key
# gpg --full-gen-key

# List created GPG keys
# gpg --list-secret-keys --keyid-format LONG my@email.sh

# Get the key id, see example:
# sec   rsa4096/$key_id

# Export key
# gpg --armor --export $key_id

# Set key to sign git commits
# git config --global user.signingkey $key_id

# Set global signed commits
# git config --global commit.gpgsign true

# Set the gpg command (might not be necessary)
# git config --global gpg.program gpg

# Set gpg tty
# export GPG_TTY=$(tty)
