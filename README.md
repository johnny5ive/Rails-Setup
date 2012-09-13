This script installs Ruby, Rails, and Rubygems using the following mechanisms:

1. Downloads all the dependencies using apt-get. 
2. Downloads and installs rbenv and the ruby-build plugin to $HOME/.rbenv.
3. Updates $PATH to include .rbenv/bin, .gems/bin, .rbenv/shims, and . (current directory)
4. Installs Ruby "1.9.3-p194" using the ruby-build to $HOME/.rbenv/versions
5. Installs RubyGems 1.8.24
6. Configures a .gemrc that disables all documentation.
7. Installs the gems: rails heroku foreman spork guard-spork guard bundle.