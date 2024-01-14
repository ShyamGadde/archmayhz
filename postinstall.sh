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

print_info "UPDATING PLOCATE DATABASE..."
backup_file /etc/updatedb.conf
sudo sed -i '/^PRUNENAMES/s/"$/ .snapshots"/' /etc/updatedb.conf # Ignore BTRFS snapshots
sudo updatedb

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
    paru -S "${package}"
done

print_info "CONFIGURING APPLICATIONS..."
# Fix Anki text pixelated on qt6 with wayland by using xwayland
apply_config /usr/local/bin/anki
chmod +x /usr/local/bin/anki

# Make applications run on wayland instead.
# Obsidian
apply_config /usr/local/bin/obsidian
chmod +x /usr/local/bin/obsidian
sed -i 's|Exec=/usr/bin/obsidian\(.*\)|Exec=obsidian\1|g' /usr/share/applications/obsidian.desktop
# Microsoft Edge
apply_config /usr/local/bin/microsoft-edge-stable
chmod +x /usr/local/bin/microsoft-edge-stable
sed -i 's|Exec=/usr/bin/microsoft-edge-stable\(.*\)|Exec=microsoft-edge-stable\1|g' /usr/share/applications/microsoft-edge.desktop

# TODO: Configure Snapper
# 1. Root config
# 2. Home config

# TODO: Downlaod dotfiles

# TODO: Setup GitHub CLI

# Theming
papirus-folders -C cat-mocha-blue --theme Papirus-Dark

# TODO: Create root and home snapshots of **Base System Installation**

echo "DONE!" | figlet -f slant | lolcat
