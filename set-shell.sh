#!/usr/bin/env bash
set -euo pipefail

# Check if zsh is installed
if ! command -v zsh &>/dev/null; then
    echo "Zsh is not installed. Please run ./install-zsh-setup.sh first."
    exit 1
fi

# Ensure .zshrc symlink exists to ~/.config/zsh/.zshrc
if [ -f ~/.config/zsh/.zshrc ]; then
    if [ ! -L ~/.zshrc ] || [ "$(readlink ~/.zshrc)" != ~/.config/zsh/.zshrc ]; then
        echo "Creating symlink from ~/.zshrc to ~/.config/zsh/.zshrc..."
        if [ -f ~/.zshrc ] || [ -L ~/.zshrc ]; then
            rm -f ~/.zshrc
        fi
        ln -sf ~/.config/zsh/.zshrc ~/.zshrc
        echo "✓ Zsh config symlink created"
    fi
else
    echo "⚠ Warning: ~/.config/zsh/.zshrc not found"
    echo "  Make sure to run ./setup-dotfiles.sh first to set up your dotfiles"
fi

# Get the path to zsh
ZSH_PATH=$(which zsh)

# Check if zsh is already the default shell
if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "Zsh is already your default shell."
    exit 0
fi

# Add zsh to /etc/shells if not already there
if ! grep -q "^$ZSH_PATH$" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

# Change the default shell to zsh
chsh -s "$ZSH_PATH"

echo "Default shell changed to zsh. Please log out and log back in for the change to take effect."
echo "Your zsh config will be sourced from ~/.config/zsh/.zshrc"