#!/bin/bash

root_password=""

hostname=""

user_name=""
user_password=""

continent_city="" #Europe/Rome
#swap_size="16" #add swap file creation

echo "Updating system clock"
timedatectl set-ntp true

echo "Creating partition tables"
printf "n\n1\n2048\n+512M\nef00\nw\ny\n" | gdisk /dev/nvme0n1 # /efi EFI (512 MB)
printf "n\n2\n\n+100G\n8300\nw\ny\n" | gdisk /dev/nvme0n1 # / LINUX FILESYSTEM (100 GB)
printf "n\n3\n\n\n8300\nw\ny\n" | gdisk /dev/nvme0n1 # /home LINUX FILESYSTEM (remaining space)

echo "Building EFI filesystem"
yes | mkfs.fat -F32 /dev/nvme0n1p1 
yes | mkfs.ext4 /dev/nvme0n1p2
yes | mkfs.ext4 /dev/nvme0n1p3

echo "Mounting root/efi/home"
mount /dev/nvme0n1p2 /mnt

mkdir /mnt/efi
mkdir /mnt/home

mount /dev/nvme0n1p1 /mnt/efi
mount /dev/nvme0n1p3 /mnt/home

echo "Installing Arch Linux"
yes '' | pacstrap /mnt base base-devel amd-ucode networkmanager wget reflector

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Configuring new system"
arch-chroot /mnt /bin/bash <<EOF
echo "Setting system clock"
ln -fs /usr/share/zoneinfo/$continent_city /etc/localtime
hwclock --systohc --localtime

echo "Setting locales"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen

echo "Setting hostname"
echo $hostname > /etc/hostname

echo "Setting root password"
echo -en "$root_password\n$root_password" | passwd

echo "Creating new user"
useradd -m -G wheel -s /bin/bash $user_name
echo -en "$user_password\n$user_password" | passwd $user_name

echo "Generating initramfs"
sed -i 's/^HOOKS.*/HOOKS=(base udev keyboard autodetect modconf block keymap resume filesystems fsck)/' /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(amdgpu)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "Setting up systemd-boot"
bootctl --path=/efi install

mkdir -p /efi/loader/
touch /efi/loader/loader.conf
tee -a /efi/loader/loader.conf << END
default arch
timeout 1
editor 0
END

mkdir -p /efi/loader/entries/
touch /efi/loader/entries/arch.conf
tee -a /efi/loader/entries/arch.conf << END
title ArchLinux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=/dev/nvme0n1p2 vga=current ivrs_ioapic[4]=00:14.0 ivrs_ioapic[5]=00:00.2 iommu=pt idle=nomwait acpi_enforce_resources=lax scsi_mod.use_blk_mq=1 amdgpu.gpu_recovery=1 quiet rw
END

echo "Setting up Pacman hook for automatic systemd-boot updates"
mkdir -p /etc/pacman.d/hooks/
touch /etc/pacman.d/hooks/systemd-boot.hook
tee -a /etc/pacman.d/hooks/systemd-boot.hook << END
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
END

echo "Updating mirrors list"
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.BAK
reflector --latest 200 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

touch /etc/pacman.d/hooks/mirrors-update.hook
tee -a /etc/pacman.d/hooks/mirrors-update.hook << END
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c "reflector --latest 200 --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
END

echo "Enabling NetworkManager"
systemctl enable NetworkManager

echo "Enabling suspend and hibernate"
sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/g' /etc/systemd/logind.conf
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/g' /etc/systemd/logind.conf

echo "Adding user as a sudoer"
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo
EOF

umount -R /mnt
swapoff -a

echo "ArchLinux is ready. You can reboot now!"
