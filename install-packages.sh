#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found"
  exit 1
fi

cuda_pkgs=(
  cuda
  nvidia-open-dkms
  nvidia-utils
  lib32-nvidia-utils
  opencl-nvidia
  libva-nvidia-driver
)

sudo pacman -Syu --noconfirm --needed "${cuda_pkgs[@]}"
