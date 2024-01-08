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

print_info "SETTING UP SSH KEYS..."
read -p "Enter your Bitwarden email: " BITWARDEN_EMAIL
export BW_SESSION=$(bw login $BITWARDEN_EMAIL --raw)
bw get notes 79984437-d2f8-4483-804f-b0eb00720fca > ~/.ssh/github_ed25519
chmod 600 ~/.ssh/github_ed25519
bw get notes 6bd9e32b-0c2d-4273-925e-b0eb00724b7b > ~/.ssh/github_ed25519.pub
chmod 644 ~/.ssh/github_ed25519.pub

echo "DONE!" | figlet -f slant
