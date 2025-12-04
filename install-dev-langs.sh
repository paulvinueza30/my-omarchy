#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found"
  exit 1
fi

packages=(
  python
  python-pip
  go
  nodejs
  npm
  jdk-openjdk
  rustup
)

sudo pacman -Syu --noconfirm --needed "${packages[@]}"

if command -v npm >/dev/null 2>&1; then
  sudo npm install -g typescript
fi

if command -v rustup >/dev/null 2>&1; then
  rustup default stable || true
fi
