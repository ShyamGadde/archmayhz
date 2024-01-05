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

print_info "SETTING TIMEZONE..."
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

print_info "SETTING HARDWARE CLOCK..."
hwclock --systohc --utc

print_info "SETTING LOCALE..."
sed -i 's|.*en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf

print_info "SETTING HOSTNAME..."
echo "${HOSTNAME}" >/etc/hostname

print_info "SETTING UP HOSTS FILE..."
echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >/etc/hosts

# TODO: Is this required?
print_info "SETTING UP INITRAMFS..."
sed -i 's|MODULES=()|MODULES=(btrfs)|' /etc/mkinitcpio.conf
sed -i 's|BINARIES=()|BINARIES=(/usr/bin/btrfs)|' /etc/mkinitcpio.conf
mkinitcpio -P

print_info "SETTING ROOT PASSWORD..."
echo "root:${ROOT_PASSWORD}" | chpasswd

print_info "CREATING USER..."
useradd -m -G wheel,audio,video,optical,storage,sys,log,network,power,rfkill,users,adm -s /bin/zsh $USERNAME
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

print_info "CONFIGURING SUDO FOR USER..."
echo "%wheel ALL=(ALL) ALL" | EDITOR='tee -a' visudo
echo "${USERNAME} ALL=(ALL:ALL) ALL" | EDITOR='tee -a' visudo

print_info "SETTING UP GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

print_info "SETTING UP USER DIRECTORIES..."
xdg-user-dirs-update

print_info "CONFIGURING PACMAN..."
sed -i 's|#Color|Color\nILoveCandy|' /etc/pacman.conf
sed -i 's|#ParallelDownloads.*|ParallelDownloads = 5|' /etc/pacman.conf

print_info "ENABLING MULTILIB..."
sed -i '/#\[\multilib\]/,/Include/s|^#||' /etc/pacman.conf
pacman -Syy --noconfirm

print_info "CONFIGURING REFLECTOR..."
cp /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
sed -i 's|# --country.*|--country India|' /etc/xdg/reflector/reflector.conf
sed -i 's|^--latest.*|--latest 10|' /etc/xdg/reflector/reflector.conf
sed -i 's|^--sort.*|--sort rate|' /etc/xdg/reflector/reflector.conf

print_info "CONFIGURING VCONSOLE..."
FONT="ter-132b"
echo "FONT=${FONT}" >>/etc/vconsole.conf

print_info "ENABLING SERVICES..."
systemctl enable NetworkManager
systemctl enable avahi-daemon # ??
systemctl enable bluetooth
systemctl enable reflector.timer
# TODO: systemctl enable fstrim.timer
systemctl enable paccache.timer
systemctl enable sshd

print_success "INSTALLATION COMPLETE!"
exit
