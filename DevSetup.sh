#!/bin/bash
#
# Created by Morgan Hein
# A Ruby, RoR, Node/NPM install and config script.


#Ruby version to in install and use as default
#Set this to whatever version you want (NO SPACES!)
RUBYVERSION="2.0.0-p195"

# Text color variables
und=$(tput sgr 0 1)             # Underline
bold=$(tput bold)               # Bold
red=${txtbld}$(tput setaf 1)    # Red
reset=$(tput sgr0)              # Reset

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


echo -e $red'This program will install all necessary dependencies for Ruby, RubyGems, Rails, Node.js, and NPM.\nIt also installs several gems and bundles.'$reset
echo -e $red$bold'You will be prompted for your sudo password.'$reset

# clear any previous sudo permission
sudo -k

# run inside sudo
sudo sh <<SCRIPT
sudo apt-get update
sudo apt-get install -y build-essential git openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
SCRIPT

# clear sudo to continue
sudo -k

echo -e $red'Installing dependencies completed. Dropping sudo to continue.\n'$reset

echo -e $red'Making Directories'$reset
if [ ! -d "$HOME/.rbenv" ]; then
	echo 'Creating ~/.rbenv'
    mkdir $HOME/.rbenv
fi
	
echo 'Creating .temp'
mkdir $DIR/.temp

echo -e $red'\nSetting up Git'$reset
git config --global user.email "code@morganhein.com"
git config --global user.name "Morgan Hein"
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
git config --global push.default simple

echo -e $red'\nInstalling RBEnv'$reset
git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
echo -e $red'Done\n'$reset

echo -e $red'Updating $PATH'$reset
echo 'export PATH="$HOME/.rbenv/bin:.:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
echo -e $PATH '\n'

echo -e $red'Installing RBEnv ruby-build plugin'$reset
mkdir -p ~/.rbenv/plugins
git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
echo -e $red'Done\n'$reset

echo -e $red'Installing Ruby\n'$reset
$HOME/.rbenv/bin/rbenv install --verbose $RUBYVERSION
echo -e $red'Rehashing rbenv'$reset
$HOME/.rbenv/bin/rbenv rehash
echo -e $red'Done\n'$reset

echo -e $red'Setting up global Ruby version.'$reset
$HOME/.rbenv/bin/rbenv global $RUBYVERSION
ruby -v

cd $DIR/.temp

echo -e $red'\nInstalling RubyGems'$reset
git clone https://github.com/rubygems/rubygems.git
cd rubygems
ruby setup.rb
echo -e $red'Done'$reset

echo -e $red'\nSetting up .gemrc file.\n'$bold'By default this .gemrc does not download docs for gems.'$reset
mv $DIR/.gemrc $HOME/.gemrc
echo -e $red'Done'$reset

echo -e $red'\nInstalling Rails & other gems'$reset
gem install rails heroku foreman spork guard-spork guard bundle
echo -e $red'Done\n\n'$reset

echo -e $red'\nInstalling Node.js'$reset
cd $DIR/.temp
git clone https://github.com/joyent/node.git
cd node

./configure
make
sudo make install

node -v
echo -e $red'Done\n\n'$reset

echo -e $red'\nInstalling NPM'$reset
cd $DIR/.temp
curl http://npmjs.org/install.sh | sudo sh
echo -e $red'Done\n\n'$reset

echo -e $red'\nInstalling Yeoman and gems'$reset
gem update --system
npm install -g yo compass grunt-cli bower generator-angular

echo -e $red$bold'Finished. Files still exist in '$DIR'/.temp. Remove them if you wish!'$reset
echo -e $red$bold'A restart may be required for all paths to be found, or you can type: '%reset'source ~/.bash_profile'$red$bold' to begin working now.'$reset
cd $HOME
exec $SHELL
