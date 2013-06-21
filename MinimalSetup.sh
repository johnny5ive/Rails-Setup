aptitude install -y aptitude
aptitude update && aptitude upgrade
aptitude install -y python-software-properties
add-apt-repository ppa:gnome3-team/gnome3
aptitude update
aptitude install -y gnome-shell
aptitude install -y lightdm
dpkg-reconfigure lightdm
aptitude install -y gnome-terminal
aptitude install -y gnome-tweak-tool
aptitude install -y gnome-themes-ubuntu gedit evince 