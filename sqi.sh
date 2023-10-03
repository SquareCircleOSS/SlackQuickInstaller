#!/bin/bash

#orginal author:cly 
#orginal author's mail:cly092@126.com

if [ ! "$(id -u)" = "0" ]
then
echo -e "\nYou should run this script with root."
exit
fi

SLACKBUILDS_ROOT="/SlackQuickInstaller/Slackbuilds"

#cd to Slackbuilds dir
cd ${SLACKBUILDS_ROOT}

#update Slackbuilds repo at first
git pull

#find package name
PKG_NAME=$1
FIND_RESULT=$(find ./ -iname ${PKG_NAME} -type d)
if [ X"" = X${FIND_RESULT} ]
then
echo -e "\nNo packages match ${PKG_NAME}." #can not find matched packages
echo -e "\nPossible matches are:\n$(find ./ -iname *${PKG_NAME}* -type d)"
exit 1
else #find something
echo -e "\nFind package in directory: ${FIND_RESULT}"
fi

#cd to this dir
cd ${FIND_RESULT}

#resolve download link
DOWNLOAD_LINK=$(grep -w "DOWNLOAD" ${PKG_NAME}.info | cut -d '"' -f 2)
echo -e "\nDownload link: ${DOWNLOAD_LINK}."

#download source package
wget -t 4 ${DOWNLOAD_LINK}
if [ ! $? -eq 0 ]
then
echo -e "\nDownload source package faild."
exit 2
fi

#run Slackbuild script
chmod +x ${PKG_NAME}.SlackBuild
./${PKG_NAME}.SlackBuild

#copy build result
if [ ! $? -eq 0 ]
then
echo -e "\nRun slackbuild faild."
exit 3
fi

SLACKBUILD_RESULT=$(ls /tmp/${PKG_NAME}*_SBo.t[xg]z)
if [ X${SLACKBUILD_RESULT} = X"" ]
then
echo -e "\nGenerate package faild."
exit 4
fi

cp ${SLACKBUILD_RESULT} ./
installpkg ./$(basename ${SLACKBUILD_RESULT})
if [ ! $? -eq 0 ]
then
echo -e "\ninstall package faild."
exit 5
fi

#install success
echo -e "\nInstall package ${PKG_NAME} successfully!"

unset SLACKBUILDS_ROOT PKG_NAME FIND_RESULT DOWNLOAD_LINK SLACKBUILD_RESULT