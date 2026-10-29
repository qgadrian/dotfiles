#!/usr/bin/env bash
# Sourced from ../install.sh: use `break`/`return`, never `exit`, so the rest of the install continues.

BASE_DIR="$(pwd)/containers"

PS3='Select a container system to install: '
options=(Orbstack Colima Skip)

echo "Install VM container runtime"
select choice in "${options[@]}"; do
  case "$choice" in
  Orbstack | Colima)
    choice_lc=$(printf '%s' "$choice" | tr '[:upper:]' '[:lower:]')
    source "$BASE_DIR/$choice_lc/install.sh"
    echo "✅ $choice installation complete."
    break
    ;;
  Skip)
    echo "Skipping container runtime."
    break
    ;;
  *)
    echo "Invalid selection. Please choose 1–${#options[@]}."
    ;;
  esac
done
