BASE_SYSTEM=(
    base
    efibootmgr
    grub
    intel-ucode
    linux
    linux-firmware
    linux-lts
    linux-zen
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
    fontconfig
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
    fzf
    gpm # General Purpose Mouse Interface (for mouse support in the tty)
    less
    man-db
    man-pages
    nano
    neofetch
    neovim
    pacman-contrib
    plocate       # A much faster locate(1) implementation
    reflector     # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
    smartmontools # Control and monitor S.M.A.R.T. enabled ATA and SCSI Hard Drives
    speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
    tlp           # Advanced power management tool for Linux
    ufw           # Uncomplicated Firewall
    vi
    vim
    xdg-user-dirs # Creates user directories (e.g. Desktop dir) automatically
    xdg-utils     # Command line tools that assist applications with a variety of desktop integration tasks
    zram-generator
    zsh
)

DEVELOPMENT=(
    base-devel
    git
    linux-headers
    linux-lts-headers
    linux-zen-headers
)

EXTRA=(
    bitwarden
    bitwarden-cli
    thunar
    firefox
    foot
    kitty
)

FUN=(
    cmatrix # Terminal based "Matrix" screensaver
    cowsay
    figlet # Make large character ASCII banners out of ordinary text
    lolcat # Rainbows and unicorns!
    sl     # Steam Locomotive
)

PACMAN_PACKAGES=(
    "${BASE_SYSTEM[@]}"
    "${FILESYSTEM[@]}"
    "${GRAPHICS_DRIVERS[@]}"
    "${NETWORKING[@]}"
    "${BLUETOOTH[@]}"
    "${FONTS[@]}"
    "${HYPRLAND[@]}"
    "${MULTIMEDIA[@]}"
    "${UTILITIES[@]}"
    "${DEVELOPMENT[@]}"
    "${EXTRA[@]}"
    "${FUN[@]}"
)
