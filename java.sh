#!/bin/bash
#
#Install Java JDKs seperately as they require interaction.
#	
echo "* Installing Sun Java. Press Enter to Continue..."
read dummy
echo "Continuing..."

# aptitude install -y libdistro-info-perl > /dev/null

wget https://github.com/morganhein/oab-java6/raw/0.2.8/oab-java.sh -O oab-java.sh > /dev/null
chmod +x oab-java.sh > /dev/null
sudo ./oab-java.sh

# aptitude -y install python-software-properties > /dev/null
# add-apt-repository ppa:sun-java-community-team/sun-java6 > /dev/null
aptitude update
aptitude -y install sun-java6-jdk
update-java-alternatives -s java-6-sun
echo "* Install completed!"
sudo -k
exit 0