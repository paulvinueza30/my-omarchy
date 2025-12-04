#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found"
  exit 1
fi

pacman_pkgs=(
  anki
  stow
  kitty
)

sudo pacman -Syu --noconfirm --needed "${pacman_pkgs[@]}"

if command -v yay >/dev/null 2>&1; then
  yay_pkgs=(
    cursor-bin
  )

  for pkg in "${yay_pkgs[@]}"; do
    yay -S --noconfirm --needed "$pkg"
  done
fi
