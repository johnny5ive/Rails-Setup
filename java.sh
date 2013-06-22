#!/bin/bash
#
#Install Java JDKs seperately as they require interaction.
#	
echo "* Installing Sun Java. Press Enter to Continue..."
read dummy
echo "Continuing..."

wget https://github.com/flexiondotorg/oab-java6/raw/0.2.8/oab-java.sh -O oab-java.sh > /dev/null
chmod +x oab-java.sh > /dev/null
sudo ./oab-java.sh

# aptitude -y install python-software-properties > /dev/null
# add-apt-repository ppa:sun-java-community-team/sun-java6 > /dev/null

aptitude -y install sun-java6-jdk sun-java5-jdk
update-java-alternatives -s java-1.6.0-sun
echo "* Install completed!"
sudo -k
exit 0