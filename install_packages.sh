#!/bin/bash

packages_official=(
  stow
  git
  neovim
  gedit
  yazi
  rofi
  kitty
  btop
  ly
  zsh
  exa
  tmux
  zed
  nautilus
  keepassxc
  starship
  steam
  waybar
  bluez
  bluez-utils
  bluetui
  iwd
  impala
  pipewire
  pipewire-pulse
  pavucontrol
  brightnessctl
  hyprland
  hyprlock
  hypridle
  hyprpicker
  ttf-jetbrains-mono
  dkms
  linux-headers
)

packages_aur=(
  swww
  matugen
  waypaper
  hyprshot
  ttf-font-awesome
  wlogout
  localsend
  librewolf-bin
  xpadneo-dkms
  aether
)

install_official() {
  echo "--- Installing Official Packages ---"
  sudo pacman -Syu --noconfirm

  for pkg in "${packages_official[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      echo "Skipping $pkg (Already installed)"
    else
      echo "Installing $pkg..."
      sudo pacman -S --needed --noconfirm "$pkg" || echo "ERROR: Failed to install $pkg"
    fi
  done
}

install_aur() {
  echo "--- Installing AUR Packages ---"
  if ! command -v yay &>/dev/null; then
    echo "Error: yay is not installed. Skipping AUR packages."
    return
  fi

  for pkg in "${packages_aur[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      echo "Skipping $pkg (Already installed)"
    else
      echo "Installing $pkg..."
      yay -S --needed --noconfirm "$pkg" || echo "ERROR: Failed to install $pkg"
    fi
  done
}

install_official
install_aur

echo "--- Installation Complete ---"
