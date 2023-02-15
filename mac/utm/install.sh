set -e

brew install utm

read -p "Install UTM libs to generate Windows images? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew tap sidneys/homebrew
    brew install aria2 cabextract wimlib cdrtools sidneys/homebrew/chntpw
fi

# installation guides
# https://docs.getutm.app/guides/windows/

# issues with file size, open `regedit` on windows, update the value and restart
#  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WebClient\Parameters
#  4294967295 decimal
