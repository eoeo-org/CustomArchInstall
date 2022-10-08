#!/bin/bash
# install main script

# Fix Directory
cd /tmp/CustomArchInstaller

# Load Config
echo "[installer] Load Config..."
. ./setup.cfg

# Partition Split (gdisk)
echo "[installer] Partition Split With gdisk..."
(
    echo o # delete disk
    echo y # confirm
    echo n # uefi partition
    echo 
    echo 
    echo +512MB # size (last sector)
    echo ef00 # set type to "EFI system partition"
    echo n # os partition
    echo 
    echo 
    echo 
    echo 
    echo p # list partition
    echo w # write
    echo y # confirm
) | gdisk $INSTALL_DISK

# UEFI Partition Setup
echo "[installer] Format ${BOOT_PART} to fat32..."
mkfs.fat -f -F32 $BOOT_PART # format to fat32

# BTRFS SetUp
echo "[installer] Format ${OS_PART} to btrfs and setup partition..."
mkfs.btrfs -f $OS_PART # format to btrfs
mount $OS_PART /mnt # mount btrfs root
btrfs subvolume create /mnt/@arch # create subvolume
umount /mnt # unmount btrfs root

# Mount Partitions
echo "[installer] Mount Partitions..."
mount $OS_PART /mnt -o subvol=@arch # mount os partition
mkdir /mnt/boot # make boot directory
mount $BOOT_PART /mnt/boot # mount boot (uefi) partition

# Install ArchLinux
echo "[installer] Install ArchLinux..."
curl -s "https://archlinux.org/mirrorlist/?country=AU&country=JP&protocol=http&protocol=https&ip_version=4" | sed -e 's/^#Server/Server/' -e '/^#/d' > /etc/pacman.d/mirrorlist # set good pacman server
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf # set pallael download
echo "[multilib]" >> /etc/pacman.conf # set multilib/1
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf # set multilib/2
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware btrfs-progs # install to os partition
genfstab -U /mnt >> /mnt/etc/fstab # set fstab
echo $HOSTNAME > /mnt/etc/hostname # set hostname

# set env
echo "[installer] Export Environments..."
export $(blkid -o export $OS_PART | grep PARTUUID=) # export PARTUUID
export OS_HOSTNAME # export hostname
export OS_USERNAME # export username
export OS_KEYMAP # export keymap

# Running arch-chroot
echo "[installer] Running arch-chroot..."
arch-chroot /mnt /bin/bash -c "$(cat ./inside-arch-chroot.sh)" # running arch-chroot

# End Of Install
umount /mnt/boot # unmount boot
umount /mnt # unmount os
echo "[installer] Install Finished"
