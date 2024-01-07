BASE_SYSTEM=(
    base
    base-devel
    efibootmgr
    grub
    intel-ucode
    linux
    linux-firmware
    linux-headers
    linux-lts
    linux-lts-headers
    linux-zen
    linux-zen-headers
)

FILESYSTEM=(
    btrfs-progs
    dosfstools
    exfatprogs
    mtools # Tools to access MS-DOS disks
    ntfs-3g
)

GRAPHICS_DRIVERS=(
    intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
    libva-mesa-driver
    mesa             # An open-source implementation of the OpenGL specification
    onevpl-intel-gpu # runtime for Tiger Lake and newer GPUs
    vulkan-intel
)

NETWORKING=(
    iwd
    network-manager-applet # System tray applet for connecting to Internet
    networkmanager
    wget
    whois
    wireless_tools
)

BLUETOOTH=(
    bluez
    bluez-utils
    blueman
)

FONTS=(
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    otf-font-awesome
    terminus-font
    ttf-cascadia-code
    ttf-cascadia-code-nerd
    ttf-dejavu
    ttf-droid
    ttf-fira-code
    ttf-firacode-nerd
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-victor-mono-nerd
)

HYPRLAND=(
    hyprland
    qt5-wayland
    qt6-wayland
    sddm
    swaync
    wofi
    xdg-desktop-portal-hyprland
)

MULTIMEDIA=(
    gst-plugin-pipewire
    mpv
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    wireplumber
)

UTILITIES=(
    acpi      # Client for battery, power, and thermal readings
    acpi_call # A linux kernel module that enables calls to ACPI methods through /proc/acpi/call
    acpid     # Advanced Configuration and Power Interface event daemon
    bat
    git
    gpm # General Purpose Mouse Interface (for mouse support in the tty)
    grub-btrfs
    less
    lynx
    man-db
    man-pages
    nano
    neofetch
    neovim
    pacman-contrib
    reflector     # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
    smartmontools # Control and monitor S.M.A.R.T. enabled ATA and SCSI Hard Drives
    tlp           # Advanced power management tool for Linux
    ufw           # Uncomplicated Firewall
    vi
    vim
    xdg-user-dirs # Creates user directories (e.g. Desktop dir) automatically
    xdg-utils     # Command line tools that assist applications with a variety of desktop integration tasks
    zsh
)

EXTRA=(
    dolphin
    firefox
    foot
    kitty
    # TODO: Add Bitwarden desktop and cli
)

FUN=(
    cmatrix
    cowsay
    figlet
    sl
)

PACKAGES=(
    "${BASE_SYSTEM[@]}"
    "${FILESYSTEM[@]}"
    "${GRAPHICS_DRIVERS[@]}"
    "${NETWORKING[@]}"
    "${BLUETOOTH[@]}"
    "${FONTS[@]}"
    "${HYPRLAND[@]}"
    "${MULTIMEDIA[@]}"
    "${UTILITIES[@]}"
    "${EXTRA[@]}"
    "${FUN[@]}"
)
