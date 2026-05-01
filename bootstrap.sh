#!/bin/bash
set -e

echo "Bootstrapping..."

sudo dnf install -y \
	plasma-desktop \
	sddm \
	alacritty \
	kscreen \
	pipewire \
	pipewire-alsa \
	pipewire-pulseaudio \
	wireplumber \
	--setopt=install_weak_deps=false

sudo dnf install -y \
	firefox \
	tar \
	wget \
	git \
	gh \
	clang \
	cmake \
	cargo \
	ninja-build \
	gcc \
	g++
	gdb \
	fzf \
	zoxide \
	zsh \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
