#!/usr/bin/env bash
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found. Please install yay first."
  exit 1
fi

echo "Installing kitty..."
yay -S --noconfirm --needed kitty

# Set kitty as default XDG terminal
if command -v kitty >/dev/null 2>&1; then
  echo "Setting kitty as default XDG terminal..."
  
  # Set kitty as default for terminal MIME types
  if command -v xdg-mime >/dev/null 2>&1; then
    # Find kitty desktop file
    KITTY_DESKTOP=$(find /usr/share/applications /usr/local/share/applications ~/.local/share/applications 2>/dev/null | grep -i kitty | grep "\.desktop$" | head -n 1)
    
    if [ -n "$KITTY_DESKTOP" ]; then
      xdg-mime default "$(basename "$KITTY_DESKTOP")" x-scheme-handler/terminal 2>/dev/null || true
      echo "✓ Kitty set as default terminal"
    else
      echo "⚠ Could not find kitty desktop file"
    fi
  else
    echo "⚠ xdg-mime not found, skipping terminal default setting"
  fi
else
  echo "⚠ Kitty installation failed or not found"
  exit 1
fi

echo "✓ Kitty installation complete"

