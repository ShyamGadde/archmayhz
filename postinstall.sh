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

# TODO: Skip review and password prompt
print_info "INSTALLING AUR PACKAGES..."
for package in "${AUR_PACKAGES[@]}"; do
    echo "${package}" | figlet
    paru -S "${package}"
done

# Setup `auto-cpufreq` daemon
sudo systemctl enable --now auto-cpufreq

# Enable snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable --now snapd.apparmor

print_info "INSTALLING PYENV AND FRIENDS..."
curl https://pyenv.run | bash # The pyenv package in the Arch Linux repositories doesn't install shell completions for some reason

# Initialize pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install -v $(pyenv install --list | grep -E '^\s+[0-9.]+$' | tail -n 1) # Install the latest version of Python
pyenv global system                                                           # Set the global version of Python to the latest version

print_info "CONFIGURING APPLICATIONS..."
# `locate` database
backup_file /etc/updatedb.conf
sudo sed -i '/^PRUNENAMES/s/"$/ .snapshots"/' /etc/updatedb.conf # Ignore BTRFS snapshots
sudo updatedb

# Setup tuned
sudo systemctl enable --now tuned
sudo tuned-adm profile virtual-host
sudo tuned-adm verify

# Setup tldr database
tldr --update

# Make CapsLock useful (Single tap for Escape, hold for Left Control)
apply_config /etc/evremap.toml
sudo systemctl daemon-reload
sudo systemctl enable --now evremap

# Theming
papirus-folders -C cat-mocha-blue --theme Papirus-Dark

# TODO: Downlaod dotfiles

print_info "SETTING UP ZSH..."
git clone https://github.com/lukechilds/zsh-nvm.git $HOME/.config/zsh/plugins/zsh-nvm

mkdir -p $HOME/.config/zsh/plugins
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $HOME/.config/zsh/plugins/fast-syntax-highlighting

zsh
fast-theme XDG:catppuccin-mocha # Set the theme for fast-syntax-highlighting
exit

print_info "SETTING UP SSH..."
ssh-add ~/.ssh/github-cli

# Setup GitHub CLI
print_info "SETTING UP GITHUB CLI..."
gh auth login --web -h github.com
gh auth setup-git
# Download extensions:
gh extension install github/gh-copilot
gh extension install yuler/gh-download

# TODO: Configure Snapper
# 1. Root config
# 2. Home config

# Restart Nautilus to load the new extensions
nautilus -q

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

# Download tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# TODO: Create root and home snapshots of **Base System Installation**

echo "DONE!" | figlet -f ansi-shadow | lolcat
