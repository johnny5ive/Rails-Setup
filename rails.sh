#!/bin/bash
#
# Created by Morgan Hein
# A Ruby, RoR, and gems install and config script.


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

sudo aptitude update > /dev/null

# Dependencies for Rails/NPM Dev
sudo aptitude install -y build-essential git openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config > /dev/null

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

echo -e $blue'Installing RBEnv'$reset
git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv

echo -e $blue'Updating $PATH for RBEnv'$reset
echo 'export PATH="$HOME/.rbenv/bin:.:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
echo -e $blue'Current $PATH: '$reset $PATH 
echo -e $blue'Current RBenv version:'$reset
rbenv -v
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
ruby setup.rb > /dev/null
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
