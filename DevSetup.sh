#!/bin/bash
#
# Created by Morgan Hein
# A Ruby, RoR, Node/NPM install and config script.


#Ruby version to install and use as default
#Set this to whatever version you want (NO SPACES!)
RUBYVERSION="2.0.0-p195"

# Text color variables
und=$(tput sgr 0 1)			# Underline
bold=$(tput bold)           # Bold
red=$(tput setaf 1) 		# Red
blue=$(tput setaf 4) 		# Blue
wht=$(tput setaf 7) 		# White
reset=$(tput sgr0)          # Reset
redbold=${red}${bold}

# Determine the platform we're working with
platform=`uname -m`
if [ "$platform" == "i686" ]; then
	echo "32 Bit OS Detected"
elif [ "$platform" == "x86_64" ]; then
	echo "64 Bit OS Detected"
else
	echo $redbold"This script is only meant for x86 and x64!"
	exit 0
fi

# Find the location that this script is being run from.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Determine the platform we're working with

echo -e $blue'This script will install all necessary dependencies for Ruby, RubyGems, Rails, Node.js, and NPM.\nIt also installs several gems and bundles.'$reset
echo -e $redbold'You may be prompted for your sudo password several times.\n'$reset
echo -e $red'Press ENTER to continue.'
read null

# clear any previous sudo permission
sudo -k

echo -e $blu'Installing dependencies'

# run inside sudo
sudo sh <<SCRIPT

platform=`uname -m`

# Required for add-apt-repository
aptitude -y install python-software-properties > /dev/null

# Import keys
apt-key adv --keyserver keyserver.ubuntu.com --recv 3E5C1192 > /dev/null
apt-key adv --keyserver pgp.mit.edu --recv-keys FC918B335044912E > /dev/null

# Add Repositories for sun-java6-jdk, sun-java5-jdk, and Dropbox
add-apt-repository ppa:sun-java-community-team/sun-java6 > /dev/null
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ raring multiverse" > /dev/null
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ raring-updates multiverse" > /dev/null
add-apt-repository "deb http://linux.dropbox.com/ubuntu raring main" > /dev/null

sudo aptitude update > /dev/null

# Dependencies for Rails/NPM Dev
sudo aptitude install -y build-essential git openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config > /dev/null

# Dependencies for Chrome
sudo aptitude install -y libcurl3 xdg-utils > /dev/null

# Dependencies for Android Dev
if [ "$platform" == "i686" ]; then
	aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6 libc6-dev x11proto-core-dev libx11-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev libreadline5-dev pngcrush schedtool > /dev/null
elif [ "$platform" == "x86_64" ]; then
	aptitude -y install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools libncurses5-dev pngcrush schedtool gcc-multilib g++-multilib libc6-i386 libc6-dev-i386 > /dev/null
fi
SCRIPT

# clear sudo to continue
sudo -k

echo -e $blue'Installing dependencies completed. Dropping sudo to continue.\n'$reset

echo -e $blue'Making Directories'$reset
if [ ! -d "$HOME/.rbenv" ]; then
	echo 'Creating ~/.rbenv'
    mkdir $HOME/.rbenv
fi
	
echo 'Creating .temp\n'
mkdir $DIR/.temp

echo -

echo -e $blue'Installing Node.js'$reset
cd $DIR/.temp
git clone https://github.com/joyent/node.git
cd node

./configure
make
sudo make install

echo -e $blue'Current Node Version: '$reset
node -v
echo -e $blue'Done\n'$reset

echo -e $blue'Installing NPM'$reset
cd $DIR/.temp
curl http://npmjs.org/install.sh | sudo sh
echo -e $blue'Current NPM Version: '$reset
npm -v
echo -e $blue'Done\n'$reset

echo -e $blue'Installing Yeoman and gems'$reset
gem update --system
npm install -g yo compass grunt-cli bower generator-angular
echo -e $blue'Done\n'$reset

echo -e $blue"Installing Sun Java"$reset
aptitude -y install sun-java6-jdk sun-java5-jdk
update-java-alternatives -s java-1.5.0-sun > /dev/null

#dropping sudo again
sudo -k

echo -e $blue$bold'Setting Up Android'$reset
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

echo -e $blue'Installing RBEnv'$reset
git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo -e $blue'Current RBenv version:'$reset
rbenv -v
echo -e $blue'Done\n'$reset

echo -e $blue'Updating $PATH'$reset
echo 'export PATH="$HOME/.rbenv/bin:.:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
echo -e $blue'Current $PATH: '$reset $PATH 
echo -e $blue'Done\n'$reset

echo -e $blue'Installing RBEnv ruby-build plugin'$reset
mkdir -p ~/.rbenv/plugins
git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo -e $blue'Done\n'$reset

echo -e $blue'Installing Ruby'$bold' (this may take a while)'$reset
$HOME/.rbenv/bin/rbenv install $RUBYVERSION
echo -e $blue'Current Ruby Version: '$reset
ruby -v
echo -e $blue'Done\n'$reset

echo -e $blue'Setting up global Ruby version'$reset
$HOME/.rbenv/bin/rbenv global $RUBYVERSION
ruby -v
echo -e $blue'Done\n'$reset

echo -e $blue'Rehashing rbenv'$reset
$HOME/.rbenv/bin/rbenv rehash
echo -e $blue'Done\n'$reset

cd $DIR/.temp

echo -e $blue'Installing RubyGems'$reset
git clone https://github.com/rubygems/rubygems.git
cd rubygems
ruby setup.rb
echo -e $blue'Current RubyGems Version: '$reset
gem -v
echo -e $blue'Done\n'$reset

echo -e $blue'Setting up .gemrc file.\n'$bold'By default this .gemrc does not download docs for gems'$reset
mv $DIR/.gemrc $HOME/.gemrc
echo -e $blue'Done\n'$reset

echo -e $blue'Installing Rails & other gems'$reset
gem install rails heroku foreman spork guard-spork guard bundle
echo -e $blue'Current Rails Version: '$reset
rails -v
echo -e $blue'Done\n'$reset

echo -e $blue'Setting up Git'$reset
echo -e $blue'Copy/paste the following with your information:'$reset
echo 'git config --global user.email "code@morganhein.com"'
echo 'git config --global user.name "Morgan Hein"'
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
git config --global push.default simple
echo -e $blue'Done\n'$reset

echo -e $blue$bold'Finished. Files still exist in '$DIR'/.temp. Remove them if you wish!\n'$reset
echo -e $blue$bold'A restart may be required for all paths to be found, or you can type: '%reset'source ~/.bash_profile'$blue$bold' to begin working now.'$reset
cd $HOME
exec $SHELL