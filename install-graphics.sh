#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found"
  exit 1
fi

# Detect GPU type
HAS_NVIDIA=false
HAS_VULKAN_GPU=false

# Check for NVIDIA GPU
if lspci | grep -i "nvidia" >/dev/null 2>&1 || command -v nvidia-smi >/dev/null 2>&1; then
  HAS_NVIDIA=true
  echo "NVIDIA GPU detected"
fi

# Check for AMD/Intel GPU (Vulkan capable)
if lspci | grep -iE "(amd|ati|radeon|intel.*graphics)" >/dev/null 2>&1; then
  HAS_VULKAN_GPU=true
  echo "AMD/Intel GPU detected (Vulkan capable)"
fi

# Install CUDA packages if NVIDIA is present
if [ "$HAS_NVIDIA" = true ]; then
  echo "Installing NVIDIA/CUDA packages..."
  cuda_pkgs=(
    cuda
    nvidia-open-dkms
    nvidia-utils
    lib32-nvidia-utils
    opencl-nvidia
    libva-nvidia-driver
  )
  sudo pacman -Syu --noconfirm --needed "${cuda_pkgs[@]}"
else
  echo "No NVIDIA GPU detected, skipping CUDA packages"
fi

# Install Vulkan packages if AMD/Intel GPU is present (and not NVIDIA)
if [ "$HAS_VULKAN_GPU" = true ] && [ "$HAS_NVIDIA" = false ]; then
  echo "Installing Vulkan packages..."
  vulkan_pkgs=(
    vulkan-radeon
    lib32-vulkan-radeon
    vulkan-intel
    lib32-vulkan-intel
    vulkan-icd-loader
    lib32-vulkan-icd-loader
  )
  sudo pacman -Syu --noconfirm --needed "${vulkan_pkgs[@]}"
elif [ "$HAS_VULKAN_GPU" = true ] && [ "$HAS_NVIDIA" = true ]; then
  echo "NVIDIA detected, Vulkan support included with NVIDIA drivers"
elif [ "$HAS_VULKAN_GPU" = false ] && [ "$HAS_NVIDIA" = false ]; then
  echo "No GPU detected or unknown GPU type"
fi
