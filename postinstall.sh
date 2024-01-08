source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

print_info "ENABLING UFW..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh

print_info "ENABLING PIPEWIRE..."
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber

print_info "INSTALLING PARU..."
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin
makepkg -si --noconfirm
cd ~

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/aur-package-list.sh)

print_info "INSTALLING AUR PACKAGES..."
for package in "${AUR_PACKAGES[@]}"; do
    paru -S "${package}"
done
