#!/bin/bash

echo "Installing common packages"
yes | sudo pacman -S linux-headers dkms xorg-server-xwayland

echo "Installing and configuring UFW"
yes | sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Installing and enabling TLP"
yes | sudo pacman -S tlp tlp-rdw
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl start tlp.service
sudo systemctl start tlp-sleep.service
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

sudo sed -i 's/^USB_BLACKLIST_BTUSB.*/USB_BLACKLIST_BTUSB=1/' /etc/default/tlp
sudo tlp start

echo "Installing bluez and enabling bluetooth"
yes | sudo pacman -S bluez bluez-utils
sudo systemctl enable bluetooth.service
#To avoid bluetooth mouse polling rate cap to 20hz 
sudo echo 6 > /sys/kernel/debug/bluetooth/hci0/conn_min_interval

echo "Installing common applications"
echo -en "1\nyes" | sudo pacman -S chromium git openssh links upower htop

echo "Installing fonts"
yes | sudo pacman -S ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack ttf-fira-code noto-fonts gsfonts powerline-fonts

echo "Installing and setting zsh, oh-my-zsh and powerlevel9k"
yes | sudo pacman -S zsh zsh-theme-powerlevel9k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/bhilburn/powerlevel9k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel9k
sed -i 's/robbyrussell/powerlevel9k\/powerlevel9k/g' "$HOME"/.zshrc
{ echo 'POWERLEVEL9K_DISABLE_RPROMPT=true'; echo 'POWERLEVEL9K_PROMPT_ON_NEWLINE=true';  echo 'POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶ "'; echo 'POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)'; } >> "$HOME"/.zshrc

echo "Installing theme dependencies"
yes | sudo pacman -S gtk-engine-murrine gtk-engines

echo "Setting up Qogir (GTK) theme"
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme || exit
sudo mkdir -p /usr/share/themes
sudo ./install.sh -d /usr/share/themes
cd ..
rm -rf Qogir-theme

echo "Setting up Qogir icons"
git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd Qogir-icon-theme || exit
sudo mkdir -p /usr/share/icons
sudo ./install.sh -d /usr/share/icons
cd ..
rm -rf Qogir-icon-theme

echo "Blacklisting matebook unused modules"
sudo touch /etc/modprobe.d/blacklist-matebook.conf
sudo tee /etc/modprobe.d/blacklist-matebook.conf << END
blacklist tpm
blacklist tpm_crb
blacklist tpm_tis
blacklist tpm_tis_core
blacklist sp5100_tco
blacklist psmouse
END

echo "Blacklisting optional modules"
sudo touch /etc/modprobe.d/blacklist-optional.conf
sudo tee /etc/modprobe.d/blacklist-optional.conf << END
blacklist joydev
blacklist kvm
END

sudo mkinitcpio -p linux

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system
