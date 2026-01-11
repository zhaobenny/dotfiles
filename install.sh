#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add packages here as needed
PACKAGES=(stow git htop)

# Detect package manager and install packages
install_packages() {
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y "${PACKAGES[@]}"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "${PACKAGES[@]}"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "${PACKAGES[@]}"
    elif command -v brew &>/dev/null; then
        brew install "${PACKAGES[@]}"
    else
        echo "Error: No supported package manager found"
        exit 1
    fi
}

echo "Installing packages: ${PACKAGES[*]}"
install_packages

echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow --restow .

echo "Done! Open a new shell to apply changes."
