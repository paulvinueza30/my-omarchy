#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting installation of all components..."
echo ""

# Install graphics packages (CUDA, Vulkan, etc.)
echo "=== Installing graphics packages ==="
if [ -f "${SCRIPT_DIR}/install-graphics.sh" ]; then
  bash "${SCRIPT_DIR}/install-graphics.sh"
  echo "✓ Graphics packages installed"
else
  echo "⚠ install-graphics.sh not found, skipping..."
fi
echo ""

# Install development languages
echo "=== Installing development languages ==="
if [ -f "${SCRIPT_DIR}/install-dev-langs.sh" ]; then
  bash "${SCRIPT_DIR}/install-dev-langs.sh"
  echo "✓ Development languages installed"
else
  echo "⚠ install-dev-langs.sh not found, skipping..."
fi
echo ""

# Install programs
echo "=== Installing programs ==="
if [ -f "${SCRIPT_DIR}/install-programs.sh" ]; then
  bash "${SCRIPT_DIR}/install-programs.sh"
  echo "✓ Programs installed"
else
  echo "⚠ install-programs.sh not found, skipping..."
fi
echo ""

# Install zsh setup
echo "=== Installing zsh setup ==="
if [ -f "${SCRIPT_DIR}/install-zsh-setup.sh" ]; then
  bash "${SCRIPT_DIR}/install-zsh-setup.sh"
  echo "✓ Zsh setup installed"
else
  echo "⚠ install-zsh-setup.sh not found, skipping..."
fi
echo ""

# Install webapps
echo "=== Installing webapps ==="
if [ -f "${SCRIPT_DIR}/install-webapps.sh" ]; then
  bash "${SCRIPT_DIR}/install-webapps.sh"
  echo "✓ Webapps installed"
else
  echo "⚠ install-webapps.sh not found, skipping..."
fi
echo ""

# Install hyprflow
echo "=== Installing hyprflow ==="
if [ -f "${SCRIPT_DIR}/install-hyprflow.sh" ]; then
  bash "${SCRIPT_DIR}/install-hyprflow.sh"
  echo "✓ Hyprflow installed"
else
  echo "⚠ install-hyprflow.sh not found, skipping..."
fi
echo ""

# Setup dotfiles
echo "=== Setting up dotfiles ==="
if [ -f "${SCRIPT_DIR}/setup-dotfiles.sh" ]; then
  bash "${SCRIPT_DIR}/setup-dotfiles.sh"
  echo "✓ Dotfiles setup complete"
else
  echo "⚠ setup-dotfiles.sh not found, skipping..."
fi
echo ""

# Set shell to zsh
echo "=== Setting default shell ==="
if [ -f "${SCRIPT_DIR}/set-shell.sh" ]; then
  bash "${SCRIPT_DIR}/set-shell.sh"
  echo "✓ Shell setup complete"
else
  echo "⚠ set-shell.sh not found, skipping..."
fi
echo ""

echo "=== All installations complete! ==="
