#!/bin/bash

# RPM-Fusion

dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# COPR

dnf -y copr enable scottames/ghostty
dnf -y copr enable yalter/niri 

# RPM packages 

NIRI_PACKAGES=(
    niri
    wofi
    dunst
    lightdm-gtk
    nautilus
    gvfs
    gvfs-smb
    blueman
    lxqt-policykit
    grim
    slurp
    ddcutil
    wl-copy
)

dnf install -y "${NIRI_PACKAGES[@]}"

RM_PACKAGES=(
    waybar
)

dnf remove -y "${RM_PACKAGES[@]}"

PACKAGES=(
    ghostty
    fastfetch
    distrobox
    btop
    libavcodec-freeworld
)

dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"

# Flatpak + Bazaar install

dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.github.kolunmi.Bazaar

# Nix Community

dnf install -y https://nix-community.github.io/nix-installers/nix/x86_64/nix-multi-user-2.24.10.rpm

# Non  root user

NON_ROOT_USER=$(logname)
USER_HOME=$(eval echo "~$NON_ROOT_USER")

# Install dotfiles

mkdir -p $USER_HOME/.config/
mv ./Dotfiles/* $USER_HOME/.config/
git clone https://github.com/DXC-0/Flatery.git "$USER_HOME/Flatery"
mkdir $USER_HOME/.icons/
mv $USER_HOME/Flatery/* "$USER_HOME/.icons/"

# Autologin

sed -i 's/^#\?\s*autologin-user=.*/autologin-user=alerion/' /etc/lightdm/lightdm.conf
sed -i 's/^#\?\s*autologin-session=.*/autologin-session=niri/' /etc/lightdm/lightdm.conf

# Services 

systemctl enable podman.socket
systemctl enable nix-daemon.service
systemctl enable lightdm.service
systemctl set-default graphical.target
