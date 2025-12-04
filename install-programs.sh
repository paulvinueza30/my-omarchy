#!/usr/bin/env bash
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found. Please install yay first."
  exit 1
fi

programs=(
  anki
  stow
  kitty
  cursor-bin
)

for pkg in "${programs[@]}"; do
  yay -S --noconfirm --needed "$pkg"
done
