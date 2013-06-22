#!/bin/bash
#

#	Determine the platform we're working with
platform=`uname -m`
if [ "$platform" == "i686" ]; then
	echo "32 Bit OS Detected"
elif [ "$platform" == "x86_64" ]; then
	echo "64 Bit OS Detected"
else
	echo "This script is only meant for x86 and x64"
	exit 0
fi
	
echo "* Installing packages required for Android Development. Press Enter to Continue..."
read dummy
if [ "$platform" == "i686" ]; then
	aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6 libc6-dev x11proto-core-dev libx11-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev libreadline5-dev pngcrush schedtool > /dev/null
elif [ "$platform" == "x86_64" ]; then
	aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev pngcrush schedtool gcc-multilib g++-multilib libc6-i386 libc6-dev-i386 > /dev/null
fi

# Get the repo tool to sync Android source trees
echo "* Getting some useful tools for ROM/Kernel building. Press Enter to Continue..."
read dummy
wget -q -O /usr/bin/repo http://android.git.kernel.org/repo
chmod +x /usr/bin/repo

# Get the latest toolchain/cross compiler compatible with GCC 4.4
# wget -q wget http://www.codesourcery.com/sgpp/lite/arm/portal/package6488/public/arm-none-linux-gnueabi/arm-2010q1-202-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
# tar -xf arm-2010q1-202-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
# mkdir /opt/toolchains
# mv arm-2010q1 /opt/toolchains/

# Get the Android SDK and NDK
wget -q http://dl.google.com/android/android-sdk_r22.0.1-linux.tgz
# wget -q http://dl.google.com/android/ndk/android-ndk-r5b-linux-x86.tar.bz2
tar -xf android-sdk_r22.0.1-linux.tgz
# tar -xf android-ndk-r5b-linux-x86.tar.bz2
# mv android-ndk-r5b android-ndk
mv android-sdk-linux_x86 android-sdk
# chown -R 1000:1000 android-ndk
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