#!/bin/bash
# inside arch-chroot script
# This script should not be run as is.

pacman -Syyu # update mirror list
echo $HOSTNAME > /etc/hostname # set hostname


