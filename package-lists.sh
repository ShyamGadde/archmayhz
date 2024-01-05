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
    ntfs-3g
)

GRAPHICS_DRIVERS=(
    intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
    mesa               # An open-source implementation of the OpenGL specification
    vulkan-intel
    onevpl-intel-gpu # For video processing and transcoding
)

FONTS=(
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk
    terminus-font
    ttf-dejavu
    ttf-liberation
    gnu-free-fonts
    ttf-fira-code
    ttf-fira-mono
    ttf-fira-sans
    ttf-firacode-nerd
    ttf-cascadia-code
    ttf-cascadia-code-nerd
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-victor-mono-nerd
)

NETWORKING=(
    curl
    networkmanager
    wget
    openssh
    whois
)

MULTIMEDIA=(
    gimp
    vlc
    pipewire
    pipewire-jack
    wireplumber
    libnotify         # ??
    speech-dispatcher # ??
)

# TODO: Bluetooth support

UTILITIES=(
    archlinux-keyring
    git
    reflector # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
    rsync
    sudo
    tar
    ufw # Uncomplicated Firewall
    unrar
    unzip
    vi
    vim
    nano
    xdg-user-dirs  # Creates user directories (e.g. Desktop dir) automatically
    hunspell-en_US # ??
    inotify-tools  # ??
    zsh
    less
    neofetch
    lynx
    man-db
    man-pages
    mc
    util-linux
)

# WAYLAND=(
#     qt5-wayland
#     qt6-wayland
#     sway
#     waybar
#     wlroots
#     xorg-server-xwayland
#     xdg-desktop-portal
#     xdg-desktop-portal-impl
# )

DESKTOP_APPLICATIONS=(
    firefox
    flatpak
    libreoffice-fresh # LibreOffice branch which contains new features and program enhancements
    kitty
)

PACKAGES=(
    "${BASE_SYSTEM[@]}"
    "${FILESYSTEM[@]}"
    "${GRAPHICS_DRIVERS[@]}"
    "${FONTS[@]}"
    "${NETWORKING[@]}"
    "${MULTIMEDIA[@]}"
    "${UTILITIES[@]}"
    "${DESKTOP_APPLICATIONS[@]}"
)
