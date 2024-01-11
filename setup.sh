#!/bin/bash

function InstallPackageByPackMng() {
  # $1 : Package manager name
  # $2 : Software name
  if [ "$1" == "DUMMY" ]; then
    echo "[SKIP] $2"
    return
  fi

  echo -e -n "[ **** ] $2\r"
  echo -e "\n\n>>> $2 start" >>~/setuplog.txt
  sudo $1 install -y $2 &>>~/setuplog.txt
  if [ $? -ne 0 ]; then
    echo -e -n "\033[1;31m"
    echo "[Failed]"
    echo -e -n "\033[0;39m"
  else
    echo -e -n "\033[1;32m"
    echo "[  OK  ]"
    echo -e -n "\033[0;39m"
  fi
}

function CheckAndCdDir() {
  # $1 : Target directory
  if [ ! -d $1 ]; then
    mkdir -p $1
  fi
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
InstallPackageByPackMng ${PACKAGE_MNG} python3-autopep8
InstallPackageByPackMng ${PACKAGE_MNG} docker
InstallPackageByPackMng ${PACKAGE_MNG} docker-compose
InstallPackageByPackMng ${PACKAGE_MNG} net-tools
InstallPackageByPackMng ${PACKAGE_MNG} exuberant-ctags

######################################################

function CreateSymLinkAndCheck() {
  # $1 <ex> /base/file/path/filename
  local lBaseFilePath=$1

  # $2 <ex> /target/dir/path/
  local lTargetDirPath=$2

  # $3 <ex> target_file_name
  local lTargetFileName=$3

  if [ "$lTargetFileName" == "./" ]; then
    lTargetFileName=${lBaseFilePath##*/}
  fi

  CheckAndCdDir ${lTargetDirPath}
  ln -s ${lBaseFilePath} ${lTargetFileName} &>/dev/null

  local lLinkFilePath=$(readlink ${lTargetFileName})

  echo -e -n "       ${lBaseFilePath} => ${lTargetDirPath} [${lTargetFileName}]\r"
  if [ "${lBaseFilePath}" != "${lLinkFilePath}" ]; then
    echo -e "\033[1;31m[ NG ]\033[0;39m"
    echo "    >> ${lLinkFilePath}"
  else
    echo -e "\033[1;32m[ OK ]\033[0;39m"
  fi
}

echo
echo "===================="
echo "=== SETUP BASHRC ==="
echo "===================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.bashrc ~/ ./

for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.config/bashrc/); do
  CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.config/bashrc/${file_name} ~/.config/bashrc ./
done

######################################################

echo
echo "================="
echo "=== SETUP VIM ==="
echo "================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.vimrc ~/.config/nvim/ ./init.vim
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.vimrc ~/ ./

for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.config/nvim/colors/); do
  CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.config/nvim/colors/${file_name} ~/.config/nvim/colors ./
done

for file_name in $(ls ${PWD_SCRIPT}/dotfiles/.vim/vimrc/); do
  CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.vim/vimrc/${file_name} ~/.vim/vimrc ./
done

######################################################

echo
echo "================="
echo "=== SETUP ETC ==="
echo "================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.ctags ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.editorconfig ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.gitconfig ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.tigrc ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.tmux.conf ~/ ./

######################################################


cd ${PWD_SCRIPT}

# end
