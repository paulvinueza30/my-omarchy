#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing ColorLS ==="

# Check if Ruby is installed (required for gem)
if ! command -v ruby >/dev/null 2>&1; then
  echo "Error: Ruby is not installed. Please run install-dev-langs.sh first."
  exit 1
fi

# Check if gem is available
if ! command -v gem >/dev/null 2>&1; then
  echo "Error: RubyGems is not installed. Please install Ruby first."
  exit 1
fi

# Check if colorls is already installed
if command -v colorls >/dev/null 2>&1; then
  echo "ColorLS is already installed."
  colorls --version
  exit 0
fi

echo "Installing ColorLS via RubyGems..."
echo "This may take a moment..."

# Install colorls gem (may require sudo depending on system configuration)
if sudo gem install colorls; then
  echo "✓ ColorLS installed successfully"
else
  echo "⚠ Failed to install with sudo, trying without..."
  if gem install colorls --user-install; then
    # Add user gem bin directory to PATH if not already there
    USER_GEM_BIN="${HOME}/.local/share/gem/ruby/$(ruby -e 'puts Gem.ruby_version')/bin"
    if [ -d "$USER_GEM_BIN" ] && ! echo "$PATH" | grep -q "$USER_GEM_BIN"; then
      echo ""
      echo "⚠ ColorLS installed to user directory. Add this to your shell config:"
      echo "   export PATH=\"${USER_GEM_BIN}:\${PATH}\""
    fi
    echo "✓ ColorLS installed successfully (user install)"
  else
    echo "✗ Failed to install ColorLS"
    exit 1
  fi
fi

# Verify installation
if command -v colorls >/dev/null 2>&1; then
  echo ""
  echo "✓ ColorLS installation complete!"
  echo "   Run 'colorls --version' to verify"
else
  echo ""
  echo "⚠ ColorLS installed but not in PATH. You may need to:"
  echo "   1. Restart your terminal, or"
  echo "   2. Add gem bin directory to your PATH"
fi

