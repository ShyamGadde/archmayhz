source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

print_info "SETTING UP VCONSOLE..."
setfont ter-132b # Set the font to Terminus 32pt Bold

print_info "CHECKING BOOT MODE..."
if ls /sys/firmware/efi/efivars &>>/dev/null; then
    print_success "UEFI mode detected."
else
    print_warning "Stopping the script. UEFI mode not detected." && exit 1
fi

print_info "CHECKING INTERNET CONNECTION..."
while ! ping -c 1 archlinux.org &>>/dev/null; do
    print_warning "No internet connection detected."
    print_info "Scanning for available networks..."
    iwctl station wlan0 scan
    iwctl station wlan0 get-networks
    print_info "Please enter your wireless network details."
    read -p "Network   : " NETWORK
    read -p "Passphrase: " PASSPHRASE
    iwctl station wlan0 connect ${NETWORK} --passphrase ${PASSPHRASE}
done
print_success "Internet Connection Established"

print_info "GATHERING SETUP INFORMATION..."
read -p "Hostname     : " HOSTNAME
read -p "Root Password: " ROOT_PASSWORD
read -p "Username     : " USERNAME
read -p "User Password: " USER_PASSWORD

print_info "PARTITIONING..."
print_warning "WARNING: This script will erase all data on the selected disk."
lsblk -d
print_info "Please select the disk you want to install Arch Linux on.\nExample: nvme0n1"
read -p "Disk: " DISK
DISK=/dev/${DISK}
umount -A --recursive /mnt &>>/dev/null # Unmount all partitions on the selected disk
sgdisk -Z ${DISK}                       # zap all on disk
sgdisk -a 2048 -o ${DISK}               # Create a new GPT disklabel (partition table) and align partitions to 2048 sectors
sgdisk -n 1:0:+4G -t 1:ef00 ${DISK}     # Create a new EFI partition of 4GB
sgdisk -n 2:0:0 -t 2:8300 ${DISK}       # Create a new Linux partition with the rest of the space
sgdisk -p ${DISK}                       # Print the partition table
partprobe ${DISK}                       # Inform the OS of partition table changes

print_info "FORMATTING PARTITIONS..."
if [[ $DISK =~ nvme ]]; then
    mkfs.vfat -F32 -n EFI ${DISK}p1
    mkfs.btrfs -L LINUX ${DISK}p2 -f
    BTRFS_PARTITION=${DISK}p2
    MOUNT_OPTIONS="noatime,compress=zstd:1,ssd,commit=120"
else
    mkfs.vfat -F32 -n EFI ${DISK}1
    mkfs.btrfs -L LINUX ${DISK}2 -f
    BTRFS_PARTITION=${DISK}2
    MOUNT_OPTIONS="noatime,compress=zstd:1,commit=120"
fi
lsblk -f ${DISK}

print_info "CREATING BTRFS SUBVOLUMES..."
mount -t btrfs ${BTRFS_PARTITION} /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@.snapshots
umount /mnt

print_info "MOUNTING BTRFS SUBVOLUMES..."
mount -t btrfs -o ${MOUNT_OPTIONS},subvol=@ ${BTRFS_PARTITION} /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/log,var/cache/pacman/pkg}
mount -t btrfs -o ${MOUNT_OPTIONS},subvol=@home ${BTRFS_PARTITION} /mnt/home
mount -t btrfs -o ${MOUNT_OPTIONS},subvol=@.snapshots ${BTRFS_PARTITION} /mnt/.snapshots
mount -t btrfs -o ${MOUNT_OPTIONS},subvol=@log ${BTRFS_PARTITION} /mnt/var/log
mount -t btrfs -o ${MOUNT_OPTIONS},subvol=@pkg ${BTRFS_PARTITION} /mnt/var/cache/pacman/pkg
lsblk -f ${DISK}

print_info "MOUNTING BOOT PARTITION..."
if [[ $DISK =~ nvme ]]; then
    mount ${DISK}p1 /mnt/boot
else
    mount ${DISK}1 /mnt/boot
fi
lsblk -f ${DISK}

# TODO: Setup zram?

# TODO: Maybe create a swap file just for hibernation?

print_info "UPDATE SYSTEM CLOCK..."
timedatectl set-ntp true

print_info "UPDATING MIRRORLIST..."
reflector --country 'India' --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm

print_info "INSTALLING ARCH LINUX KEYRING..."
pacman -S archlinux-keyring --noconfirm

print_info "CONFIGURING PACMAN..."
sed -i 's|.*Color|Color\nILoveCandy|' /etc/pacman.conf
sed -i 's|.*ParallelDownloads.*|ParallelDownloads = 5|' /etc/pacman.conf

print_info "INSTALLING ARCH LINUX..."
PACKAGES=$(bash <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/package-lists.sh))
pacstrap -K /mnt $PACKAGES --noconfirm

print_info "GENERATING FSTAB..."
genfstab -U -p /mnt >>/mnt/etc/fstab
sed -i 's/,subvolid=[0-9]*//g' /mnt/etc/fstab # Remove subvolid from fstab
cat /mnt/etc/fstab

print_info "CHROOTING INTO THE NEW SYSTEM..."
arch-chroot /mnt /bin/bash -c "
    export HOSTNAME=${HOSTNAME}
    export ROOT_PASSWORD=${ROOT_PASSWORD}
    export USERNAME=${USERNAME}
    export USER_PASSWORD=${USER_PASSWORD}
    bash <(curl -fsSL ...)"

read -p "Press any key to reboot..."
print_info "REBOOTING..."
umount -R /mnt
reboot
