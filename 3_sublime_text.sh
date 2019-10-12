echo "Installing and setting sublime text"
wget https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
yes | sudo pacman -Syu sublime-text

sudo touch ~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings	
sudo tee ~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings << END
{
	"font_size": 10,
	"theme": "Adaptive.sublime-theme"
}
END
sudo touch ~/.config/sublime-text-3/Packages/User/Package Control.sublime-settings
sudo tee ~/.config/sublime-text-3/Packages/User/Package Control.sublime-settings << END
{
	"installed_packages":
	[
		"Git Conflict Resolver",
		"Package Control"
	]
}
END
