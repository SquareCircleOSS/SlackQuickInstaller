#!/bin/bash

if [ ! "$(id -u)" = "0" ]
then
echo -e "\nYou should run this script with root."
exit
fi

# Run this at first,the purpose is config your environment
echo "Creating a directory in / for SlackQuickInstaller"
mkdir /SlackQuickInstaller
cd /SlackQuickInstaller

echo "Copy the files of SlackQuickInstaller"
cp -r ./* /SlackQuickInstaller/

echo "Adding the directory into PATH"
echo "PATH=$PATH:/SlackQuickInstaller" > ~/.bashrc
echo "PATH=$PATH:/SlackQuickInstaller" > /etc/environment

echo "Cloning the git repo from SlackBuilds..."
git clone git://git.slackbuilds.org/slackbuilds ./Slackbuilds

echo "Congratulations! Now you can use SlackQuickInstaller to install any packages from SlackBuilds."
echo "############"
echo "Use it:"
echo "sudo sqi.sh package_name"
echo "############"