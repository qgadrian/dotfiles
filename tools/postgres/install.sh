set -e

# If you need to have postgresql@15 first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
#
# For compilers to find postgresql@15 you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"
#
# For pkg-config to find postgresql@15 you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@15/lib/pkgconfig"

# To restart postgresql@15 after an upgrade:
#   brew services restart postgresql@15
# Or, if you don't want/need a background service you can just run:
#   /opt/homebrew/opt/postgresql@15/bin/postgres -D /opt/homebrew/var/postgresql@15

read -p "Install Postgresql? " -n 1 -r; echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install postgresql@15
    echo 'export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
    brew services restart postgresql@15
  fi

# to change default port, edit the conf file
# /opt/homebrew/var/postgresql@15/postgresql.conf
#
# to know the install location run brew info postgresql@15
