#!/usr/bin/env bash
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found"
  exit 1
fi

pkgs=(
  zsh
  git
  zoxide
  thefuck
  bat
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-you-should-use
  zsh-theme-powerlevel10k
)

for p in "${pkgs[@]}"; do
  yay -S --noconfirm --needed "$p"
done

# Install zsh-bat plugin manually
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"
ZSH_BAT_PLUGIN_DIR="${ZSH_CUSTOM}/plugins/zsh-bat"

if [ -d "$ZSH_BAT_PLUGIN_DIR" ]; then
  echo "zsh-bat plugin already exists, updating..."
  cd "$ZSH_BAT_PLUGIN_DIR"
  git pull || true
else
  echo "Installing zsh-bat plugin..."
  mkdir -p "${ZSH_CUSTOM}/plugins"
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_BAT_PLUGIN_DIR"
fi

echo "✓ zsh-bat plugin installed to ${ZSH_BAT_PLUGIN_DIR}"
