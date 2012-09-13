#!/bin/bash
#Set this to whatever version you want (NO SPACES!)
RUBYVERSION="1.9.3-p194"

# Text color variables
und=$(tput sgr 0 1)          # Underline
bold=$(tput bold)             # Bold
red=${txtbld}$(tput setaf 1)    # Red
reset=$(tput sgr0)              # Reset


echo -e $red'This program will install all necessary dependencies for Ruby, RubyGems, and Rails.\nIt also installs several gems.'$reset
echo -e $red$bold'You will be prompted for your sudo password.'$reset

# clear any previous sudo permission
sudo -k

# run inside sudo
sudo sh <<SCRIPT
	sudo apt-get update
	# Install necessary dependencies for Ruby, Rails, RubyGems
	sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
SCRIPT

# clear sudo again to install Ruby
sudo -k

echo -e $red'Installing dependencies completed. Dropping sudo to install Ruby.\n'$reset

echo -e $red'Making Directories'$reset
if [ ! -d "$HOME/.rbenv" ]; then
	echo 'Creating ~/.rbenv'
    mkdir ~/.rbenv
fi
if [ ! -d "$HOME/.temp" ]; then
	echo 'Creating ~/.temp'
    mkdir ~/.temp
fi

echo -e $red'\nInstalling RBEnv'$reset
cd ~/
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$HOME/.gems/bin:.:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
echo -e $red'Done\n'$reset

echo -e $red'Updating $PATH'$reset

echo -e $PATH '\n'

echo -e $red'Installing RBEnv ruby-build plugin'$reset
mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
source ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git
echo -e $red'Done\n'$reset

echo -e $red'Installing Ruby'$reset
$HOME/.rbenv/bin/rbenv install $RUBYVERSION
$HOME/.rbenv/bin/rbenv rehash
echo -e $red'Done\n'$reset

echo -e $red'Setting up global Ruby version.'$reset
$HOME/.rbenv/bin/rbenv global $RUBYVERSION
ruby -v

cd ~/.temp
echo -e $red'\nInstalling RubyGems'$reset
wget -c http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz
export GEM_HOME=$HOME/.gem
tar -xzf rubygems-1.8.24.tgz
cd rubygems-1.8.24
ruby setup.rb
echo -e $red'Done'$reset

echo -e $red'\nSetting up .gemrc file.\n'$bold'By default this .gemrc does not download docs for gems.'$reset
echo ':update_sources: true' >> ~/.gemrc
echo ':bulk_threshold: 1000' >> ~/.gemrc
echo ':sources: ' >> ~/.gemrc
echo '- http://rubygems.org' >> ~/.gemrc
echo '- http://gems.github.com' >> ~/.gemrc
echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc
echo ':verbose: true' >> ~/.gemrc
echo ':benchmark: false' >> ~/.gemrc
echo ':backtrace: false' >> ~/.gemrc
echo -e $red'Done\n'$reset

echo -e $red'\nInstalling Rails & other gems'$reset
gem install rails heroku foreman spork guard-spork guard bundle
echo -e $red'Done\n\n'$reset

echo -e $red$bold'Finished. Files still exist in ~/.temp. Remove them if you wish!'$reset
cd $HOME
exec $SHELL