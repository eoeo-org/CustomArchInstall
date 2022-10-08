#!/bin/bash
# inside arch-chroot script
# This script should not be run as is.

# Init
echo "[chroot] Initting..."
pacman -Syyu # update mirror list
pacman -S curl vim htop git networkmanager efibootmgr sudo --noconfirm # install include package

# Set Timedate
echo "[chroot] Setting Timedate..."
TZ=$(curl "http://ip-api.com/line?fields=timezone") # get timezone
ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime # link zoneinfo
hwclock --systohc --utc # sync timedate

# Set Language
echo "[chroot] Setting Language..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen # add language
locale-gen # genelate locale
echo LANG=en_US.UTF-8 > /etc/locale.conf # set default language

# Set Keymap
echo "[chroot] Setting Keymap($OS_KEYMAP)..."
echo KEYMAP=$OS_KEYMAP > /etc/vconsole.conf # set keymap to file

# Set Hostname
echo "[chroot] Setting Hostname($OS_HOSTNAME)..."
echo $OS_HOSTNAME > /etc/hostname # set hostname to file

# Enable Network Manager
echo "[chroot] Enable NetworkManager..."
systemctl enable NetworkManager

# Edit sudoers
echo "[chroot] Edit sudoers file..."
echo 'Defaults pwfeedback
Defaults passprompt="[33;1m(sudo)[0m password for [34;1m%u[0m: "

root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL

@includedir /etc/sudoers.d' > /etc/sudoers # write sudoers file

# Add User
echo "[chroot] Add User($OS_USERNAME)..."
useradd -s /bin/bash -G wheel -m $OS_USERNAME # add user
echo "${OS_USERNAME}:test" | chpasswd # change password(testing)

# Install GUI Packages
echo "[chroot] Install GUI Packages..."
pacman -S xf86-video-{intel,amdgpu,ati,nouveau} xorg-server openbox xterm pipewire pipewire-{pulse,alsa,jack} noto-fonts noto-fonts-{cjk,emoji,extra} --noconfirm

# Install ly(from source)
echo "[chroot] Install ly..."
pacman -S libxcb xorg-xauth pam --noconfirm # install library
git clone --recurse-submodules https://github.com/fairyglade/ly /tmp/ly # clone source
cd /tmp/ly # change directory
make # build
make install installsystemd # install systemd
systemctl enable ly.service # enable ly
cd ~/ # back to directory
rm -rf /tmp/ly # remove source

# Install systemd-boot to boot
echo "[chroot] Install systemd-boot..."
if [ -e /boot/EFI ]; then
    bootctl --path=/boot remove
fi
bootctl --path=/boot install # install systemd-boot

# Generate Boot Loader Setting
echo "[chroot] Generating Boot Loader Setting..."
echo "timeout 3" > /boot/loader/loader.conf # add loader setting to file

# Generate Boot Entry For systemd-boot
echo "[chroot] Generating Boot Entry..."
echo "title Arch Linux (linux-zen)" >> /boot/loader/entries/archlinux.conf # add to entry file/1
echo "linux /vmlinuz-linux-zen" >> /boot/loader/entries/archlinux.conf # add to entry file/2
echo "initrd /initramfs-linux-zen.img" >> /boot/loader/entries/archlinux.conf # add to entry file/3
echo "initrd /intel-ucode.img" >> /boot/loader/entries/archlinux.conf # add to entry file/4
echo "initrd /amd-ucode.img" >> /boot/loader/entries/archlinux.conf # add to entry file/5
echo "options root=PARTUUID=${PARTUUID} zswap.enabled=0 rootflags=subvol=@arch rw intel_pstate=no_hwp rootfstype=btrfs" >> /boot/loader/entries/archlinux.conf # add to entry file/6
bootctl update # update boot entries

# User Setting
echo "[chroot] User Setting..."
su - $USERNAME -c 'echo "XDG_RUNTIME_DIR=/run/user/$(id -u)" >> ~/.pam_environment'
su - $USERNAME -c 'systemctl --user enable pipewire'
su - $USERNAME -c 'systemctl --user enable pipewire-pulse'

# End Of arch-chroot
echo "[chroot] arch-chroot Finished"
