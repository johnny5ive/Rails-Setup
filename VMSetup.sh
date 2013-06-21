aptitude install -y aptitude
aptitude update && aptitude safe-upgrade
aptitude install -y python-software-properties
add-apt-repository ppa:gnome3-team/gnome3
aptitude update
aptitude install -y gnome-shell
aptitude install -y lightdm
dpkg-reconfigure lightdm
aptitude install -y gnome-terminal gnome-tweak-tool gnome-themes-ubuntu gedit evince file-roller gnome-utils gdebi update-manager gnome-themes gnome-themes-extras ubuntu-artwork
aptitude -y install virtualbox-ose-guest-utils
aptitude -y -f install
aptitude clean