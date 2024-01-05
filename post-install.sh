source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

print_info "SETTING UP FIREWALL..."
ufw enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh

print_info "INSTALLING YAY..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

print_info "INSTALLING PACKAGES FROM AUR..."
yay -S google-chrome visual-studio-code-bin snapper-support
# preload - Daemon that collects data from regular software usage and reduces filesystem access times
