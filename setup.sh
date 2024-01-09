#!/bin/bash

PACKAGE_MNG=""

cat /etc/os-release | grep -E "^ID=" | grep ubuntu
if [ $? -eq 0 ]; then
  PACKAGE_MNG="apt-get"
fi

if [ -z "$PACKAGE_MNG" ]; then
  echo 'Error: Cannot detect package manager'
  exit
fi

function InstallPackageByPackMng() {
  echo -e -n "[ ** ] $2\r"
  echo -e "\n\n>>> $2 start" >>~/setuplog.txt
  sudo $1 install -y $2 &>>~/setuplog.txt
  if [ $? -ne 0 ]; then
    echo "Error:[$2]failed to install"
    exit
  else
    echo -e -n "\033[1;32m"
    echo "[ OK ]"
    echo -e -n "\033[0;39m"
  fi
}

echo "" >~/setuplog.txt

sudo apt-get -y update
sudo apt-get -y upgrade

InstallPackageByPackMng ${PACKAGE_MNG} git
InstallPackageByPackMng ${PACKAGE_MNG} tig
InstallPackageByPackMng ${PACKAGE_MNG} vim
InstallPackageByPackMng ${PACKAGE_MNG} neovim
InstallPackageByPackMng ${PACKAGE_MNG} shfmt
InstallPackageByPackMng ${PACKAGE_MNG} gcc
InstallPackageByPackMng ${PACKAGE_MNG} clang
InstallPackageByPackMng ${PACKAGE_MNG} clang-format
InstallPackageByPackMng ${PACKAGE_MNG} gdb
InstallPackageByPackMng ${PACKAGE_MNG} cmake
InstallPackageByPackMng ${PACKAGE_MNG} tmux
InstallPackageByPackMng ${PACKAGE_MNG} peco
InstallPackageByPackMng ${PACKAGE_MNG} nodejs
InstallPackageByPackMng ${PACKAGE_MNG} npm
InstallPackageByPackMng ${PACKAGE_MNG} node-js-beautify
InstallPackageByPackMng ${PACKAGE_MNG} yarn
InstallPackageByPackMng ${PACKAGE_MNG} python3
InstallPackageByPackMng ${PACKAGE_MNG} python3-pip
InstallPackageByPackMng ${PACKAGE_MNG} docker
InstallPackageByPackMng ${PACKAGE_MNG} docker-compose
InstallPackageByPackMng ${PACKAGE_MNG} net-tools

# end
