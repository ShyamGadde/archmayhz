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
    paru -S "${package}"
done

print_info "INSTALLING PYENV AND FRIENDS..."
curl https://pyenv.run | bash # The pyenv package in the Arch Linux repositories doesn't install shell completions for some reason

print_info "SETTING UP NVM..."
git clone https://github.com/lukechilds/zsh-nvm.git $HOME/.config/zsh/plugins/zsh-nvm

print_info "CONFIGURING APPLICATIONS..."
# Fix Anki text pixelated on wayland by using xwayland (Probably a problem with QT apps on wayland, having similar problems with Telegram-Desktop)
apply_config /usr/local/bin/anki
chmod +x /usr/local/bin/anki

# `locate` database
backup_file /etc/updatedb.conf
sudo sed -i '/^PRUNENAMES/s/"$/ .snapshots"/' /etc/updatedb.conf # Ignore BTRFS snapshots
sudo updatedb

# Setup tldr database
tldr --update

# Make CapsLock useful (Single tap for Escape, hold for Left Control)
apply_config /etc/evremap.toml
sudo systemctl daemon-reload
sudo systemctl enable --now evremap

# Theming
papirus-folders -C cat-mocha-blue --theme Papirus-Dark

# TODO: Downlaod dotfiles

print_info "SETTING UP SSH..."
ssh-add ~/.ssh/github-cli

# TODO: Setup GitHub CLI
print_info "SETTING UP GITHUB CLI..."
gh auth login --web -h github.com
gh auth setup-git
# Download extensions:
gh extension install github/gh-copilot
gh extension install yuler/gh-download

# TODO: Configure Snapper
# 1. Root config
# 2. Home config

# TODO: Create root and home snapshots of **Base System Installation**

echo "DONE!" | figlet -f ansi-shadow | lolcat
