# Text color variables
und=$(tput sgr 0 1)			# Underline
bold=$(tput bold)           # Bold
red=$(tput setaf 1) 		# Red
blue=$(tput setaf 4) 		# Blue
wht=$(tput setaf 7) 		# White
reset=$(tput sgr0)          # Reset
redbold=${red}${bold}

echo -e $redbold"Updating System\n"$reset
aptitude update && aptitude safe-upgrade > /dev/null

echo -e $blue"Installing python-software-properties"$reset
aptitude install -y python-software-properties linux-headers-generic dkms linux-headers-$(uname -r)
echo -e $blue"Done.\n"$reset

add-apt-repository ppa:gnome3-team/gnome3
aptitude update

echo -e $blue"Installing lightdm, gnome-shell"$reset
aptitude install -y lightdm gnome-shell > /dev/null
echo -e $blue"Done.\n"$reset

echo -e $blue"Configuring lightdm"$reset
dpkg-reconfigure lightdm
echo -e $blue"Done.\n"$reset

echo -e $blue"Installing extra software"$reset
aptitude install -y gnome-terminal gnome-tweak-tool gnome-themes-ubuntu gedit evince file-roller gnome-utils gdebi update-manager gnome-themes gnome-themes-extras ubuntu-artwork > /dev/null
aptitude -y install virtualbox-guest-utils > /dev/null
echo -e $blue"Done.\n"$reset

echo -e $blue"Cleaning up"$reset
aptitude -y -f install > /dev/null
aptitude clean > /dev/null
echo -e $blue"Done.\n"$reset
reboot
