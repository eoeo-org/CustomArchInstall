#!/bin/bash
# Arch Linux Install (systemd-boot / openbox(xorg))
# This is UEFI, Not BIOS
# This may cause the OS to disappear if installed in the wrong place, use at your own risk.
# By Ced

# Fix Directory
cd `dirname $0`

# Call Confirm Script
zsh ./confirm.zsh
