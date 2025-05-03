#!/bin/bash
DOTFILES="$HOME/.dotfiles"
NVIM_DIR="$HOME/IDEs/nvim"

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/IDEs"

echo "Setting up i3 window manager..."
# Install i3 and dependencies
if command -v pacman >/dev/null 2>&1; then
    # For Arch Linux
    sudo pacman -S --noconfirm i3-wm i3status i3lock dmenu xorg-xrandr picom feh xss-lock network-manager-applet
elif command -v apt-get >/dev/null 2>&1; then
    # For Debian/Ubuntu
    sudo apt-get install -y i3 i3status i3lock dmenu xrandr picom feh xss-lock network-manager-gnome
fi

# Create symlinks for i3 configuration
rm -rf "$HOME/.config/i3"
ln -s "$DOTFILES/i3" "$HOME/.config/i3"

echo "Setting up Neovim..."
# Check if nvim exists in IDEs directory
if [ ! -d "$NVIM_DIR" ]; then
    echo "Installing Neovim..."
    # Download and extract prebuilt archive
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    mkdir -p "$NVIM_DIR"
    tar -C "$NVIM_DIR" -xzf nvim-linux-x86_64.tar.gz --strip-components=1
    rm nvim-linux-x86_64.tar.gz
fi
rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "Setting up Ghostty..."
rm -rf "$HOME/.config/ghostty"
ln -s "$DOTFILES/ghostty" "$HOME/.config/ghostty"

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
