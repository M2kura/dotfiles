#!/bin/bash
# WSL-specific installation script for dotfiles
DOTFILES="$HOME/.dotfiles"
NVIM_DIR="$HOME/IDEs/nvim"

echo "Setting up dotfiles for WSL..."

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/IDEs"

# Detect WSL distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=$ID
    echo "Detected WSL distribution: $DISTRO_ID"
else
    echo "Cannot detect distribution"
    exit 1
fi

# Update package lists first
echo "Updating package lists..."
case "$DISTRO_ID" in
    ubuntu|debian)
        sudo apt update
        ;;
    fedora)
        sudo dnf check-update || true
        ;;
    arch|manjaro)
        sudo pacman -Sy
        ;;
esac

# Install packages based on detected distribution
case "$DISTRO_ID" in
    ubuntu|debian)
        echo "Installing packages for Ubuntu/Debian..."
        sudo apt install -y \
            curl \
            git \
            vim \
            htop \
            unzip \
            build-essential \
            xclip \
            maven \
            gcc \
            make \
            wget \
            ca-certificates \
            gnupg \
            lsb-release
        
        # Install Node.js via NodeSource (optional)
        echo "Would you like to install Node.js? (y/N)"
        read -r install_node
        if [[ $install_node =~ ^[Yy]$ ]]; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt install -y nodejs
        fi
        ;;
        
    fedora)
        echo "Installing packages for Fedora..."
        sudo dnf install -y \
            gcc \
            vim \
            xclip \
            maven \
            curl \
            git \
            htop \
            unzip \
            make \
            wget \
            nodejs \
            npm
        ;;
        
    arch|manjaro)
        echo "Installing packages for Arch Linux..."
        # Note: i3, dmenu, etc. won't work in WSL, so we skip GUI packages
        sudo pacman -S --needed --noconfirm \
            base-devel \
            git \
            vim \
            htop \
            unzip \
            curl \
            wget \
            nodejs \
            npm \
            maven
        ;;
        
    *)
        echo "Unsupported distribution: $DISTRO_ID"
        echo "Only installing Neovim and basic configs..."
        ;;
esac

echo "Setting up Neovim..."
# Check if nvim exists in IDEs directory
if [ ! -d "$NVIM_DIR" ]; then
    echo "Installing Neovim..."
    # Download and extract prebuilt archive
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    mkdir -p "$NVIM_DIR"
    tar -C "$NVIM_DIR" -xzf nvim-linux-x86_64.tar.gz --strip-components=1
    rm nvim-linux-x86_64.tar.gz
    echo "Neovim installed to $NVIM_DIR"
fi

echo "Creating symlinks for configuration files..."

# Neovim
rm -rf "$HOME/.config/nvim"
ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"
echo "✓ Neovim config linked"

# Skip i3 and ghostty for WSL since they're GUI applications
# You can use Windows Terminal instead of ghostty

# Shell configurations
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
echo "✓ Shell configs linked"

# Git configuration
echo "Setting up Git configuration..."
if [ -f "$HOME/.gitconfig" ]; then
    mv "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
    echo "Backed up existing .gitconfig to .gitconfig.backup"
fi
ln -s "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
echo "✓ Git config linked"

# WSL-specific configurations
echo "Setting up WSL-specific configurations..."

# Add Windows PATH integration warning to bashrc if not already present
if ! grep -q "WSL_INTEROP" "$DOTFILES/shell/.bashrc"; then
    cat >> "$HOME/.bashrc.wsl" << 'EOF'

# WSL-specific configurations
# Enable Windows PATH integration (careful with performance)
# export WSLENV=USERPROFILE/p

# WSL clipboard integration helpers
if command -v clip.exe >/dev/null 2>&1; then
    alias pbcopy='clip.exe'
fi

if command -v powershell.exe >/dev/null 2>&1; then
    alias pbpaste='powershell.exe Get-Clipboard'
fi

# Windows drive shortcuts
alias cdwin='cd /mnt/c/Users/$USER'
alias cdc='cd /mnt/c'
alias cdd='cd /mnt/d'

# VSCode integration
if command -v code >/dev/null 2>&1; then
    alias code-here='code .'
fi
EOF
    echo "source ~/.bashrc.wsl" >> "$HOME/.bashrc"
    echo "✓ WSL-specific configurations added"
fi

# Set up Windows Terminal integration hint
echo ""
echo "🎉 WSL dotfiles setup complete!"
echo ""
echo "📝 Additional setup recommendations for WSL:"
echo ""
echo "1. Windows Terminal Configuration:"
echo "   - Install Windows Terminal from Microsoft Store"
echo "   - Use the following settings for better integration:"
echo "   - Set WSL as default profile"
echo "   - Configure fonts (Cascadia Code or JetBrains Mono recommended)"
echo ""
echo "2. VSCode Integration:"
echo "   - Install 'Remote - WSL' extension in VSCode"
echo "   - Use 'code .' from WSL to open projects in VSCode"
echo ""
echo "3. Git Credential Management:"
echo "   - Consider using Git Credential Manager: git config --global credential.helper '/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe'"
echo ""
echo "4. File System Performance:"
echo "   - Keep your projects in WSL file system (/home) for better performance"
echo "   - Avoid working on files in /mnt/c when possible"
echo ""
echo "5. Restart your terminal or run 'source ~/.bashrc' to load new configurations"
