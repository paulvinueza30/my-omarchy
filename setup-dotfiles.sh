#!/usr/bin/env bash
set -euo pipefail

ORIGINAL_DIR=$(pwd)

REPO_URL="https://github.com/paulvinueza30/dotfiles"
REPO_NAME="dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Stow is not installed. Please run ./install-programs.sh first."
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Updating..."
  cd "$REPO_NAME"
  git pull || true
else
  echo "Cloning repository..."
  git clone "$REPO_URL"
  cd "$REPO_NAME"
fi

# Verify we're in the repository directory
if [ "$(basename $(pwd))" != "$REPO_NAME" ]; then
  echo "Failed to access the repository directory."
  exit 1
fi

echo "Removing old configs..."
rm -rf ~/.config/nvim ~/.config/starship.toml ~/.local/share/nvim/ ~/.cache/nvim/ || true
rm -rf ~/.config/kitty ~/.config/hypr ~/.config/waybar ~/.config/fastfetch || true
rm -rf ~/.zshrc ~/.oh-my-zsh || true

echo "Setting up dotfiles with stow..."

# Stow packages that exist in the repository
stow_packages=(
  zsh
  nvim
  kitty
  hypr
  waybar
  fastfetch
)

for package in "${stow_packages[@]}"; do
  if [ -d "$package" ]; then
    echo "Stowing $package..."
    stow "$package"
  else
    echo "⚠ Package '$package' not found in repository, skipping..."
  fi
done

# Handle .oh-my-zsh separately if it exists
if [ -d ".oh-my-zsh" ]; then
  echo "Setting up .oh-my-zsh..."
  if [ -L ~/.oh-my-zsh ]; then
    rm ~/.oh-my-zsh
  fi
  ln -sf "$(pwd)/.oh-my-zsh" ~/.oh-my-zsh
fi

cd "$ORIGINAL_DIR"

echo "✓ Dotfiles setup complete!"

