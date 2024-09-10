#!/usr/bin/env bash

AUR_PACKAGES=(
    #iwgtk # GUI for iwctl
    1password
    anki-bin
    auto-cpufreq # Automatic CPU speed & power optimizer for Linux
    btrfs-assistant
    carbonyl # Chromium based browser built to run in a terminal
    catppuccin-cursors-mocha
    catppuccin-gtk-theme-mocha
    code-nautilus-git
    docker-desktop
    evremap-git      # A keyboard input remapper for Linux/Wayland systems
    find-the-command # Advanced command-not-found hook
    fontpreview
    gitkraken
    google-chrome
    hyprpicker # A wlroots-compatible Wayland color picker that does not suck.
    jetbrains-toolbox
    lazydocker-bin
    lf-bin
    microsoft-edge-stable-bin
    nautilus-hide              # A simple Nautilus extension that adds "Hide" and "Unhide" to Nautilus right-click menu
    nautilus-open-any-terminal # A simple Nautilus extension that adds "Open in terminal" to Nautilus right-click menu
    nwg-drawer-bin
    onlyoffice-bin
    otf-monocraft
    papirus-folders-catppuccin-git
    pfetch-rs-bin
    reflector-simple
    selectdefaultapplication-git
    slack-desktop-wayland
    snapd
    snapper-support
    swaync # A notification center for Sway
    ttf-recursive
    tuned # Daemon that performs monitoring and adaptive configuration of devices in the system (kvm/qemu)
    visual-studio-code-bin
    waybar-module-pacman-updates-git
    waypaper-git
    wl-clip-persist
    zoom
    zotero-bin
)

export AUR_PACKAGES

# vim: ft=sh ts=4 sts=4 sw=4 et
