#!/usr/bin/env bash
set -euo pipefail

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found. Please install yay first."
  exit 1
fi

packages=(
  python
  python-pip
  go
  nodejs
  npm
  jdk-openjdk
  ruby
)

yay -S --noconfirm --needed "${packages[@]}"

if command -v npm >/dev/null 2>&1; then
  sudo npm install -g typescript
fi

