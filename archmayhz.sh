set -e

source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/utils.sh)

# ---------------------------- #
# ------- Basic Setup -------- #
# ---------------------------- #
print_info "SETTING UP VCONSOLE..."
setfont ter-128n # Set the font to Terminus 32pt Bold

print_info "CHECKING BOOT MODE..."
if ls /sys/firmware/efi/efivars &>>/dev/null; then
    print_success "UEFI mode detected."
else
    print_warning "Stopping the script. UEFI mode not detected." && exit 1
fi

print_info "CHECKING INTERNET CONNECTION..."
while ! ping -c 1 archlinux.org &>>/dev/null; do
    print_warning "NO INTERNET CONNECTION DETECTED"
    print_info "SCANNING FOR AVAILABLE NETWORKS..."
    iwctl station wlan0 scan
    iwctl station wlan0 get-networks
    echo "\nPlease enter your wireless network details."
    read -p "Network   : " NETWORK
    read -p "Passphrase: " PASSPHRASE
    iwctl station wlan0 connect ${NETWORK} --passphrase ${PASSPHRASE}
done
print_success "INTERNET CONNECTION ESTABLISHED"

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

set -x
lsblk -d
echo -e "\nPlease select the disk you want to install Arch Linux on.\nExample: nvme0n1\n"
read -p "Disk: " DISK
DISK=/dev/${DISK}
umount -A --recursive /mnt &>>/dev/null # Unmount all partitions on the selected disk
sgdisk -Z ${DISK}                       # zap all on disk
sgdisk -a 2048 -o ${DISK}               # Create a new GPT disklabel (partition table) and align partitions to 2048 sectors
sgdisk -n 1:0:+4G -t 1:ef00 ${DISK}     # Create a new EFI partition of 4GB
sgdisk -n 2:0:0 -t 2:8300 ${DISK}       # Create a new Linux partition with the rest of the space
sgdisk -p ${DISK}                       # Print the partition table
partprobe ${DISK}                       # Inform the OS of partition table changes
set +x

print_info "FORMATTING THE PARTITIONS..."
if [[ $DISK =~ nvme ]]; then
    BOOT_PARTITION=${DISK}p1
    BTRFS_PARTITION=${DISK}p2
else
    BOOT_PARTITION=${DISK}1
    BTRFS_PARTITION=${DISK}2
fi
set -x
mkfs.vfat -F32 -n EFI ${BOOT_PARTITION}
mkfs.btrfs -L LINUX ${BTRFS_PARTITION} -f
lsblk -f ${DISK}

# ----------------------------- #
# ------- BTRFS Setup --------- #
# ----------------------------- #
print_info "CREATING BTRFS SUBVOLUMES..."
mount -t btrfs ${BTRFS_PARTITION} /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@.snapshots # TODO: @.snapshots or just @snapshots?
umount /mnt

print_info "MOUNTING BTRFS SUBVOLUMES..."
MOUNT_OPTIONS="defaults,x-mount.mkdir,noatime,compress=zstd,commit=120"
mount -t btrfs -o subvol=@,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt
mount -t btrfs -o subvol=@home,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/home
mount -t btrfs -o subvol=@.snapshots,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/.snapshots
mount -t btrfs -o subvol=@log,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/log
mount -t btrfs -o subvol=@pkg,${MOUNT_OPTIONS} ${BTRFS_PARTITION} /mnt/var/cache/pacman/pkg
lsblk -f ${DISK}

# TODO: Create Swapfile
#truncate -s 0 /mnt/.swapvol/swapfile
#chattr +C /mnt/.swapvol/swapfile
#btrfs property set /mnt/.swapvol/swapfile compression none
#fallocate -l 16G /mnt/.swapvol/swapfile
#chmod 600 /mnt/.swapvol/swapfile
#mkswap /mnt/.swapvol/swapfile
#swapon /mnt/.swapvol/swapfile
# TODO: Get offset and resume for BTRFS swapfile

print_info "MOUNTING EFI PARTITION..."
mkdir /mnt/boot
mount ${BOOT_PARTITION} /mnt/boot
lsblk -f ${DISK}

# ---------------------------- #
# ------- Installation ------- #
# ---------------------------- #
print_info "SETTING UP TIME SYNCHRONIZATION USING NTP..."
timedatectl set-ntp on

print_info "UPDATING MIRRORLIST..."
reflector --country 'India' --latest 15 --sort rate --verbose --save /etc/pacman.d/mirrorlist
pacman -Syy --noconfirm

print_info "INSTALLING ARCH LINUX KEYRING..."
pacman -S archlinux-keyring --noconfirm

print_info "CONFIGURING PACMAN..."
cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/^#\(UseSyslog\)/\1/' /etc/pacman.conf
sed -i 's/^#\(Color\)/\1\nILoveCandy/' /etc/pacman.conf
sed -i 's/^#\(ParallelDownloads.*\)/\1 = 5/' /etc/pacman.conf
sed -i 's/^#\(VerbosePkgLists\)/\1/' /etc/pacman.conf
sed -i 's/^#\(CheckSpace\)/\1/' /etc/pacman.conf

print_info "INSTALLING ARCH LINUX..."
source <(curl -fsSL https://raw.githubusercontent.com/ShyamGadde/archmayhz/main/pacman-package-list.sh)
pacstrap /mnt "${PACMAN_PACKAGES[@]}" --noconfirm

print_info "GENERATING FSTAB..."
genfstab -U -p /mnt >>/mnt/etc/fstab
cat /mnt/etc/fstab

cp /mnt/etc/fstab /mnt/etc/fstab.bak
sed -i 's/,subvolid=[0-9]*//g' /mnt/etc/fstab # Remove subvolid from fstab
cat /mnt/etc/fstab

set +x

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
read -p "Press any key to reboot..."
print_info "REBOOTING..."
umount -R /mnt
reboot
