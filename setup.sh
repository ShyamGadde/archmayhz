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
#echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD ALL" >/etc/sudoers.d/$USERNAME
# Setting the permissions of the file to read-only for owner and group for security reasons.
chmod 0440 /etc/sudoers.d/$USERNAME
echo "Defaults pwfeedback" >>/etc/sudoers.d/pwfeedback
echo "Defaults insults" >>/etc/sudoers.d/insults

# --------------------------------------- #
# ------- Initramfs and Modules---------- #
# --------------------------------------- #
print_info "CONFIGURING VCONSOLE..."
if [ -f /etc/vconsole.conf ]; then
	backup_file /etc/vconsole.conf
fi
apply_config /etc/vconsole.conf

# Make wireless mouse work
apply_config /etc/modprobe.d/psmouse.conf

# Enable GuC and HuC
apply_config /etc/modprobe.d/i915.conf

print_info "CONFIGURING MKINITCPIO..."
backup_file /etc/mkinitcpio.conf
apply_config /etc/mkinitcpio.conf
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
apply_config /etc/systemd/zram-generator.conf
# For Optimizing zram parameters (Arch Wiki)
apply_config /etc/sysctl.d/99-vm-zram-parameters.conf

print_info "CONFIGURING GRUB..."
backup_file /etc/default/grub
apply_config /etc/default/grub
apply_config /boot/grub/custom.cfg
grub-mkconfig -o /boot/grub/grub.cfg

# ---------------------------- #
# ------- Pacman ------------- #
# ---------------------------- #
print_info "CONFIGURING PACMAN..."
backup_file /etc/pacman.conf
apply_config /etc/pacman.conf
pacman -Syy --noconfirm

print_info "CONFIGURING REFLECTOR..."
backup_file /etc/xdg/reflector/reflector.conf
apply_config /etc/xdg/reflector/reflector.conf

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
systemctl enable pacman-filesdb-refresh.timer
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
	print_info "VIRTUAL MACHINE DETECTED. ADDING ENVIRONMENT VARIABLES TO HYPRLAND SESSION..."
	apply_config /usr/share/wayland-sessions/hyprland-vm.desktop
fi

# ---------------------------- #
# --------- Misc ------------- #
# ---------------------------- #
print_info "SETTING UP USER DIRECTORIES..."
xdg-user-dirs-update

# Add figlet font
curl -fsS https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf >/usr/share/figlet/fonts/ansi-shadow.flf

# Enable performance support for Intel GPUs using Observation Architecture
apply_config /etc/sysctl.d/99-sysctl.conf

# So that I can open a file with neovim from the file manager context menu without getting an error
ln -s /usr/bin/kitty /usr/bin/xdg-terminal-exec

# TODO: Apply SDDM theme

# TODO: Setup Plymouth and Plymouth theme
# Note: Add plymouth hook after base and udev in the hooks array in /etc/mkinitcpio.conf

set +e

echo "INSTALLATION COMPLETE!" | figlet -f ansi-shadow | lolcat
exit
