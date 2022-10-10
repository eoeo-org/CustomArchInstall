# Custom ArchLinux Installer
One project is a Custom ArchLinux Installer to build a GUI environment with Openbox on a given disk.\
[![My Video](http://img.youtube.com/vi/5RsMxPyUh-c/0.jpg)](https://youtu.be/5RsMxPyUh-c)

## Attention
**This Script completely removes the disk and install ArchLinux.
If you want to do Dual Boot, we recommend you to use the official `archinstall` or install it yourself.**\
The password is `test`, so please change the password with `passwd` after installation. (I have to unify this process in setup.cfg.)


## How to use
1. Download the iso from the [official ArchLinux website](https://archlinux.org/download/).
2. Burn the iso to USB or CD (for USB, use `dd` for Linux or [Rufus](https://rufus.ie/) for Windows).
3. Launch the Live environment.
4. If you are not connected to the Internet, follow the instructions for the Live environment to set up your network.
5. Run `curl -fsSL arin.eov2.com | bash`.
6. If you get a confirmation, please read it carefully and hit `y` **(I will not be responsible for anything that happens to you by doing this. )**
7. Have a cup of coffee or read a book and wait.
8. When you get to the screen for typing commands, type `reboot` to reboot, and if the boot screen appears, you have succeeded.

# How to use(modified setup.cfg)
1. Run `vim setup.cfg` (or `nano setup.cfg` or `emacs setup.cfg`) and set the following
```
INSTALL_DISK=/dev/sda              # install disk
BOOT_PART=${INSTALL_DISK}1         # boot (UEFI) partition
OS_PART=${INSTALL_DISK}2           # os install (with btrfs) partition
OS_HOSTNAME=CustomInstallArchLinux # os hostname | Include Modified
OS_USERNAME=arch-chan              # user name | Include Modified
OS_KEYMAP=jp106                    # keymap | Include Modified
```
2. Follow the instructions in `How to Use`.

## Using
Window Manager: openbox\
Login Manager: ly

## License
This repository uses the `GNU General Public License 3.0`, see [LICENSE](https://github.com/Zel9278/CustomArchInstall/blob/master/LICENSE) for details.
