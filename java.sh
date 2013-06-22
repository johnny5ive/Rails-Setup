#!/bin/bash
#
#Install Java JDKs seperately as they require interaction.
#	
echo "* Installing Sun Java. Press Enter to Continue..."
read dummy
aptitude -y install python-software-properties > /dev/null
add-apt-repository ppa:sun-java-community-team/sun-java6 > /dev/null
aptitude -y install sun-java6-jdk sun-java5-jdk
update-java-alternatives -s java-1.5.0-sun > /dev/null
echo "* Install completed!"
sudo -k
exit 0