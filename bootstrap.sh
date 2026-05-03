#!/bin/bash
set -e

echo "Bootstrapping..."

# Get desktop environment packages
sudo dnf install -y \
	plasma-desktop \
	sddm \
	alacritty \
	kscreen \
	spectacle \
	pipewire \
	pipewire-alsa \
	pipewire-pulseaudio \
	wireplumber \
	input-remapper \
	--setopt=install_weak_deps=false

# Get utilities
sudo dnf install -y \
	nvim \
	tar \
	wget \
	git \
	gh \
	clang \
	clangd \
	cmake \
	cargo \
	ninja-build \
	gcc \
	g++ \
	gdb \
	ruby \
	ruby-devel \
	redhat-rpm-config \
	fzf \
	zoxide \
	zsh \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
	--setopt=install_weak_deps=false

# Get larger software packages
sudo dnf install -y \
	firefox \
	kicad \
	kicad-packages3d \
	--setopt=install_weak_deps=false
	
# Install jekyll for gh pages
gem install jekyll bundler

# Copy zsh files
cp .zshrc ~/.zshrc
cp .zshenv ~/.zshenv

# Set default shell to zsh
chsh -s $(which zsh)

# Enable audio services
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# NVIM plugins
mkdir -p ~/.local/share/nvim/site/pack/plugins/start
cd ~/.local/share/nvim/site/pack/plugins/start

install_plugin() {
    local name=$1
    local url=$2
    local path=~/.local/share/nvim/site/pack/plugins/start/$name

    if [ ! -d "$path" ]; then
        git clone "$url" "$path"
    else
	echo "$name already installed for nvim, skipping..."
    fi
}

install_plugin "nvim-cmp" "https://github.com/hrsh7th/nvim-cmp.git"
install_plugin "cmp-nvim-lsp" "https://github.com/hrsh7th/cmp-nvim-lsp.git"
install_plugin "nvim-treesitter" "https://github.com/nvim-treesitter/nvim-treesitter.git"
install_plugin "nvim-dap" "https://github.com/mfussenegger/nvim-dap.git"
install_plugin "plenary.nvim" "https://github.com/nvim-lua/popup.nvim"
install_plugin "popup.nvim" "https://github.com/nvim-lua/plenary.nvim"
install_plugin "telescope.nvim" "https://github.com/nvim-telescope/telescope.nvim"
install_plugin "nvim-nio" "https://github.com/nvim-neotest/nvim-nio"
install_plugin "nvim-dap-ui" "https://github.com/rcarriga/nvim-dap-ui"
install_plugin "toggleterm.nvim" "https://github.com/akinsho/toggleterm.nvim.git"
install_plugin "lualine.nvim" "https://github.com/nvim-lualine/lualine.nvim.git"
install_plugin "auto-session" "https://github.com/rmagatti/auto-session.git"
install_plugin "gitsigns.vim" "https://github.com/lewis6991/gitsigns.nvim.git"

cd ~/.local/share/nvim/site/pack/plugins/start/nvim-treesitter/
git checkout v0.9.3
cd ~/.local/share/nvim/site/pack/plugins/start/nvim-dap/
git checkout 0.9.0
cd ~/.local/share/nvim/site/pack/plugins/start/telescope.nvim/
git checkout v0.2.0
