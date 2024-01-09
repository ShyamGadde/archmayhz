set -e

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Services ----------- #
# ---------------------------- #
print_info "ENABLING UFW..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh

print_info "ENABLING PIPEWIRE..."
systemctl --user enable --now pipewire
systemctl --user enable --now pipewire-pulse
systemctl --user enable --now wireplumber

print_info "UPDATING PLOCATE DATABASE..."
cp /etc/updatedb.conf /etc/updatedb.conf.bak
sudo sed -i '/^PRUNENAMES/s/"$/ .snapshots"/' /etc/updatedb.conf # Ignore BTRFS snapshots
sudo updatedb

# ---------------------------- #
# ---------- AUR ------------- #
# ---------------------------- #
print_info "INSTALLING PARU..."
git clone https://aur.archlinux.org/paru-bin.git ~/repos/paru-bin
cd ~/repos/paru-bin
makepkg -si --noconfirm
cd ~

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/aur-package-list.sh)

print_info "INSTALLING AUR PACKAGES..."
for package in "${AUR_PACKAGES[@]}"; do
    echo "${package}" | figlet
    paru -S "${package}"
done

# ---------------------------- #
# ---------- SSH ------------- #
# ---------------------------- #
print_info "SETTING UP SSH KEYS..."
export BW_SESSION=$(bw login --raw)
mkdir -p ~/.ssh
bw get notes 79984437-d2f8-4483-804f-b0eb00720fca >~/.ssh/github_ed25519
chmod 600 ~/.ssh/github_ed25519
bw get notes 6bd9e32b-0c2d-4273-925e-b0eb00724b7b >~/.ssh/github_ed25519.pub
chmod 644 ~/.ssh/github_ed25519.pub

echo "DONE!" | figlet -f slant | lolcat
