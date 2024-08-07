#!/bin/bash

DISP_ARG_OK="[\033[1;32m  OK  \033[0;39m]"
DISP_ARG_NG="[\033[1;31mFailed\033[0;39m]"
SETUP_LOG_FILE_PATH=~/setuplog.txt

######################################################

function InstallPackageByPackMng() {
  # $1 : Package manager name
  # $2 : Software name
  if [ "$1" == "DUMMY" ]; then
    echo "[SKIP] $2"
    return
  fi

  echo -e -n "[ **** ] $2\r"
  echo -e "\n\n>>> $2 start" >>${SETUP_LOG_FILE_PATH}
  sudo $1 install -y $2 &>>${SETUP_LOG_FILE_PATH}
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

function VimPluginInstall() {
  local lTargetPath=
  if [ "$1" == "start" ]; then
    lTargetPath=~/.config/nvim/pack/tn/start
  elif [ "$1" == "opt" ]; then
    lTargetPath=~/.config/nvim/pack/tn/opt
  else
    echo "Error@VimPluginInstall"
    exit 1
  fi

  local lPluginName=$2

  CheckAndCdDir ${lTargetPath}

  echo "    ${lPluginName} install" &>>${SETUP_LOG_FILE_PATH}

  git clone https://github.com/$2 --depth=1 &>>${SETUP_LOG_FILE_PATH}
}

function CheckAndCdDir() {
  # $1 : Target directory
  if [ ! -d $1 ]; then
    mkdir -p $1
  fi
  cd $1
}

function ManualInstallNeovim() {
  if [ "${LINUX_DISTRIBUTION}" == "ubuntu" ]; then
    DOWNLOAD_PATH=${HOME}/install/neovim
    DOWNLOAD_VER=v0.9.0
    CheckAndCdDir ${DOWNLOAD_PATH}
    curl -LO https://github.com/neovim/neovim/releases/download/${DOWNLOAD_VER}/nvim.appimage
    chmod +x nvim.appimage
    ./nvim.appimage --appimage-extract
    cd squashfs-root/usr
    cp -r * ~/.local
  fi
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
  InstallPackageByPackMng apt     docker-compose-v2
  InstallPackageByPackMng apt-get net-tools
  InstallPackageByPackMng apt-get exuberant-ctags
  InstallPackageByPackMng apt-get hugo
  InstallPackageByPackMng apt-get tree
  InstallPackageByPackMng apt-get xsel

  InstallPackageByPackMng apt-get manpages-ja

  sudo chmod +x /usr/share/doc/git/contrib/diff-highlight/diff-highlight

  # manual install
  ManualInstallNeovim

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  nivm install --lts
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
CommandCheck nvm
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
CommandCheck wget
CommandCheck xsel

######################################################

echo
echo "=================="
echo "=== CREATE DIR ==="
echo "=================="
echo

echo "~/.local/bin"
CheckAndCdDir ~/.local/bin
echo "~/.local/note"
CheckAndCdDir ~/.local/note
echo "Done!!!"

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

# plugins
if [ ! -d ~/.config/nvim/pack/tn/start ]; then
  mkdir -p ~/.config/nvim/pack/tn/start
fi

echo "Plugins install start"

VimPluginInstall 'opt' 'airblade/vim-gitgutter'
VimPluginInstall 'opt' 'lewis6991/gitsigns.nvim'
VimPluginInstall 'start' 'tpope/vim-fugitive'
VimPluginInstall 'start' 'hotwatermorning/auto-git-diff'
VimPluginInstall 'start' 'ctrlpvim/ctrlp.vim'
VimPluginInstall 'start' 'vim-scripts/taglist.vim'
VimPluginInstall 'start' 'majutsushi/tagbar'
VimPluginInstall 'start' 'vim-scripts/vim-auto-save'
VimPluginInstall 'start' 'thinca/vim-qfreplace'
VimPluginInstall 'start' 'tpope/vim-surround'
VimPluginInstall 'start' 'justmao945/vim-clang'
VimPluginInstall 'start' 'junegunn/vim-easy-align'
VimPluginInstall 'start' 'maksimr/vim-jsbeautify'
VimPluginInstall 'opt' 'tomasr/molokai'
VimPluginInstall 'start' 'aklt/plantuml-syntax'
VimPluginInstall 'start' 'vim-scripts/aspnetcs'
VimPluginInstall 'start' 'vim-jp/vimdoc-ja'

# additional
echo "additional : vim-jsbeautify"
(
  if [ ! -e ~/.config/nvim/pack/tn/start/vim-jsbeautify/plugin/lib/v1.8.9.zip ]; then
    cd ~/.config/nvim/pack/tn/start/vim-jsbeautify/plugin/lib
    wget https://github.com/beautify-web/js-beautify/archive/v1.8.9.zip && unzip v1.8.9.zip && cp -rf js-beautify-1.8.9/* ~/.config/nvim/pack/tn/start/vim-jsbeautify/plugin/lib/
  fi
) >>${SETUP_LOG_FILE_PATH}

echo "Plugins install end"

echo "[Plugin:start]"
ls ~/.config/nvim/pack/tn/start
echo "[Plugin:opt]"
ls ~/.config/nvim/pack/tn/opt

######################################################

echo
echo "================="
echo "=== SETUP GIT ==="
echo "================="
echo

CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.gitconfig ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.git-prompt.sh ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.tigrc ~/ ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.local/bin/git/git-abort ~/.local/bin ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.local/bin/git/git-hooks-apply ~/.local/bin ./
CreateSymLinkAndCheck ${PWD_SCRIPT}/dotfiles/.local/bin/git_hooks/prepare-commit-msg ~/.local/git_hooks ./

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
