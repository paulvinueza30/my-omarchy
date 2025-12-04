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
  zsh-bat
  zsh-you-should-use
  zsh-theme-powerlevel10k
)

for p in "${pkgs[@]}"; do
  yay -S --noconfirm --needed "$p"
done        
