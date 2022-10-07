#!/bin/bash
# Arch Linux Install (systemd-boot / openbox(xorg))
# This is UEFI, Not BIOS
# This may cause the OS to disappear if installed in the wrong place, use at your own risk.
# By Ced

# Change to Install Directory
mkdir /tmp/CustomArchInstaller
if [ -e setup.cfg ]; then
    mv setup.cfg /tmp/CustomArchInstaller/
fi
cd /tmp/CustomArchInstaller

# Download Resources
echo "Downloading confirm.zsh..."
wget https://github.com/Zel9278/CustomArchInstall/raw/master/confirm.zsh
echo "Downloading install.sh..."
wget https://github.com/Zel9278/CustomArchInstall/raw/master/install.sh
if [ ! -e setup.cfg ]; then
    echo "Downloading setup.cfg..."
    wget https://github.com/Zel9278/CustomArchInstall/raw/master/setup.cfg
fi
# Call Confirm Script
zsh ./confirm.zsh
