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
    onevpl-intel-gpu   # For video processing and transcoding
    vulkan-intel
)

FONTS=(
    gnu-free-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    terminus-font
    ttf-cascadia-code
    ttf-cascadia-code-nerd
    ttf-dejavu
    ttf-fira-code
    ttf-fira-mono
    ttf-fira-sans
    ttf-firacode-nerd
    ttf-jetbrains-mono
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-victor-mono-nerd
)

NETWORKING=(
    curl
    networkmanager
    openssh
    wget
    whois
)

MULTIMEDIA=(
    gimp
    libnotify # ??
    pipewire
    pipewire-jack
    speech-dispatcher # ??
    vlc
    wireplumber
)

# TODO: Bluetooth support

UTILITIES=(
    archlinux-keyring
    git
    gpm            # General Purpose Mouse Interface (for mouse support in the tty)
    hunspell-en_US # ??
    inotify-tools  # ??
    less
    lynx
    man-db
    man-pages
    mc
    nano
    neofetch
    pacman-contrib
    reflector # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
    rsync
    sudo
    tar
    ufw # Uncomplicated Firewall
    unrar
    unzip
    util-linux
    vi
    vim
    xdg-user-dirs # Creates user directories (e.g. Desktop dir) automatically
    zsh
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
    kitty
    libreoffice-fresh # LibreOffice branch which contains new features and program enhancements
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
