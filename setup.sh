source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Localization ------- #
# ---------------------------- #
print_info "SETTING TIMEZONE..."
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

print_info "SETTING HARDWARE CLOCK..."
hwclock --systohc --utc

print_info "SETTING UP TIME SYNCHRONIZATION USING NTP..."
systemctl enable systemd-timesyncd

print_info "SETTING LOCALE..."
sed -i 's|.*en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >>/etc/locale.conf

# ---------------------------- #
# ------- Networking --------- #
# ---------------------------- #
print_info "SETTING HOSTNAME..."
echo "${HOSTNAME}" >/etc/hostname

print_info "SETTING UP HOSTS FILE..."
cat << EOF > /etc/hosts
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
echo "KEYMAP=us" >/etc/vconsole.conf
FONT="ter-128n"
echo "FONT=${FONT}" >>/etc/vconsole.conf

print_info "SETTING UP INITRAMFS FOR BTRFS..."
sed -i 's|MODULES=()|MODULES=(crc32c-intel btrfs)|' /etc/mkinitcpio.conf
sed -i 's|BINARIES=()|BINARIES=(/usr/bin/btrfs)|' /etc/mkinitcpio.conf
mkinitcpio -P

# ---------------------------- #
# ------- Bootloader --------- #
# ---------------------------- #
print_info "INSTALLING UP GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

print_info "CONFIGURING GRUB..."
sed -i 's|GRUB_CMDLINE_LINUX="\(.*\)"|GRUB_CMDLINE_LINUX="\1 rootfstype=btrfs"|' /etc/default/grub
sed -i 's|GRUB_GFXMODE=auto|GRUB_GFXMODE=1920x1080x32,1280x720x32,auto|' /etc/default/grub
cat <<EOF >/boot/grub/custom.cfg
menuentry "System shutdown" --class shutdown {
	echo "System shutting down..."
	halt
}

menuentry "System restart" --class restart {
	echo "System rebooting..."
	reboot
}
EOF

# ---------------------------- #
# ------- ZRAM Swap ---------- #
# ---------------------------- #
print_info "CREATING ZRAM SWAP..."
echo 0 >/sys/module/zswap/parameters/enabled # Disable zswap
# Add 'zswap.enabled=0' to kernel parameters
sed -i 's|GRUB_CMDLINE_LINUX="\(.*\)"|GRUB_CMDLINE_LINUX="\1 zswap.enabled=0"|' /etc/default/grub
cat <<EOF >/etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

print_info "OPTIMIZING SWAP ON ZRAM..."
cat <<EOF >/etc/sysctl.d/99-vm-zram-parameters.conf
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOF

print_info "GENERATING GRUB CONFIG..."
grub-mkconfig -o /boot/grub/grub.cfg

# ---------------------------- #
# ------- Pacman ------------- #
# ---------------------------- #
print_info "CONFIGURING PACMAN..."
sed -i 's/^#\(UseSyslog\)/\1/' /etc/pacman.conf
sed -i 's/^#\(Color\)/\1\nILoveCandy/' /etc/pacman.conf
sed -i 's/^#\(ParallelDownloads.*\)/\1 = 5/' /etc/pacman.conf
sed -i 's/^#\(VerbosePkgLists\)/\1/' /etc/pacman.conf
sed -i 's/^#\(CheckSpace\)/\1/' /etc/pacman.conf
sed -i '/#\[\multilib\]/,/Include/s/^#//' /etc/pacman.conf
pacman -Syy --noconfirm

print_info "CONFIGURING REFLECTOR..."
cp /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
sed -i 's/^# \(--country\).*/\1 India/' /etc/xdg/reflector/reflector.conf
sed -i 's/^\(--latest\).*/\1 15/' /etc/xdg/reflector/reflector.conf
sed -i 's/^\(--sort\).*/\1 rate/' /etc/xdg/reflector/reflector.conf

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
systemctl enable reflector.timer
systemctl enable sddm
systemctl enable smartd
systemctl enable sshd
systemctl enable tlp
systemctl enable ufw

# ---------------------------- #
# ------- VM Specific -------- #
# ---------------------------- #
if is_vm; then
	print_info "VIRTUAL MACHINE DETECTED. ADDING ENVIRONMENT VARIABLES TO HYPRLAND DESKTOP ENTRY..."
	sed -i 's|Exec=Hyprland|Exec=env WLR_RENDERER_ALLOW_SOFTWARE=1 WLR_NO_HARDWARE_CURSORS=1 Hyprland|' /usr/share/wayland-sessions/hyprland.desktop
fi

# ---------------------------- #
# ------- Eye Candy ---------- #
# ---------------------------- #
print_info "SETTING UP USER DIRECTORIES..."
xdg-user-dirs-update

# TODO: Setup Plymouth and Plymouth theme
# Note: Add plymouth after base and udev in the hooks array in /etc/mkinitcpio.conf

print_success "INSTALLATION COMPLETE!"
exit
