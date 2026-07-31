#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Add packages here as needed
PACKAGES=(stow git htop ripgrep curl unzip fzf)

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

install_bun() {
    if command -v bun &>/dev/null; then
        echo "bun already installed"
        return
    fi

    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
}

install_zoxide() {
    if command -v zoxide &>/dev/null; then
        echo "zoxide already installed"
        return
    fi

    echo "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

echo "Installing packages: ${PACKAGES[*]}"
install_packages

install_zoxide

install_bun

echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
if ! stow --target="$HOME" --restow .; then
    echo "Error: stow reported conflicts in $HOME."
    echo "Back up or remove the conflicting files, then rerun ./install.sh."
    exit 1
fi

echo "Done! Open a new shell to apply changes."
