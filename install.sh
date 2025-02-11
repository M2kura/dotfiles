#!/bin/bash

DOTFILES="$HOME/.dotfiles"

# Create necessary directories
mkdir -p "$HOME/.config"

echo "Setting up Neovim..."
rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "Setting up Zed..."
rm -rf "$HOME/.config/zed"
ln -s "$DOTFILES/zed" "$HOME/.config/zed"

echo "Setting up shell configurations..."
# Backup existing shell config files if they exist
for file in .bashrc .profile .bash_logout; do
    if [ -f "$HOME/$file" ]; then
        mv "$HOME/$file" "$HOME/${file}.backup"
        echo "Backed up existing $file to ${file}.backup"
    fi
done

# Create symlinks for shell config files
ln -s "$DOTFILES/shell/.bashrc" "$HOME/.bashrc"
ln -s "$DOTFILES/shell/.profile" "$HOME/.profile"
ln -s "$DOTFILES/shell/.bash_logout" "$HOME/.bash_logout"

echo "Setting up Git config..."
# Backup existing gitconfig if it exists
if [ -f "$HOME/.gitconfig" ]; then
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
    echo "Backed up existing .gitconfig to .gitconfig.backup"
fi
ln -s "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

echo "Done! Dotfiles have been symlinked."
