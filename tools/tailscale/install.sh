# Tailscale runs as a root system daemon (starts at boot, before login).
# Do NOT use `brew services start tailscale` (user agent, crash-loops without root)
# or the tailscale-app cask (conflicts with the system daemon).
#
# install-system-daemon copies the binary to /usr/local/bin, so re-run this
# after every `brew upgrade tailscale`. Run it from home: it restarts the daemon.

brew install tailscale

brew services stop tailscale 2>/dev/null
sudo /opt/homebrew/bin/tailscaled install-system-daemon

# First time only: tailscale up --advertise-exit-node --advertise-routes=192.168.2.0/24
