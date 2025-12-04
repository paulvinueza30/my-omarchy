#!/usr/bin/env bash
set -euo pipefail

# Check if kitty is already installed
if command -v kitty >/dev/null 2>&1; then
  echo "Kitty is already installed, skipping installation..."
else
  if ! command -v yay >/dev/null 2>&1; then
    echo "yay not found. Please install yay first."
    exit 1
  fi
  
  echo "Installing kitty..."
  yay -S --noconfirm --needed kitty
fi

# make it default terminal
echo "Setting kitty as default terminal in xdg-terminals.list..."
cat > ~/.config/xdg-terminals.list <<EOL
# Terminal emulator preference order for xdg-terminal-exec
# The first found and valid terminal will be used
kitty.desktop
EOL

echo "✓ Kitty installation complete"