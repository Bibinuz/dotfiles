# Dotfiles

This is my collection of dotfiles. I use this repository to restore my PC and install my configuration on any machine I am using.

## Included Configurations

These dotfiles include configurations for the following tools:

* **Window Manager:** Hyprland (with Hyprlock and Hypridle)
* **Terminal:** Kitty
* **Shell:** Zsh with Starship prompt
* **Editor:** Neovim and Zed
* **Bar:** Waybar
* **Launcher:** Rofi
* **File Manager:** Thunar & Yazi
* **Theming:** Matugen (Material You color generation) & Waypaper (Wallpaper manager)
* **System:** Wlogout, Bluetui, Impala, Pavucontrol

## Prerequisites

Ensure you have `yay` (AUR helper) installed on your Arch Linux system. 

If you do not have `yay` installed, you can use the provided script (or use another thing, just modify install_packages.sh):

```bash
./install_yay.sh
```
## Installation

1. Install Packages
I have included a script to install all necessary packages (both official and AUR). It is a simple list of dependencies required for this setup.
```bash
./install_packages.sh
```

2. Link Configuration Files
Use GNU Stow to symlink the configurations to your home directory. This command links everything inside the directories while ignoring the scripts and this README file.
You MUST remove all folders that may be already in place, for example, hyprland already autogeneatates ~/.config/hypr/hyprland.conf, if you try to Stow with that directory already created it won't work, just rename them to ~/.config/hypr_old or something like that
```bash
stow */
```

## Post-Installation Setup
Monitor Configuration
Inside hypr/.config/hypr/, you need to define your own monitor.conf file.

This file is excluded from the repository because I use this setup on both a laptop and a desktop, requiring different monitor layouts. By keeping it local, I can pull changes to the repository without conflicts.

Create the file:

```Bash
touch ~/.config/hypr/monitor.conf
```

Edit it to define your monitors (example):

```Plaintext
monitor=DP-1, 1920x1080@144, 0x0, 1
```

You will have to setup zsh as default shell. As well as enabling pipewire, iwd and bluetooth.
