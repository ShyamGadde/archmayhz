#!/bin/bash

set -e

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Services ----------- #
# ---------------------------- #
print_info "ENABLING UFW..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit ssh

print_info "ENABLING PIPEWIRE..."
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber

print_info "ENABLING SSH AGENT..."
systemctl --user enable --now gcr-ssh-agent

# ---------------------------- #
# ---------- AUR ------------- #
# ---------------------------- #
print_info "INSTALLING PARU..."
git clone https://aur.archlinux.org/paru-bin.git ~/repos/paru-bin
cd ~/repos/paru-bin
makepkg -si --noconfirm
apply_config /etc/paru.conf
cd ~

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/aur-package-list.sh)

print_info "INSTALLING AUR PACKAGES..."
for package in "${AUR_PACKAGES[@]}"; do
    echo "${package}" | figlet
    paru -S --noconfirm "${package}"
done

# Setup `auto-cpufreq` daemon
sudo systemctl enable --now auto-cpufreq

# Enable snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable --now snapd.apparmor

print_info "CONFIGURING APPLICATIONS..."
# `locate` database
backup_file /etc/updatedb.conf
sudo sed -i '/^PRUNENAMES/s/"$/ .snapshots"/' /etc/updatedb.conf # Ignore BTRFS snapshots
sudo updatedb

# Setup tuned
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

# Set ACL on the Libvirt Images Directory...
# Recursively remove any existing ACL permissions on the directory.
sudo setfacl -R -b /var/lib/libvirt/images
# Grant regular user permission to the directory recursively.
sudo setfacl -R -m u:"$USER":rwX /var/lib/libvirt/images
# Enable 'default' special permissions so that any new directories created
# inside the directory will inherit the ACL permissions.
sudo setfacl -m d:u:"$USER":rwx /var/lib/libvirt/images

# Setup tldr database
tldr --update

# Make CapsLock useful (Single tap for Escape, hold for Left Control)
apply_config /etc/evremap.toml
sudo systemctl daemon-reload
sudo systemctl enable --now evremap

# Theming
papirus-folders -C cat-mocha-blue --theme Papirus-Dark

# Setup dotfiles
print_info "SETTING UP DOTFILES..."
GITHUB_USERNAME=ShyamGadde
chezmoi init --apply "$GITHUB_USERNAME"

# Download wallpapers
gh repo clone ShyamGadde/wallpapers ~/Pictures/wallpapers

# Setup Grimblast
print_info "SETTING UP GRIMBLAST..."
mkdir -p "$HOME/workspace/github.com"
cd "$HOME/workspace/github.com"
git clone "https://github.com/hyprwm/contrib.git" hyprwm-contrib
cd hyprwm-contrib/grimblast
make install

# TODO: Configure Snapper
# 1. Root config
# 2. Home config

# Restart Nautilus to load the new extensions
nautilus -q

# Setup Nautilus extensions
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

# Install hyprls
go install github.com/ewen-lbh/hyprls/cmd/hyprls@latest

# TODO: Create root and home snapshots of **Base System Installation**

# Display instructions to the user
cat << EOF

=====================================
Manual DNS Configuration Instructions
=====================================

To change your DNS settings manually, follow these steps:

1. Run the following command, replacing 'Your Connection Name' with your actual connection name:
   sudo nmcli connection modify "Your Connection Name" ipv4.dns "1.1.1.1 1.0.0.1"

2. Then, apply the changes with:
   sudo nmcli connection up "Your Connection Name"

Make sure to replace "Your Connection Name" with your actual connection name in both commands.

EOF

print_info "Initial 'pass' by using gpg key to sign into Docker Desktop."
print_info "Visit https://docs.docker.com/desktop/get-started/#credentials-management-for-linux-users for more info on how to do that."

echo "DONE!" | figlet -f ansi-shadow | lolcat

# vim: ft=sh ts=4 sts=4 sw=4 et
