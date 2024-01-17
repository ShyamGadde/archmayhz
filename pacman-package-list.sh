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
    ttf-cascadia-code-nerd
    ttf-dejavu
    ttf-droid
    ttf-firacode-nerd
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-victor-mono-nerd
)

HYPRLAND=(
    hyprland
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    sddm
    waybar
    wofi
    xdg-desktop-portal-hyprland
)

MULTIMEDIA=(
    gst-plugin-pipewire
    mpv
    pavucontrol
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    sof-firmware # Sound Open Firmware
    wireplumber
)

UTILITIES=(
    acpi      # Client for battery, power, and thermal readings
    acpi_call # A linux kernel module that enables calls to ACPI methods through /proc/acpi/call
    acpid     # Advanced Configuration and Power Interface event daemon
    bat
    brightnessctl
    btop
    duf # Disk Usage/Free Utility
    fzf
    gnome-keyring # Stores passwords and encryption keys
    gpm           # General Purpose Mouse Interface (for mouse support in the tty)
    gvfs          # Virtual filesystem implementation for GIO (for mounting USB drives in Thunar)
    less
    man-db
    man-pages
    nano
    neofetch
    neovim
    pacman-contrib
    pkgfile
    plocate   # A much faster locate(1) implementation
    reflector # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
    ripgrep
    smartmontools # Control and monitor S.M.A.R.T. enabled ATA and SCSI Hard Drives
    speedtest-cli # Command line interface for testing internet bandwidth using speedtest.net
    tlp           # Advanced power management tool for Linux
    ufw           # Uncomplicated Firewall
    vi
    vim
    xdg-user-dirs # Creates user directories (e.g. Desktop dir) automatically
    xdg-utils     # Command line tools that assist applications with a variety of desktop integration tasks
    xorg-xeyes    # A follow the mouse X demo
    zoxide
    zram-generator
    zsh
)

DEVELOPMENT=(
    base-devel
    git
    linux-headers
    linux-lts-headers
    linux-zen-headers
    wev # A tool for debugging and observing input events
)

EXTRA=(
    bash-completion
    bitwarden
    bitwarden-cli
    firefox
    foot
    kitty
    obsidian
    thunar
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
)

EYE_CANDY=(
    papirus-icon-theme
    qt5-graphicaleffects
    qt5-quickcontrols2
    qt5-svg
    qt5ct
    starship
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
    "${EYE_CANDY[@]}"
    "${FUN[@]}"
)
