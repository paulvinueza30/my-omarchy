#!/usr/bin/env bash
set -euo pipefail

# Check if Ruby is installed, install if not
if ! command -v ruby >/dev/null 2>&1; then
  echo "Ruby is not installed. Installing Ruby..."
  if ! command -v yay >/dev/null 2>&1; then
    echo "Error: yay not found. Please install yay first."
    exit 1
  fi
  yay -S --noconfirm --needed ruby
fi

gem install colorls

