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
    socat # Multipurpose relay (SOcket CAT)
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
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    sddm
    swaybg
    waybar
    wl-clipboard
    xdg-desktop-portal-gtk # For file picker as xdg-desktop-portal-hyprland doesn't implement it
)

GNOME=(
    evince      # Document viewer (thumbnails for .pdf files in file managers)
    file-roller # Archive manager for GNOME
    gnome
    gnome-calculator
    gnome-characters # Unicode character map for GNOME
    gnome-clocks
    gnome-keyring # Stores passwords and encryption keys
    gnome-sound-recorder
    loupe    # A simple image viewer for GNOME
    seahorse # GNOME application for managing PGP keys
)

MULTIMEDIA=(
    copyq # Clipboard manager with advanced features
    grim  # Screenshot utility for Wayland
    gst-plugin-pipewire
    mpv
    pavucontrol
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    playerctl    # mpris command-line controller and library for spotify, vlc, audacious, bmp, xmms2, and others
    slurp        # Select a region in a Wayland compositor
    sof-firmware # Sound Open Firmware
    wireplumber
    wl-clipboard
)

UTILITIES=(
    acpi      # Client for battery, power, and thermal readings
    acpi_call # A linux kernel module that enables calls to ACPI methods through /proc/acpi/call
    acpid     # Advanced Configuration and Power Interface event daemon
    bat
    brightnessctl
    btop
    duf   # Disk Usage/Free Utility
    dust  # A more intuitive version of du in rust
    expac # alpm data (pacman database) extraction utility
    eza   # A modern replacement for ls (community fork of exa)
    fd    # A simple, fast and user-friendly alternative to find
    fzf
    github-cli
    gpm    # General Purpose Mouse Interface (for mouse support in the tty)
    hwinfo # Hardware detection tool used in SuSE Linux
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
    powertop  # Linux tool to find out what is using power on a laptop
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
    docker
    git
    jdk-openjdk
    jq
    linux-headers
    linux-lts-headers
    linux-zen-headers
    python
    python-pip
    tk # A basic toolkit extension to Tcl (for python tkinter)
    tmux
    wev # A tool for debugging and observing input events
)

VIRTUALIZATION=(
    bridge-utils # Utilities for configuring the Linux ethernet bridge
    dmidecode    # Desktop Management Interface table related utilities
    dnsmasq      # Lightweight, easy to configure DNS forwarder and DHCP server
    edk2-ovmf    # Firmware for Virtual Machines (x86_64, i686)
    iptables-nft # Linux kernel packet control tool (using nft interface)
    libguestfs   # Access and modify virtual machine disk images
    nftables     # Netfilter tables userspace tools
    qemu         # A generic and open source machine emulator and virtualizer
    swtpm        # Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface
    vde2         # Virtual Distributed Ethernet for emulators like qemu
    virt-manager # Desktop user interface for managing virtual machines
    virt-viewer  # A lightweight interface for interacting with the graphical display of virtualized guest OS.
)

EXTRA=(
    bash-completion
    bitwarden
    bitwarden-cli
    ffmpegthumbnailer # Lightweight video thumbnailer that can be used by file managers
    firefox
    foot
    freetype2              # Font rasterization library (thumbnails for fonts in file managers)
    gnome-epub-thumbnailer # Thumbnailer for EPUB files (.epub and .mobi)
    gst-libav              # Multimedia graph framework - libav plugin (video thumbnails for file managers)
    gst-plugins-ugly       # Multimedia graph framework - ugly plugins (video thumbnails for file managers)
    kitty
    libgsf           # Extensible I/O abstraction library for dealing with structured file formats (.odf thumbnails in file managers)
    libxcrypt-compat # For fixing error with the sourcery extension in VSCode
    nautlius         # GNOME Files file manager
    obsidian
    poppler-glib # Poppler glib bindings (thumbnails for .pdf files in file managers)
    tealdeer
    totem              # Movie player for the GNOME desktop based on GStreamer (thumbnails video files and tagged audio files in GNOME Files and Caja only)
    tumbler            # Thumbnail service implementing the thumbnail management D-Bus specification (Image file thumbnails in file managers)
    webp-pixbuf-loader # WebM GDK Pixbuf Loader library (thumbnails for .webp files in file managers)
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
    "${GNOME[@]}"
    "${MULTIMEDIA[@]}"
    "${UTILITIES[@]}"
    "${DEVELOPMENT[@]}"
    "${VIRTUALIZATION[@]}"
    "${EXTRA[@]}"
    "${EYE_CANDY[@]}"
    "${FUN[@]}"
)
