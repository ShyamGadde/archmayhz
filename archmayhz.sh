set -e

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Basic Setup -------- #
# ---------------------------- #
print_info "SETTING UP VCONSOLE..."
setfont ter-128b # Set the font to Terminus 128 Bold

print_info "CHECKING BOOT MODE..."
if ls /sys/firmware/efi/efivars &>>/dev/null; then
    print_success "UEFI mode detected."
else
    print_warning "Stopping the script. UEFI mode not detected." && exit 1
fi

read -p "Press enter to continue..."

# ---------------------------- #
# ------- User Setup --------- #
# ---------------------------- #
print_info "GATHERING SETUP INFORMATION..."
read -p "Hostname     : " HOSTNAME
read -p "Root Password: " ROOT_PASSWORD
read -p "Username     : " USERNAME
read -p "Full Name    : " FULLNAME
read -p "User Password: " USER_PASSWORD

# ---------------------------- #
# ------- Disk Setup --------- #
# ---------------------------- #
print_info "PARTIONING THE DISKS..."
print_warning "WARNING: This script will erase all data on the selected disk."

lsblk -d
echo -e "\nPlease select the disk you want to install Arch Linux on.\nExample: nvme0n1\n"
read -p "Disk: " DISK
DISK=/dev/${DISK}

if mount | grep /mnt >/dev/null; then
    umount -A --recursive /mnt # Unmount all partitions on the disk
fi
sgdisk -Z ${DISK}                     # zap all on disk
sgdisk -a 2048 -o ${DISK}             # Create a new GPT disklabel (partition table) and align partitions to 2048 sectors
sgdisk -n 1:0:+512M -t 1:ef00 ${DISK} # Create a new EFI partition of 512MB
sgdisk -n 2:0:+900G -t 2:8300 ${DISK} # Create a new Linux partition of 900G
#sgdisk -n 2:0:0 -t 2:8300 ${DISK}    # Create a new Linux partition with the rest of the space
sgdisk -p ${DISK}                     # Print the partition table
partprobe ${DISK}                     # Inform the OS of partition table changes

print_info "FORMATTING THE PARTITIONS..."
if [[ $DISK =~ nvme ]]; then
    BOOT_PARTITION=${DISK}p1
    BTRFS_PARTITION=${DISK}p2
else
    BOOT_PARTITION=${DISK}1
    BTRFS_PARTITION=${DISK}2
fi

mkfs.vfat -F32 -n EFI ${BOOT_PARTITION}
mkfs.btrfs -L ROOT ${BTRFS_PARTITION} -f
lsblk -f ${DISK}

read -p "Press enter to continue..."

# ----------------------------- #
# ------- BTRFS Setup --------- #
# ----------------------------- #
print_info "CREATING BTRFS SUBVOLUMES..."
mount -t btrfs ${BTRFS_PARTITION} /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@docker
btrfs subvolume create /mnt/@libvirt
btrfs subvolume create /mnt/@swap
btrfs subvolume list /mnt
#btrfs subvolume set-default 256 /mnt
umount /mnt

read -p "Press enter to continue..."

print_info "MOUNTING BTRFS SUBVOLUMES..."
MOUNT_OPTIONS="defaults,x-mount.mkdir,noatime,compress=zstd,commit=120"
mount -t btrfs -o subvol=@,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt
mount -t btrfs -o subvol=@home,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/home
mount -t btrfs -o subvol=@cache,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/cache
mount -t btrfs -o subvol=@log,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/log
mount -t btrfs -o subvol=@tmp,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/tmp
mount -t btrfs -o subvol=@docker,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/lib/docker
mount -t btrfs -o subvol=@libvirt,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/lib/libvirt
mount -t btrfs -o subvol=@swap,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/swap
#mount -t btrfs -o subvol=/,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/btrfsroot
lsblk -f ${DISK}

read -p "Press enter to continue..."

print_info "MOUNTING EFI PARTITION..."
mkdir /mnt/efi
mount ${BOOT_PARTITION} /mnt/efi
lsblk -f ${DISK}

# ---------------------------- #
# ------- Installation ------- #
# ---------------------------- #
print_info "SETTING UP TIME SYNCHRONIZATION USING NTP..."
timedatectl set-ntp on

print_info "UPDATING MIRRORLIST..."
reflector --country 'India' --latest 15 --sort rate --verbose --save /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm
read -p "Press enter to continue..."

cat /etc/pacman.d/mirrorlist
read -p "Press enter to continue..."

print_info "UPDATING ARCH LINUX KEYRING..."
pacman -S archlinux-keyring --noconfirm

print_info "CONFIGURING PACMAN..."
cp /etc/pacman.conf /etc/pacman.conf.bak
curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/configs/pacman.conf >/etc/pacman.conf

print_info "INSTALLING ARCH LINUX..."
source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/pacman-package-list.sh)
pacstrap /mnt "${PACMAN_PACKAGES[@]}" --noconfirm

print_info "GENERATING FSTAB..."
genfstab -U -p /mnt >>/mnt/etc/fstab
cat /mnt/etc/fstab

read -p "Press enter to continue..."

cp /mnt/etc/fstab /mnt/etc/fstab.bak
sed -i 's/,subvolid=[0-9]*//g' /mnt/etc/fstab # Remove subvolid from fstab to work with snapper
cat /mnt/etc/fstab

read -p "Press enter to continue..."

# ---------------------------- #
# ------- System Setup ------- #
# ---------------------------- #
print_info "CHROOTING INTO THE NEW SYSTEM..."
arch-chroot /mnt /bin/bash -c "
    export HOSTNAME=${HOSTNAME}
    export ROOT_PASSWORD=${ROOT_PASSWORD}
    export USERNAME=${USERNAME}
    export FULLNAME=${FULLNAME}
    export USER_PASSWORD=${USER_PASSWORD}
    bash <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/setup.sh)"

set +e

# ---------------------------- #
# ------- Rebooting ---------- #
# ---------------------------- #
read -p "Press enter to reboot..."
print_info "REBOOTING..."
umount -R /mnt
reboot
