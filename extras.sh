#!/bin/bash

# Determine the platform we're working with
platform=`uname -m`
if [ "$platform" == "i686" ]; then
	echo "32 Bit OS Detected"
elif [ "$platform" == "x86_64" ]; then
	echo "64 Bit OS Detected"
else
	echo "This script is only meant for x86 and x64"
	exit 0
fi

add-apt-repository "deb http://linux.dropbox.com/ubuntu maverick main" > /dev/null				

echo "* Installing Extras. Press Enter to Continue...\n"
read dummy
echo "* Installing Dropbox\n"
aptitude -y install nautilus-dropbox > /dev/null

echo "* Installing Google Chrome\n"
aptitude -y install libcurl3 xdg-utils > /dev/null
if [ "$platform" == "i686" ]; then
	wget -q https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_i386.deb
	dpkg -i google-chrome-stable_current_i386.deb
elif [ "$platform" == "x86_64" ]; then
	wget -q https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome-stable_current_amd64.deb > /dev/null
fi