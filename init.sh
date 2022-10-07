#!/bin/bash
# Arch Linux Install (systemd-boot / openbox(xorg))
# This is UEFI, Not BIOS
# This may cause the OS to disappear if installed in the wrong place, use at your own risk.
# By Ced

# Check UEFI
if [ ! -e /sys/firmware/efi/efivars ]; then
    echo "You is not UEFI!"
    exit
fi

# Change to Install Directory
mkdir /tmp/CustomArchInstaller
if [ -e setup.cfg ]; then
    mv setup.cfg /tmp/CustomArchInstaller/
fi
cd /tmp/CustomArchInstaller

# Download Resources
echo "Downloading confirm.zsh..."
curl -fsSOL https://github.com/Zel9278/CustomArchInstall/raw/master/confirm.zsh
echo "Downloading install.sh..."
curl -fsSOL https://github.com/Zel9278/CustomArchInstall/raw/master/install.sh
echo "Downloading inside-arch-chroot.sh..."
curl -fsSOL https://github.com/Zel9278/CustomArchInstall/raw/master/inside-arch-chroot.sh
if [ ! -e setup.cfg ]; then
    echo "Downloading setup.cfg..."
    curl -fsSOL https://github.com/Zel9278/CustomArchInstall/raw/master/setup.cfg
fi

# Call Confirm Script
zsh ./confirm.zsh
