#!/bin/bash

function InstallPackageByPackMng() {
  if [ "$1" == "DUMMY" ]; then
    echo "[SKIP] $2"
    return
  fi

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

function CheckAndCdDir() {
  if [ ! -d $1 ]; then
    mkdir -p $1
  fi
  echo
  echo "change dir ==> $1"
  cd $1
}

######################################################

echo
echo "============"
echo "=== TREE ==="
echo "============"
echo
tree -a -I .git

echo
echo "==========="
echo "=== PWD ==="
echo "==========="
echo

PWD_SCRIPT=$(pwd)
echo "$PWD_SCRIPT"

######################################################

echo
echo "================"
echo "=== LINUX ID ==="
echo "================"
echo

LINUX_DISTRIBUTION=$(cat /etc/os-release | grep -E "^ID=" | sed -e "s/ID=//g")
echo "$LINUX_DISTRIBUTION"

######################################################

echo
echo "=============================="
echo "=== UPDATE PACKAGE MANAGER ==="
echo "=============================="
echo

PACKAGE_MNG="DUMMY"
cat /etc/os-release | grep -E "^ID=" | grep ubuntu
if [ $? -eq 0 ]; then
  PACKAGE_MNG="apt-get"
fi

if [ "$PACKAGE_MNG" != "DUMMY" ]; then
  echo "" >~/setuplog.txt
  sudo ${PACKAGE_MNG} -y update
  sudo ${PACKAGE_MNG} -y upgrade
else
  echo "Skip update"
fi

######################################################

echo
echo "========================"
echo "=== INSTALL SOFTWARE ==="
echo "========================"
echo

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

######################################################

echo
echo "===================="
echo "=== SETUP BASHRC ==="
echo "===================="
echo

CheckAndCdDir ~/

ln -s ${PWD_SCRIPT}/dotfiles/.bashrc ./

CheckAndCdDir ~/.config/bashrc

for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.config/bashrc/); do
  echo -n "file : ${file_name}"
  echo -n " : "
  ln -s ${PWD_SCRIPT}/dotfiles/.config/bashrc/${file_name} ./
done

######################################################

echo
echo "================="
echo "=== SETUP VIM ==="
echo "================="
echo

CheckAndCdDir ~/.config/nvim/colors
for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.config/nvim/colors/); do
  echo -n "file : ${file_name}"
  echo -n " : "
  ln -s ${PWD_SCRIPT}/dotfiles/.config/nvim/colors/${file_name} ./
done

CheckAndCdDir ~/.vim/vimrc

for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.vim/vimrc/); do
  echo -n "file : ${file_name}"
  echo -n " : "
  ln -s ${PWD_SCRIPT}/dotfiles/.vim/vimrc/${file_name} ./
done

######################################################

cd ${PWD_SCRIPT}

# end
