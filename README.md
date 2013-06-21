<h1> Ruby, RubyGems, RoR, Node.js, NPM, and Yeoman installer</h1>

Intended for Debian based systems only (Ubuntu, Mint, etc)

This script installs Ruby, Rails, and Rubygems using the following mechanisms:

1. Downloads all the dependencies using apt-get. 
2. Downloads and installs rbenv and the ruby-build plugin to $HOME/.rbenv.
3. Updates $PATH to include .rbenv/bin, .gems/bin, .rbenv/shims, and . (current directory)
4. Installs Ruby "2.0.0-p194" using the ruby-build to $HOME/.rbenv/versions
5. Installs latest RubyGems
6. Configures a .gemrc that disables all documentation.
7. Installs Ruby gems: rails heroku foreman spork guard-spork guard bundle.
8. Installs latest Node.js
9. Installs latest NPM
10. Installs Node gems: yo, compass, grunt-cli, bower, angular.


To install this, copy/paste into a terminal:

git clone https://github.com/morganhein/Dev-Setup.git && chmod +x Dev-Setup/DevSetup.sh && ./Dev-Setup/DevSetup.sh
