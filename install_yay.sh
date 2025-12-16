#!/bin/bash

# AUR Installer

BUILD_DIR="$HOME/aur_builds"
LOG_FILE="install_log.txt"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
	echo -e "${BLUE}[INFO]${NC} $1"
}

error() {
	echo -e "${RED}[ERROR]${NC} $1"
	exit 1
}

succes() {
	echo -e "${GREEN}[SUCCESS]${NC} $1"
}

check_root() {
	if [ "$EUID" -eq 0 ]; then
		error "Do not run this script as root"
	fi
}

install_deps() {
	log "Checking and installing base dependencies"
	sudo pacman -S --needed --noconfirm git base-devel || error "Failed to install dependencies"
}

install_aur_package() {
	local url=$1
	local name=$2
	local target_dir="$BUILD_DIR/$name"

	log "Starting installation for: $name"

	mkdir -p "$BUILD_DIR"

	if [ -d "$target_dir" ]; then
		log "Directory exists. Pulling latest changes..."
		cd "$targer_dir" || error "Couldn't enter directory $targer_dir"
		git pull || error "Failed to pull git repo"
	else
		log  "Cloning repository..."
		git clone "$url" "$target_dir" || error "Failed to clone $url"
		cd "$target_dir" || error "Couldn't enter directory $target_dir"
	fi

	log "Building and installing $name..."
	makepkg -si --noconfirm || error "Makepkg failed for $name"

	success "$name installed successfully"

	cd ..
	log "Cleaning build directory"
	rm -rf "$name"
}


main() {
	check_root
	install_deps

	install_aur_package "https://aur.archlinux.org/yay.git" "yay"

	succes "All tasks completed!"
}

main

