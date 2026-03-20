#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/paulvinueza30/dotfiles"

brew_casks=(
  ghostty
  font-jetbrains-mono-nerd-font
)

brew_packages=(
  starship
  tmux
  atuin
  neovim
  lazygit
  lazydocker
  glow
  fzf
  zoxide
  bat
  eza
  ripgrep
  fd
  delta
  gh
  zsh
  stow
  thefuck
)

echo "Checking if Homebrew is installed..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✓ Homebrew installed"
fi

echo "Installing cask packages..."
for pkg in "${brew_casks[@]}"; do
  if brew list --cask "$pkg" &>/dev/null; then
    echo "  $pkg already installed, skipping..."
  else
    echo "  Installing $pkg..."
    brew install --cask "$pkg" || echo "  ⚠ $pkg failed to install"
  fi
done

echo "Installing terminal utilities..."
for pkg in "${brew_packages[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  $pkg already installed, skipping..."
  else
    echo "  Installing $pkg..."
    brew install "$pkg" || echo "  ⚠ $pkg failed to install"
  fi
done

echo ""
echo "Setting up dotfiles..."

if [ -d ~/dotfiles ]; then
  echo "Dotfiles repo exists, pulling latest..."
  cd ~/dotfiles
  git pull
else
  echo "Cloning dotfiles repo..."
  git clone "$DOTFILES_REPO" ~/dotfiles
  cd ~/dotfiles
fi

echo "Stowing packages..."
stow_packages=(zsh nvim ghostty starship tmux atuin hypr waybar fastfetch)

for package in "${stow_packages[@]}"; do
  if [ -d "$package" ]; then
    echo "  Stowing $package..."
    stow "$package"
  else
    echo "  ⚠ $package not found, skipping..."
  fi
done

echo "Creating symlinks..."
if [ -f ~/.config/zsh/.zshrc ]; then
  ln -sf ~/.config/zsh/.zshrc ~/.zshrc
fi

if [ -L ~/.oh-my-zsh ]; then
  rm -f ~/.oh-my-zsh
fi
ln -sf ~/dotfiles/.oh-my-zsh ~/.oh-my-zsh

echo "✓ macOS setup complete!"
