#!/bin/bash
# Minimal Ubuntu system installation script.
#
# This script is setup to install a minimal GNOME setup with very few extras.
# It will also install several tools that are used for Android ROM/Kernel development.
# Packages to install gathered from CyanogenMOD Wiki and Google documentation for 
# building CM/AOSP ROMs.
#
# This script is based on:
# Minimal Desktop for Ubuntu 10.10.2 "Attobuntu Update 2" by the Minimal Desktop Team
# Version 10.10.2-2011.01.18
# This script is licensed under GPL 3 (http://www.gnu.org/licenses/gpl-3.0.txt)
# http://ubuntu-minimal-desktop.blogspot.com/

if [ $UID -ne 0 ]; then
	sudo $0
	exit 0
else

	echo -e "Welcome to the Minimal Ubuntu install script.\nPress ENTER to continue."
	read dummy

	echo "* Preparing the installation..."

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
	
	# Required for add-apt-repository
	aptitude -y install python-software-properties > /dev/null
	
	sed -i -e '/deb cdrom:/d' /etc/apt/sources.list > /dev/null
	sed -i -e "s/# deb/deb/g" /etc/apt/sources.list > /dev/null
	
	# Import keys
	apt-key adv --keyserver keyserver.ubuntu.com --recv 3E5C1192 > /dev/null
	apt-key adv --keyserver pgp.mit.edu --recv-keys FC918B335044912E > /dev/null
	
	# Add Repositories for sun-java6-jdk, sun-java5-jdk, and Dropbox
	add-apt-repository ppa:sun-java-community-team/sun-java6 > /dev/null
	add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ jaunty multiverse" > /dev/null
	add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ jaunty-updates multiverse" > /dev/null
	add-apt-repository "deb http://linux.dropbox.com/ubuntu maverick main" > /dev/null
	
	# Update available packages
	echo "* Updating the system. Press Enter to Continue..."
	read dummy
	aptitude update > /dev/null
	aptitude -y safe-upgrade > /dev/null
	
	# Start installing stuff
	echo "* Installing GNOME and other essentials. Press Enter to Continue..."
	read dummy
	aptitude -y install gdm gnome-core gnome-themes-ubuntu > /dev/null
	echo "* Installing some important software. Press Enter to Continue..."
	read dummy
	aptitude -y install file-roller gcalctool gdebi gnome-utils update-manager evince bluefish > /dev/null
	echo "* Installing Google Chrome. Press Enter to Continue..."
	read dummy
	aptitude -y install libcurl3 xdg-utils > /dev/null
	if [ "$platform" == "i686" ]; then
		wget -q https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_i386.deb
		dpkg -i google-chrome-stable_current_i386.deb
	elif [ "$platform" == "x86_64" ]; then
		wget -q https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		dpkg -i google-chrome-stable_current_amd64.deb > /dev/null
	fi
	echo "* Installing extra themes. Press Enter to Continue..."
	read dummy
	aptitude -y install gnome-themes gnome-themes-extras ubuntu-artwork > /dev/null
	echo "* Installing packages required for Android Development. Press Enter to Continue..."
	read dummy
	if [ "$platform" == "i686" ]; then
		aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6 libc6-dev x11proto-core-dev libx11-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev libreadline5-dev pngcrush schedtool > /dev/null
	elif [ "$platform" == "x86_64" ]; then
		aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev pngcrush schedtool gcc-multilib g++-multilib libc6-i386 libc6-dev-i386 > /dev/null
	fi
	
	# Install Java JDKs seperately as they require interaction.
	echo "* Installing Sun Java. Press Enter to Continue..."
	read dummy
	aptitude -y install sun-java6-jdk sun-java5-jdk
	update-java-alternatives -s java-1.5.0-sun > /dev/null
	
	# Get the repo tool to sync Android source trees
	echo "* Getting some useful tools for ROM/Kernel building. Press Enter to Continue..."
	read dummy
	wget -q -O /usr/bin/repo http://android.git.kernel.org/repo
	chmod +x /usr/bin/repo

	# Get the latest toolchain/cross compiler compatible with GCC 4.4
	wget -q wget http://www.codesourcery.com/sgpp/lite/arm/portal/package6488/public/arm-none-linux-gnueabi/arm-2010q1-202-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
	tar -xf arm-2010q1-202-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
	mkdir /opt/toolchains
	mv arm-2010q1 /opt/toolchains/
	
	# Get the Android SDK and NDK
	wget -q http://dl.google.com/android/android-sdk_r10-linux_x86.tgz
	wget -q http://dl.google.com/android/ndk/android-ndk-r5b-linux-x86.tar.bz2
	tar -xf android-sdk_r10-linux_x86.tgz
	tar -xf android-ndk-r5b-linux-x86.tar.bz2
	mv android-ndk-r5b android-ndk
	mv android-sdk-linux_x86 android-sdk
	chown -R 1000:1000 android-ndk
	chown -R 1000:1000 android-sdk
	echo "export PATH=\$PATH:~/android-sdk/tools:~/android-sdk/platform-tools" >> ~/.bashrc
	
	# Get apktool
	wget -q http://android-apktool.googlecode.com/files/apktool1.3.2.tar.bz2
	wget -q http://android-apktool.googlecode.com/files/apktool-install-linux-2.2_r01-1.tar.bz2
	tar -xf apktool1.3.2.tar.bz2
	tar -xf apktool-install-linux-2.2_r01-1.tar.bz2
	mv apktool.jar /usr/local/bin/
	mv aapt /usr/local/bin/
	mv apktool /usr/local/bin/
	
	echo "* Installing Dropbox. Press Enter to Continue..."
	read dummy
	aptitude -y install nautilus-dropbox > /dev/null
	echo "* Installing VirtualBox Guest Additions. Press Enter to Continue..."
	read dummy
	aptitude -y install virtualbox-ose-guest-utils > /dev/null

	# Finish up
	echo "* Performing some clean-up. Press Enter to Continue..."
	read dummy
	aptitude -y -f install > /dev/null
	aptitude clean > /dev/null

	# All done, time to restart
	echo -e "Congratulations! A minimal Ubuntu system has been installed.\n\nA reboot is required to use your new system,\nso please press Enter one more time to restart."
	read dummy

	reboot

fi

exit 0
