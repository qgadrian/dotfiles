#!/bin/bash

# Claude Code macOS Notification Hook
# Reads JSON from stdin and sends macOS notification

# Read the JSON input from stdin
json_input=$(cat)

# Extract the message using simple pattern matching
# (Using sed for compatibility, could use jq if available)
message=$(echo "$json_input" | sed -n 's/.*"message"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# Clean up any escaped characters
message=$(echo "$message" | sed 's/\\!/!/g' | sed 's/\\"/"/g')

# Send macOS notification using terminal-notifier if available, otherwise osascript
if [ -n "$message" ]; then
  # Try terminal-notifier first (if installed via homebrew)
  if command -v terminal-notifier &>/dev/null; then
    terminal-notifier -title "Claude Code" -message "$message" -sound Glass
    # Also play sound separately to ensure it's heard
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
  else
    # Fallback to osascript with both notification and sound
    osascript <<EOF
display notification "$message" with title "Claude Code" sound name "Glass"
EOF
    # Also play sound separately to ensure it's heard
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null &
  fi
fi
