#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting installation of all components..."
echo ""

echo "=== Installing graphics packages ==="
if [ -f "${SCRIPT_DIR}/install-graphics.sh" ]; then
  bash "${SCRIPT_DIR}/install-graphics.sh"
  echo "✓ Graphics packages installed"
else
  echo "⚠ install-graphics.sh not found, skipping..."
fi
echo ""

echo "=== Installing development languages ==="
if [ -f "${SCRIPT_DIR}/install-dev-langs.sh" ]; then
  bash "${SCRIPT_DIR}/install-dev-langs.sh"
  echo "✓ Development languages installed"
else
  echo "⚠ install-dev-langs.sh not found, skipping..."
fi
echo ""

echo "=== Installing GitHub CLI ==="
if [ -f "${SCRIPT_DIR}/install-gh-cli.sh" ]; then
  bash "${SCRIPT_DIR}/install-gh-cli.sh"
  echo "✓ GitHub CLI installed"
else
  echo "⚠ install-gh-cli.sh not found, skipping..."
fi
echo ""

if [ -f "${SCRIPT_DIR}/setup-gh-auth.sh" ]; then
  bash "${SCRIPT_DIR}/setup-gh-auth.sh"
  echo "✓ GitHub CLI setup"
else
  echo "⚠ setup-gh-auth.sh not found, skipping..."
fi
echo ""

echo "=== Installing cronie ==="
if [ -f "${SCRIPT_DIR}/install-cronie.sh" ]; then
  bash "${SCRIPT_DIR}/install-cronie.sh"
  echo "✓ Cronie install complete"
else
  echo "⚠ install-cronie.sh not found, skipping..."
fi
echo ""

echo "=== Installing ColorLS ==="
if [ -f "${SCRIPT_DIR}/install-color-ls.sh" ]; then
  bash "${SCRIPT_DIR}/install-color-ls.sh"
  echo "✓ ColorLS installed"
else
  echo "⚠ install-color-ls.sh not found, skipping..."
fi
echo ""

echo "=== Installing programs ==="
if [ -f "${SCRIPT_DIR}/install-programs.sh" ]; then
  bash "${SCRIPT_DIR}/install-programs.sh"
  echo "✓ Programs installed"
else
  echo "⚠ install-programs.sh not found, skipping..."
fi
echo ""

echo "=== Installing kitty ==="
if [ -f "${SCRIPT_DIR}/install-kitty.sh" ]; then
  bash "${SCRIPT_DIR}/install-kitty.sh"
  echo "✓ Kitty installed"
else
  echo "⚠ install-kitty.sh not found, skipping..."
fi
echo ""

echo "=== Installing zsh setup ==="
if [ -f "${SCRIPT_DIR}/install-zsh-setup.sh" ]; then
  bash "${SCRIPT_DIR}/install-zsh-setup.sh"
  echo "✓ Zsh setup installed"
else
  echo "⚠ install-zsh-setup.sh not found, skipping..."
fi
echo ""

echo "=== Installing webapps ==="
if [ -f "${SCRIPT_DIR}/install-webapps.sh" ]; then
  bash "${SCRIPT_DIR}/install-webapps.sh"
  echo "✓ Webapps installed"
else
  echo "⚠ install-webapps.sh not found, skipping..."
fi
echo ""

echo "=== Installing hyprflow ==="
if [ -f "${SCRIPT_DIR}/install-hyprflow.sh" ]; then
  bash "${SCRIPT_DIR}/install-hyprflow.sh"
  echo "✓ Hyprflow installed"
else
  echo "⚠ install-hyprflow.sh not found, skipping..."
fi
echo ""

echo "=== Setting up dotfiles ==="
if [ -f "${SCRIPT_DIR}/setup-dotfiles.sh" ]; then
  bash "${SCRIPT_DIR}/setup-dotfiles.sh"
  echo "✓ Dotfiles setup complete"
else
  echo "⚠ setup-dotfiles.sh not found, skipping..."
fi
echo ""

echo "=== Setting default shell ==="
if [ -f "${SCRIPT_DIR}/set-shell.sh" ]; then
  bash "${SCRIPT_DIR}/set-shell.sh"
  echo "✓ Shell setup complete"
else
  echo "⚠ set-shell.sh not found, skipping..."
fi
echo ""

echo "=== Getting Obsidian Vault From Github ==="
if [ -f "${SCRIPT_DIR}/get-obsidian-vault.sh" ]; then
  bash "${SCRIPT_DIR}/get-obsidian-vault.sh"
  echo "✓ Got Vault"

  echo "⚠ get-obsidian-vault.sh not found, skipping..."
fi
echo ""

echo "=== Reloading Hyprland === "
if [ -f "${SCRIPT_DIR}/reload-hyprland.sh" ]; then
  bash "${SCRIPT_DIR}/reload-hyprland.sh"
  echo "✓ Hyprland Reloaded"

  echo "⚠ reload-hyprland.sh not found, skipping..."
fi
echo ""

echo "=== All installations complete! ==="
