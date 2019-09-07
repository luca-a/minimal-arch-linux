# Minimal Arch Linux setup - Install scripts
### Adapted to Matebook D (AMD Ryzen 5 2500U model KPL-W0X in 2018) 

[comment]: <> (Include image of the desktop here)

## Install script
* systemd-boot (with Pacman hook for automatic updates)
* Automatic login (with systemd)
* AMD microcode
* Automatic sort of mirrors list by speed, synced within the last 12 hours and filtered by HTTPS protocol (Reflector with Pacman hook)
* Hibernate (power key) + suspend (lid close)

### Requirements
* Matebook D hardware or similar

### Partitions
| Name | Type | Mountpoint |
| - | :-: | :-: |
| nvme0n1 | disk | |
| ├─nvme0n1p1 | part | /boot |
| ├─nvme0n1p2 | part |  |
| &nbsp;&nbsp;&nbsp;└─cryptoVols | crypt | |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├─Arch-swap | lvm | [SWAP] |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└─Arch-root | lvm | / |

## Post install script
* UFW (deny incoming, allow outgoing)
* TLP (default settings)
* base16-material-darker (alacritty, neovim, rofi, waybar, VS Code)
* swaywm:
   * autostart on tty1
   * waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
   * swayidle and swaylock: automatic sleep and lock
   * Alacritty terminal
   * rofi as application launcher
   * slurp and grim for screenshots
* zsh:
   * powerlevel9k theme
   * History
* GTK theme and icons: Qogir
* Other applications: git, openssh, thunar, upower, htop, nnn and a few others

## Quick start / Brief install guide
*See 'Detailed installation guide' below for the expanded version*
* Increase cowspace partition so that git can be downloaded without before chroot: `mount -o remount,size=2G /run/archiso/cowspace`
* Install git: `pacman -Sy git`
* Clone repository: `git clone https://github.com/exah-io/minimal-arch-linux.git`
* Run install script: `bash minimal-arch-linux/1_arch_install.sh`

## Detailed installation guide
1. Download and boot into the latest [Arch Linux iso](https://www.archlinux.org/download/)
2. Connect to the internet. If using wifi, you can use `wifi-menu` to connect to a network
3. Clear all existing partitions (see below: MISC - How to clear all partitions)
4. (optional) Give highest priority to the closest mirror to you on /etc/pacman.d/mirrorlist by moving it to the top
5. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/1_arch_install.sh`
6. Change the variables at the top of the file (lines 3 through 9)
   * continent_country must have the following format: Zone/SubZone . e.g. Europe/Berlin
   * run `timedatectl list-timezones` to see full list of zones and subzones   
7. Make the script executable: `chmod +x 1_arch_install.sh`
8. Run the script: `./1_arch_install.sh`
9. Reboot into Arch Linux
10. Connect to wifi with `nmtui`
10. `wget https://raw.githubusercontent.com/exah-io/minimal-arch-linux/master/2_arch_post_install.sh`
11. Make the script executable: `chmod +x 2_arch_post_install.sh`
12. Run the script: `./2_arch_post_install.sh`

## Misc guides
### How to clear all partitions
```
gdisk /dev/nvme0n1
x
z
y
y
```

### How to setup Github with SSH Key
```
git config --global user.email "github external email"
git config --global user.name "username"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
copy SSH key and add to Github (eg. nvim ~/.ssh/id_rsa.pub and copy content)
```

### How to chroot
```
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
cryptsetup luksOpen /dev/nvme0n1p2 cryptoVols
mount /dev/mapper/Arch-root /mnt
arch-chroot /mnt
```

### How to install yay
```
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
yes | makepkg -si
cd ..
rm -rf yay-bin
```

## References
* Ricing: [First rice on my super old MacBook Air!](https://www.reddit.com/r/unixporn/comments/9y9w0r/sway_first_rice_on_my_super_old_macbook_air/)
* Wallpaper: [Photo by WestBoundary Photography chris gill on Unsplash](https://unsplash.com/photos/lBL7rSRaNGs)
* Linux on MateBook doc: [GNU/Linux on MateBook D 14" AMD Ryzen 5 2500U](https://gitlab.com/cscs/linux-on-huawei-matebook-d-14-amd)