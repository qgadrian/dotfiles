# Tailscale runs as a root system daemon via brew services (starts at boot, before login).
# The LaunchDaemon points at /opt/homebrew/opt/tailscale, so `brew upgrade` is picked up
# on the next daemon restart/reboot with no manual step.
# Do NOT use plain `brew services start tailscale` (user agent, crash-loops without root)
# or the tailscale-app cask (conflicts with the system daemon).

brew install tailscale

# Migrate away from the old copied-binary daemon, if present
if [ -f /Library/LaunchDaemons/com.tailscale.tailscaled.plist ]; then
  sudo /opt/homebrew/bin/tailscaled uninstall-system-daemon
fi

brew services stop tailscale 2>/dev/null
sudo brew services start tailscale

# First time only: tailscale up --advertise-exit-node --advertise-routes=192.168.2.0/24
