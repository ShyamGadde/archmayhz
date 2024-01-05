GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHTBLUE='\033[1;34m'
RESET='\033[0m'

print_info() {
    message=$1
    width=$(tput cols)
    padding=$(((width - ${#message}) / 2))

    printf '\n%*s\n' "${width}" '' | tr ' ' '-'
    printf "${LIGHTBLUE}%*s%s${RESET}\n" $padding '' "$message"
    printf '%*s\n\n' "${width}" '' | tr ' ' '-'
}

print_warning() {
    message=$1
    width=$(tput cols)
    padding=$(((width - ${#message}) / 2))

    printf '\n%*s\n' "${width}" '' | tr ' ' '-'
    printf "${RED}%*s%s${RESET}\n" $padding '' "$message"
    printf '%*s\n\n' "${width}" '' | tr ' ' '-'
}

print_success() {
    message=$1
    width=$(tput cols)
    padding=$(((width - ${#message}) / 2))

    printf '\n%*s\n' "${width}" '' | tr ' ' '-'
    printf "${GREEN}%*s%s${RESET}\n" $padding '' "$message"
    printf '%*s\n\n' "${width}" '' | tr ' ' '-'
}

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
