#!/bin/bash
DOTFILES="$HOME/.dotfiles"
NVIM_DIR="$HOME/IDEs/nvim"

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/IDEs"

# Detect package manager
if command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
    echo "Detected Arch Linux system"
elif command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
    echo "Detected Debian/Ubuntu system"
elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
    echo "Detected Fedora system"
else
    PACKAGE_MANAGER="unknown"
    echo "Unknown package manager, only installing Neovim and configs"
fi

# Install packages based on detected package manager
if [ "$PACKAGE_MANAGER" = "pacman" ]; then
    echo "Installing packages from arch-packages.txt..."
	sudo pacman -S --needed --noconfirm - < "$DOTFILES/arch-packages.txt"
    echo "Finished installing packages"
elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    echo "Installing packages from fedora-packages.txt..."
	sudo dnf install -y $(cat "$DOTFILES/fedora-packages.txt")
    echo "Finished installing packages"
fi

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

echo "Creating symlinks for configuration files..."

# Neovim
rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"

# i3 window manager
rm -rf "$HOME/.config/i3"
ln -s "$DOTFILES/i3" "$HOME/.config/i3"

# Ghostty terminal
rm -rf "$HOME/.config/ghostty"
ln -s "$DOTFILES/ghostty" "$HOME/.config/ghostty"

# Shell configurations
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

# Git configuration
# Backup existing gitconfig if it exists
if [ -f "$HOME/.gitconfig" ]; then
	mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
	echo "Backed up existing .gitconfig to .gitconfig.backup"
fi
ln -s "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"

echo "Done! Dotfiles have been symlinked."
