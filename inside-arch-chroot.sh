#!/bin/bash
# inside arch-chroot script
# This script should not be run as is.

# Init
echo "[chroot] Initting..."
pacman -Syyu # update mirror list
pacman -S curl networkmanager efibootmgr --noconfirm # install include package

# Set Timedate
echo "[chroot] Setting Timedate..."
TZ=$(curl "http://ip-api.com/line?fields=timezone") # get timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime # link zoneinfo
hwclock --systohc --utc # sync timedate

# Set Language
echo "[chroot] Setting Language..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen # add language
locale-gen # genelate lpcale
echo LANG=en_US.UTF-8 > /etc/locale.conf # set default language

# Set Hostname
echo "[chroot] Setting Hostname..."
echo $OS_HOSTNAME > /etc/hostname

# Enable Network Manager
echo "[chroot] Enable NetworkManager..."
systemctl enable NetworkManager

# Add User
echo "[chroot] Add User..."
useradd -s /bin/bash -G wheel -m $USERNAME # add user
(
    echo "test"
) | passwd $USERNAME

# Install systemd-boot to boot
echo "[chroot] Install systemd-boot..."
bootctl --path=/boot install # install systemd-boot
echo "title Arch Linux (linux-zen)" >> /boot/loader/entries/archlinux.conf # add to entry file/1
echo "linux /vmlinuz-linux-zen" >> /boot/loader/entries/archlinux.conf # add to entry file/2
echo "initrd /initramfs-linux-zen.img" >> /boot/loader/entries/archlinux.conf # add to entry file/3
echo "options root=PARTUUID=${PARTUUID} zswap.enabled=0 rootflags=subvol=@arch rw intel_pstate=no_hwp rootfstype=btrfs" >> /boot/loader/entries/archlinux.conf # add to entry file/4
bootctl update # update systemd-boot

# End Of arch-chroot
echo "[chroot] arch-chroot Finished"
