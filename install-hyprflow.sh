#!/usr/bin/env bash
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found"
  exit 1
fi

# Install required packages
echo "=== Installing hyprflow dependencies ==="

pacman_pkgs=(
  pipewire
  pipewire-pulse
  pipewire-alsa
  pipewire-jack
  wl-clipboard
  cmake
  git
  make
  gcc
)

sudo pacman -Syu --noconfirm --needed "${pacman_pkgs[@]}"

# Check for CUDA or Vulkan for GPU acceleration
HAS_CUDA=false
HAS_VULKAN=false

if command -v nvidia-smi >/dev/null 2>&1; then
  HAS_CUDA=true
  echo "NVIDIA GPU detected - will build with CUDA support"
fi

if command -v vulkaninfo >/dev/null 2>&1 || [ -f /usr/share/vulkan/icd.d/*.json ]; then
  HAS_VULKAN=true
  echo "Vulkan detected - can build with Vulkan support"
fi

# Build whisper.cpp
WHISPER_DIR="${HOME}/whisper.cpp"

if [ -d "$WHISPER_DIR" ]; then
  echo "whisper.cpp directory already exists at $WHISPER_DIR"
  echo "Updating repository..."
  cd "$WHISPER_DIR"
  git pull || true
else
  echo "Cloning whisper.cpp..."
  cd "$HOME"
  git clone https://github.com/ggerganov/whisper.cpp.git
  cd "$WHISPER_DIR"
fi

echo "Building whisper.cpp..."
mkdir -p build
cd build

# Determine build type
if [ "$HAS_CUDA" = true ]; then
  echo "Building with CUDA support..."
  cmake -DGGML_CUDA=ON ..
elif [ "$HAS_VULKAN" = true ]; then
  echo "Building with Vulkan support..."
  cmake -DGGML_VULKAN=ON ..
else
  echo "Building CPU-only version..."
  cmake ..
fi

cmake --build . --config Release -j "$(nproc)"

# Download whisper model if not present
MODEL_DIR="${WHISPER_DIR}/models"
MODEL_NAME="base.en"
MODEL_FILE="${MODEL_DIR}/ggml-${MODEL_NAME}.bin"

if [ ! -f "$MODEL_FILE" ]; then
  echo "Downloading whisper model: ${MODEL_NAME}..."
  cd "$WHISPER_DIR"
  if [ -f "./models/download-ggml-model.sh" ]; then
    bash ./models/download-ggml-model.sh "$MODEL_NAME"
  else
    echo "⚠ Model download script not found. Please download manually:"
    echo "   cd $WHISPER_DIR && ./models/download-ggml-model.sh $MODEL_NAME"
  fi
else
  echo "✓ Model already exists: $MODEL_FILE"
fi

# Copy hyprflow script to home directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPRFLOW_SOURCE="${SCRIPT_DIR}/hyprflow"
HYPRFLOW_DEST="${HOME}/hyprflow"

if [ -f "$HYPRFLOW_SOURCE" ]; then
  echo "Copying hyprflow script to home directory..."
  cp "$HYPRFLOW_SOURCE" "$HYPRFLOW_DEST"
  chmod +x "$HYPRFLOW_DEST"
  echo "✓ Hyprflow script installed to ${HYPRFLOW_DEST}"
else
  echo "⚠ hyprflow script not found at ${HYPRFLOW_SOURCE}"
  echo "   Please ensure the script exists in the same directory as install-hyprflow.sh"
fi

echo ""
echo "=== Hyprflow dependencies installed! ==="
echo ""
echo "Next steps:"
echo "1. The hyprflow script has been copied to: ${HYPRFLOW_DEST}"
echo "   (Paths are auto-detected, but you can override with environment variables)"
echo ""
echo "2. Add keybind to Hyprland config:"
echo "   bind = SUPER, SPACE, exec, ${HYPRFLOW_DEST}"

