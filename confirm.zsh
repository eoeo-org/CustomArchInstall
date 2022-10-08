#!/bin/zsh
# Cconfirm script (zsh only)

# Fix Directory
cd /tmp/CustomArchInstaller

# Load Config
. ./setup.cfg

echo "Do you really want to run this script?"
echo "I am not responsible for anything that happens by running this."
echo "Configs:"
echo "Install Disk: $INSTALL_DISK"
echo "Boot Partition: $BOOT_PART"
echo "OS Partition: $OS_PART"
echo "Hostname: $OS_HOSTNAME"
echo "Username: $OS_USERNAME"

if read -q "REPLY?Do you want to run it? [y/N]: "; then
    bash ./install.sh
fi
