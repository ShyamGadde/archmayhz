set -e

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Localization ------- #
# ---------------------------- #
print_info "SETTING TIMEZONE..."
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

print_info "SETTING HARDWARE CLOCK..."
hwclock --systohc --utc

print_info "SETTING LOCALE..."
echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf

# ---------------------------- #
# ------- Networking --------- #
# ---------------------------- #
print_info "SETTING HOSTNAME..."
echo "${HOSTNAME}" >/etc/hostname

print_info "SETTING UP HOSTS FILE..."
cat <<EOF >/etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain   ${HOSTNAME}
EOF

# ---------------------------- #
# ------- User Accounts ------ #
# ---------------------------- #
print_info "SETTING ROOT PASSWORD..."
echo "root:${ROOT_PASSWORD}" | chpasswd

print_info "CREATING USER..."
useradd -m -g users -G wheel,audio,video,input,optical,storage,sys,log,network,power,rfkill,adm -s /bin/zsh -c "$FULLNAME" "$USERNAME"
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

print_info "CONFIGURING SUDO FOR USER..."
# Granting the user the ability to run any command as any user or any group on any host.
# The first ALL specifies all hosts, the (ALL:ALL) specifies all users and all groups, and the final ALL specifies all commands.
echo "${USERNAME} ALL=(ALL:ALL) ALL" >/etc/sudoers.d/$USERNAME
# Setting the permissions of the file to read-only for owner and group for security reasons.
chmod 0440 /etc/sudoers.d/$USERNAME

# ---------------------------- #
# ------- Initramfs ---------- #
# ---------------------------- #
print_info "CONFIGURING VCONSOLE..."
if [ -f /etc/vconsole.conf ]; then
	cp /etc/vconsole.conf /etc/vconsole.conf.bak
fi
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/vconsole.conf >/etc/vconsole.conf

print_info "CONFIGURING MKINITCPIO..."
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/mkinitcpio.conf >/etc/mkinitcpio.conf
mkinitcpio -P

# ---------------------------- #
# ------- Bootloader --------- #
# ---------------------------- #
print_info "INSTALLING UP GRUB..."
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --removable --recheck

# ---------------------------- #
# ------- ZRAM Swap ---------- #
# ---------------------------- #
print_info "SETTING UP ZRAM SWAP..."
# For enabling zram
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/zram-generator.conf >/etc/systemd/zram-generator.conf
# For Optimizing zram parameters (Arch Wiki)
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/99-vm-zram-parameters.conf >/etc/sysctl.d/99-vm-zram-parameters.conf

print_info "CONFIGURING GRUB..."
cp /etc/default/grub /etc/default/grub.bak
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/grub >/etc/default/grub
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/custom.cfg >/boot/grub/custom.cfg
grub-mkconfig -o /boot/grub/grub.cfg

# ---------------------------- #
# ------- Pacman ------------- #
# ---------------------------- #
print_info "CONFIGURING PACMAN..."
cp /etc/pacman.conf /etc/pacman.conf.bak
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/pacman.conf >/etc/pacman.conf
pacman -Syy --noconfirm

print_info "CONFIGURING REFLECTOR..."
cp /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/reflector.conf >/etc/xdg/reflector/reflector.conf

# ---------------------------- #
# ------- Services ----------- #
# ---------------------------- #
print_info "ENABLING SERVICES..."
systemctl enable acpid
systemctl enable bluetooth
systemctl enable fstrim.timer
systemctl enable gpm
systemctl enable NetworkManager
systemctl enable paccache.timer
systemctl enable pkgfile-update.timer
systemctl enable reflector.timer
systemctl enable sddm
systemctl enable smartd
systemctl enable sshd
systemctl enable systemd-timesyncd # For time synchronization using NTP
systemctl enable tlp
systemctl enable ufw

# ---------------------------- #
# ------- VM Specific -------- #
# ---------------------------- #
if is_vm; then
	print_info "VIRTUAL MACHINE DETECTED. ADDING ENVIRONMENT VARIABLES TO HYPRLAND DESKTOP ENTRY..."
	curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/hyprland-vm.desktop >/usr/share/wayland-sessions/hyprland-vm.desktop
fi

# ---------------------------- #
# --------- Misc ------------- #
# ---------------------------- #
print_info "SETTING UP USER DIRECTORIES..."
xdg-user-dirs-update

# TODO: Setup Plymouth and Plymouth theme
# Note: Add plymouth after base and udev in the hooks array in /etc/mkinitcpio.conf

set +e

echo "INSTALLATION COMPLETE!" | figlet -f slant | lolcat
exit
