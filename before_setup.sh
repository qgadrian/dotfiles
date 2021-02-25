echo "Setting up an encrypted environment"

brew install gpg git-crypt

read -p "Is the GPG key imported? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git-crypt unlock
    echo "Repository unlocked"
  else
    echo "Aborted, please import GPG key"
  fi

# See https://github.com/AGWA/git-crypt
