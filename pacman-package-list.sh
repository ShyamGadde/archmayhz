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

GRAPHICS_STUFF=(
    intel-gpu-tools    # Tools for development and testing of the Intel DRM driver (intel_gpu_top)
    intel-media-driver # Intel Media Driver for VAAPI — Broadwell+ iGPUs
    libva-mesa-driver
    libva-utils
    mesa             # An open-source implementation of the OpenGL specification
    onevpl-intel-gpu # runtime for Tiger Lake and newer GPUs
    vulkan-intel
)

NETWORKING=(
    gnu-netcat # GNU rewrite of netcat, the network piping application
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
    otf-font-awesome
    terminus-font
    font-manager
    fontconfig
    otf-monaspace
    ttf-cascadia-code-nerd
    ttf-dejavu
    ttf-droid
    ttf-firacode-nerd
    ttf-jetbrains-mono-nerd
    ttf-liberation
    ttf-victor-mono-nerd
)

HYPRLAND=(
    cliphist
    hyprland
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    sddm
    swaybg
    swaync # A notification center for Sway
    waybar
    wl-clipboard
    xdg-desktop-portal-gtk # For file picker as xdg-desktop-portal-hyprland doesn't implement it
    xdg-desktop-portal-hyprland
)

MULTIMEDIA=(
    gnome-sound-recorder
    gst-plugin-pipewire
    mpv
    pavucontrol
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    playerctl    # mpris command-line controller and library for spotify, vlc, audacious, bmp, xmms2, and others
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
    duf   # Disk Usage/Free Utility
    dunst # A lightweight replacement for the notification-daemons provided by most desktop environments
    expac # alpm data (pacman database) extraction utility
    eza   # A modern replacement for ls (community fork of exa)
    fd    # A simple, fast and user-friendly alternative to find
    fzf
    github-cli
    gnome-keyring # Stores passwords and encryption keys
    gpm           # General Purpose Mouse Interface (for mouse support in the tty)
    hwinfo        # Hardware detection tool used in SuSE Linux
    lazygit
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
    sysfsutils    # System Utilities Based on Sysfs
    thermald      # Thermal Daemon Service
    ufw           # Uncomplicated Firewall
    ugrep         # Ultra fast grep with interactive TUI, fuzzy search, boolean queries, hexdumps and more
    unrar         # The RAR uncompression program
    unzip
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
    jdk-openjdk
    linux-headers
    linux-lts-headers
    linux-zen-headers
    python
    python-pip
    tk  # A basic toolkit extension to Tcl (for python tkinter)
    wev # A tool for debugging and observing input events
)

EXTRA=(
    bash-completion
    bitwarden
    bitwarden-cli
    ffmpegthumbnailer # Lightweight video thumbnailer that can be used by file managers (for Thunar)
    firefox
    foot
    gvfs                     # Virtual filesystem implementation for GIO (for mounting USB drives in Thunar)
    kitty
    libxcrypt-compat # For fixing error with the sourcery extension in VSCode
    obsidian
    seahorse         # GNOME application for managing PGP keys
    tealdeer
    thunar
    thunar-archive-plugin    # Create and extract archives in Thunar
    thunar-media-tags-plugin # Adds special features for media files to the Thunar File Manager
    thunar-volman            # Automatic management of removeable devices in Thunar
    tumbler                  # D-Bus service for applications to request thumbnails (for Thunar)
    xarchiver                # GTK+ frontend for most used compression formats (for Thunar)
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
)

EYE_CANDY=(
    papirus-icon-theme
    qt5-graphicaleffects
    qt5-quickcontrols2
    qt5-svg
    qt5ct # A Qt5 configuration utility
    qt6ct # A Qt6 configuration utility
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
    "${GRAPHICS_STUFF[@]}"
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
