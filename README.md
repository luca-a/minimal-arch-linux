# Minimal Arch Linux setup - Install scripts
Adapted to Matebook D (AMD Ryzen 5 2500U model KPL-W0X in 2018) 

[comment]: <> (Include image of the desktop here)

## Install script
<<<<<<< HEAD
* systemd-boot (with Pacman hook for automatic updates)
* Automatic login (with systemd)
* AMD microcode
* Automatic sort of mirrors list by speed, synced within the last 12 hours and filtered by HTTPS protocol (Reflector with Pacman hook)
* Hibernate (power key) + suspend (lid close)

### Requirements
* Matebook D KPL-W0X hardware or similar
=======

- LVM on LUKS
- LUKS2
- systemd-boot (with Pacman hook for automatic updates)
- Automatic login (with systemd)
- SSD Periodic TRIM
- Intel microcode
- Standard Kernel + LTS kernel as fallback
- AppArmor
- Hibernate (power key) + suspend (lid close)

### Requirements

- UEFI mode
- NVMe SSD
- TRIM compatible SSD
- Intel CPU (recommended: Skylake or newer)
>>>>>>> f7556111b1cae7185280e8ded74c40a530298221

### Partitions
| Name | Type | Mountpoint |
| - | :-: | :-: |
| nvme0n1 | disk | |
| ├─nvme0n1p1 | part | /boot |
| ├─nvme0n1p2 | part | / |
| ├─nvme0n1p3 | part | /home |

## Post install script
<<<<<<< HEAD
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
   * oh-my-zsh
* GTK theme and icons: Qogir
* Other applications: sublime-text, chromium, git, openssh, thunar, upower, htop, nnn and a few others
=======

- Sway (2_sway.sh), Gnome (2_gnome.sh) and KDE Plasma (2_plasma.sh) support
  - Gnome and KDE have very basic support
- UFW (deny incoming, allow outgoing)
- Firejail (with AppArmor integration)
- Horizon Dark color scheme (alacritty, neovim, rofi, waybar, VS Code)
- swaywm:
  - autostart on tty1
  - waybar: onclick pavucontrol (volume control) and nmtui (ncli network manager)
  - swayidle and swaylock: automatic sleep and lock
  - Alacritty terminal
  - rofi as application launcher
  - slurp and grim for screenshots
- zsh:
  - powerlevel10k theme
  - oh-my-zsh
- neovim
- GTK theme and icons: Qogir
- Other applications: firefox, keepassxc, git, openssh, vim, thunar (with USB automonting), Node.js LTS, tumbler, evince, thunderbird, upower, htop, VS code oss, nnn and a few others
>>>>>>> f7556111b1cae7185280e8ded74c40a530298221

## Quick start / Brief install guide
*See 'Detailed installation guide' below for the expanded version*
* Increase cowspace partition so that git can be downloaded without before chroot: `mount -o remount,size=2G /run/archiso/cowspace`
* Install git: `pacman -Sy git`
* Clone repository: `git clone https://github.com/luca-a/minimal-arch-linux.git`
* Run install script: `bash minimal-arch-linux/1_arch_install.sh`

## Detailed installation guide

1. Download and boot into the latest [Arch Linux iso](https://www.archlinux.org/download/)
2. Connect to the internet. If using wifi, you can use `wifi-menu` to connect to a network
3. Clear all existing partitions (see below: MISC - How to clear all partitions)
4. (optional) Give highest priority to the closest mirror to you on /etc/pacman.d/mirrorlist by moving it to the top
5. `wget https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/1_arch_install.sh`
6. Change the variables at the top of the file (lines 3 through 9)
   - continent_country must have the following format: Zone/SubZone . e.g. Europe/Berlin
   - run `timedatectl list-timezones` to see full list of zones and subzones
7. Make the script executable: `chmod +x 1_arch_install.sh`
8. Run the script: `./1_arch_install.sh`
9. Reboot into Arch Linux
10. Connect to wifi with `nmtui`
11. `wget https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/2_arch_post_install.sh`
12. Make the script executable: `chmod +x 2_arch_post_install.sh`
13. Run the script: `./2_arch_post_install.sh`

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
git config --global user.email "Github external email"
git config --global user.name "Github username"
ssh-keygen -t rsa -b 4096 -C "Github email"
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

<<<<<<< HEAD
## References
* Ricing: [First rice on my super old MacBook Air!](https://www.reddit.com/r/unixporn/comments/9y9w0r/sway_first_rice_on_my_super_old_macbook_air/)
* Wallpaper: [Photo by WestBoundary Photography chris gill on Unsplash](https://unsplash.com/photos/lBL7rSRaNGs)
* Linux on MateBook: [GNU/Linux on MateBook D 14" AMD Ryzen 5 2500U](https://gitlab.com/cscs/linux-on-huawei-matebook-d-14-amd)
=======
### Recommended Gnome extensions

- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [Dynamic Panel Transparency](https://extensions.gnome.org/extension/1011/dynamic-panel-transparency/)

### TODO

- [Change GTK theme colors to match Horizon's](https://www.reddit.com/r/unixporn/comments/4lp6fn/matching_gtk_theme_for_base16flat_theme/)
- [Improve](https://www.reddit.com/r/swaywm/comments/bkzeo7/font_rendering_really_bad_and_rough_in_gtk3/?ref=readnext) [font](https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/) [rendering](https://aur-dev.archlinux.org/packages/fontconfig-enhanced-defaults/) [with](https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671) [this](https://wiki.archlinux.org/index.php/Font_configuration#Incorrect_hinting_in_GTK_applications) [or this](https://www.reddit.com/r/archlinux/comments/9ujhbc/how_to_get_windows_like_font_rendering/)
- [Support secure boot](https://wiki.archlinux.org/index.php/Secure_Boot)
- Waybar: add battery discharge rate. Use [this config](https://gitlab.com/krathalan/waybar-modules/raw/3a652315f537ac957c37f08e55b5184da2b36cbd/mywaybar.jpg) as reference: [snippets](https://gitlab.com/snippets/1880686) and [modules](https://gitlab.com/krathalan/waybar-modules)
- Use [swaylock-blur](https://github.com/cjbassi/swaylock-blur)
- Add gestures to switch workspaces: [example](https://www.reddit.com/r/unixporn/comments/bd0l15/sway_real_world_student_workflow/ekv1ird?utm_source=share&utm_medium=web2x)
>>>>>>> f7556111b1cae7185280e8ded74c40a530298221
