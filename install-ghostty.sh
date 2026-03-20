#!/usr/bin/env bash
set -euo pipefail

# Check if ghostty is already installed
if command -v ghostty >/dev/null 2>&1; then
  echo "Ghostty is already installed, skipping installation..."
else
  if ! command -v yay >/dev/null 2>&1; then
    echo "yay not found. Please install yay first."
    exit 1
  fi
  
  echo "Installing ghostty..."
  yay -S --noconfirm --needed ghostty
fi

# make it default terminal
echo "Setting ghostty as default terminal in xdg-terminals.list..."
mkdir -p ~/.config
cat > ~/.config/xdg-terminals.list <<EOL
# Terminal emulator preference order for xdg-terminal-exec
# The first found and valid terminal will be used
ghostty.desktop
EOL

echo "✓ Ghostty installation complete"
