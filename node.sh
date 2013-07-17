#!/bin/bash
#
# Created by Morgan Hein
# Installs Nodejs, NPM, Yeoman and gems

# Text color variables
und=$(tput sgr 0 1)			# Underline
bold=$(tput bold)           # Bold
red=$(tput setaf 1) 		# Red
blue=$(tput setaf 4) 		# Blue
wht=$(tput setaf 7) 		# White
reset=$(tput sgr0)          # Reset
redbold=${red}${bold}


aptitude update > /dev/null
aptitude install -y python-software-properties python g++ make > /dev/null

echo -e $blue'Installing Node.js'$reset
add-apt-repository ppa:chris-lea/node.js
aptitude update > /dev/null
aptitude install -y nodejs

echo -e $blue'Current Node Version: '$reset
node -v
echo -e $blue'Current NPM Version: '$reset
npm -v
echo -e $blue'Done\n'$reset

echo -e $blue'Updating Node.js/NPM'$reset
npm update
npm update npm -g
echo -e $blue'Current Node Version: '$reset
node -v
echo -e $blue'Current NPM Version: '$reset
npm -v
echo -e $blue'Done\n'$reset

echo -e $blue'Updating packages'$reset
npm update -g
echo -e $blue'Done\n'$reset

echo -e $blue'Installing Yeoman and gems'$reset
npm install -g yo compass grunt-cli bower generator-angular
echo -e $blue'Done\n'$reset
