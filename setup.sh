#!/bin/bash

DISP_ARG_OK="[\033[1;32m  OK  \033[0;39m]"
DISP_ARG_NG="[\033[1;31mFailed\033[0;39m]"

######################################################

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
    echo -e "${DISP_ARG_NG}"
  else
    echo -e "${DISP_ARG_OK}"
  fi
}

function CommandCheck() {
  local COMMAND_CHECK_CMDNAME=$1
  local COMMAND_CHECK_CMDNAME_DSP="$(printf "%15s" "${COMMAND_CHECK_CMDNAME}")"
  echo -e -n "         : ${COMMAND_CHECK_CMDNAME_DSP}\r"
  which ${COMMAND_CHECK_CMDNAME} &>/dev/null
  if [ $? -ne 0 ]; then
    echo -e -n "${DISP_ARG_NG} : ${COMMAND_CHECK_CMDNAME_DSP} : === N/A ==="
  else
    echo -e -n "${DISP_ARG_OK} : ${COMMAND_CHECK_CMDNAME_DSP} : $(which ${COMMAND_CHECK_CMDNAME})"
  fi
  echo
}

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

  echo -e -n "          ${lBaseFilePath} => ${lTargetDirPath} [${lTargetFileName}]\r"
  if [ "${lBaseFilePath}" != "${lLinkFilePath}" ]; then
    echo -e "${DISP_ARG_NG}"
    echo "    >> ${lLinkFilePath}"
  else
    echo -e "${DISP_ARG_OK}"
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
LINUX_DISTRIBUTION_VER=$(cat /etc/os-release | grep -E "^VERSION_ID=" | sed -e "s/VERSION_ID=//g")
echo "Ver.$LINUX_DISTRIBUTION_VER"

######################################################

echo
echo "=============================="
echo "=== UPDATE PACKAGE MANAGER ==="
echo "=============================="
echo

echo "" >~/setuplog.txt
if [ "${LINUX_DISTRIBUTION}" == "ubuntu" ]; then
  sudo apt-get -y update
  sudo apt-get -y upgrade
else
  echo "Skip update"
fi

######################################################

echo
echo "========================"
echo "=== INSTALL SOFTWARE ==="
echo "========================"
echo

if [ "${LINUX_DISTRIBUTION}" == "ubuntu" ]; then
  InstallPackageByPackMng apt-get git
  InstallPackageByPackMng apt-get tig
  InstallPackageByPackMng apt-get vim
  InstallPackageByPackMng apt-get neovim
  InstallPackageByPackMng apt-get shfmt
  InstallPackageByPackMng apt-get gcc
  InstallPackageByPackMng apt-get clang
  InstallPackageByPackMng apt-get clang-format
  InstallPackageByPackMng apt-get gdb
  InstallPackageByPackMng apt-get cmake
  InstallPackageByPackMng apt-get tmux
  InstallPackageByPackMng apt-get peco
  InstallPackageByPackMng apt-get nodejs
  InstallPackageByPackMng apt-get npm
  InstallPackageByPackMng apt-get node-js-beautify
  InstallPackageByPackMng apt-get yarn
  InstallPackageByPackMng apt-get python3
  InstallPackageByPackMng apt-get python3-pip
  InstallPackageByPackMng apt-get python3-autopep8
  InstallPackageByPackMng apt-get docker
  InstallPackageByPackMng apt-get docker-compose
  InstallPackageByPackMng apt-get net-tools
  InstallPackageByPackMng apt-get exuberant-ctags
  InstallPackageByPackMng apt-get hugo
  InstallPackageByPackMng apt-get tree

  InstallPackageByPackMng apt-get manpages-ja

  sudo chmod +x /usr/share/doc/git/contrib/diff-highlight/diff-highlight
else
  echo "Skip install"
fi

######################################################

echo
echo "========================"
echo "=== COMMAND CHECK ==="
echo "========================"
echo

CommandCheck git
CommandCheck tig
CommandCheck vim
CommandCheck nvim
CommandCheck shfmt
CommandCheck gcc
CommandCheck clang
CommandCheck clang-format
CommandCheck gdb
CommandCheck cmake
CommandCheck tmux
CommandCheck peco
CommandCheck node
CommandCheck npm
CommandCheck js-beautify
CommandCheck yarn
CommandCheck python3
CommandCheck python3-pip
CommandCheck autopep8
CommandCheck docker
CommandCheck docker-compose
CommandCheck ifconfig # net-tools
CommandCheck ctags
CommandCheck hugo
CommandCheck tree
CommandCheck diff-highlight

######################################################

echo
echo "===================="
echo "=== SETUP BASHRC ==="
echo "===================="
echo

echo "Please add below command to ~/.bashrc"
echo ">> source ${PWD_SCRIPT}/dotfiles/.bashrc"
# CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.bashrc ~/ ./

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
echo "=== SETUP GIT ==="
echo "================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.gitconfig ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.git-prompt.sh ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.tigrc ~/ ./

######################################################

echo
echo "================="
echo "=== SETUP ETC ==="
echo "================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.ctags ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.editorconfig ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.tmux.conf ~/ ./

######################################################

cd ${PWD_SCRIPT}

DISP_ARG_OK=
DISP_ARG_NG=
PWD_SCRIPT=
LINUX_DISTRIBUTION=
LINUX_DISTRIBUTION_VER=

# end
