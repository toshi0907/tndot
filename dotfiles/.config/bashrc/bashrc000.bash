#######################
### Functions
#######################

### path

function BashrcAddPath() {
  local item=$1
  # echo "ADD_PATH:$1"
  echo ${PATH} | grep ${item} >/dev/null
  if [ $? -ne 0 ]; then
    if [ ! -d ${item} ]; then
      echo "Failed to setup additional PATH!"
      echo "${item}"
    else
      export PATH="${PATH}:${item}"
    fi
  fi
}

### git

function BashrcCommitFixup() {
  local lTargetHash=$(git log --oneline | head -100 | peco | awk '{ print $1 }')

  if [ "${lTargetHash}" != "" ]; then
    echo "fixup commit!!!"
    git commit --fixup=${lTargetHash}
  fi
}

function BashrcGitRebaseCheck() {
  local lHashBefRbase=$(git reflog | grep rebase --after-context=1 | grep '(start)' --after-context=1 --max-count=1 | tail -1 | awk '{ print $1 }')

  echo "diff HEAD..${lHashBefRbase}"
  echo "=================="
  git diff HEAD..${lHashBefRbase}
  echo "=================="
}

function BashrcGitBranchRoot() {
  git_root_hash=""
  git rev-parse --abbrev-ref rc &>/dev/null
  if [ $? -eq 0 ]; then
    git_root_hash=$(git show-branch --merge-base rc HEAD)
  fi

  git rev-parse --abbrev-ref main &>/dev/null
  if [ $? -eq 0 ]; then
    git_root_hash=$(git show-branch --merge-base main HEAD)
  fi

  git rev-parse --abbrev-ref master &>/dev/null
  if [ $? -eq 0 ]; then
    git_root_hash=$(git show-branch --merge-base master HEAD)
  fi
  echo ${git_root_hash}
}

function GitAccuntToMain() {
  # メイン<=これを環境に応じて上書き
  git config --global user.name toshi0907
  git config --global user.email n00toshi@gmail.com
}

function GitAccuntToSub() {
  # サブ（個人）
  git config --global user.name toshi0907
  git config --global user.email n00toshi@gmail.com
}

function GitAccuntNow() {
  local l_git_branch=$(__git_ps1)
  if [ "$l_git_branch" == "" ]; then return 0; fi

  GitAccuntToMain
  if [ $(pwd | grep ${HOME}/tndot) ]; then
    GitAccuntToSub
  fi
  local l_git_username=$(git config --list | grep user.name | sed -e "s/user.name=//g")

  echo "${l_git_username}:${l_git_branch}"
}

### nkf

# nkf command
# <改行コード>
# -d,-Lu : 改行をLFにする（UNIX系）
# -c,-Lw : 改行をCRLFにする（Windows系）
# -Lm    : 改行をCRにする（OS Xより前のmac OS系
function NkfSymLinkFileNameGet() {
  local lFilePath=""
  if [ -e $1 ]; then
    lFilePath=$(readlink $1 || echo $1)
  fi
  echo $lFilePath
}

function NkfOverWriteWithSymLinkCheck_Euc() {
  local lFilePath=$(NkfSymLinkFileNameGet $1)
  if [ -n "$lFilePath" ]; then
    nkf -e --overwrite $lFilePath
    echo $lFilePath
    echo -n "==>"
    nkf -g $lFilePath
  else
    echo "Invalid file name!!! => $1"
  fi
}

function NkfOverWriteWithSymLinkCheck_ShiftJis() {
  local lFilePath=$(NkfSymLinkFileNameGet $1)
  if [ -n "$lFilePath" ]; then
    nkf -s -c --overwrite $lFilePath
    echo $lFilePath
    echo -n "==>"
    nkf -g $lFilePath
  else
    echo "Invalid file name!!! => $1"
  fi
}

function NkfOverWriteWithSymLinkCheck_UTF() {
  local lFilePath=$(NkfSymLinkFileNameGet $1)
  if [ -n "$lFilePath" ]; then
    nkf -w --overwrite $lFilePath
    echo $lFilePath
    echo -n "==>"
    nkf -g $lFilePath
  else
    echo "Invalid file name!!! => $1"
  fi
}

### util

function bashrc_pts_kill() {
  local i=
  for ((i = 0; i < 10; i++)); do
    if [ "/dev/pts/${i}" != "$(tty)" ]; then
      pkill -9 -t pts/${i}
    fi
  done
}

#######################
### Enviroment
#######################

export EDITOR=nvim
export SHELL=/bin/bash

# PATH
BashrcAddPath /usr/share/doc/git/contrib/diff-highlight

#######################
### Alias
#######################

# nkf
alias nkfeo='NkfOverWriteWithSymLinkCheck_Euc '
alias nkfso='NkfOverWriteWithSymLinkCheck_ShiftJis '
alias nkfwo='NkfOverWriteWithSymLinkCheck_UTF '

# basic command
alias cp='cp -ri'
alias rm='rm -ri'
alias mv='mv -i'
alias ..='cd ..'
alias lsdir='ls -d */'
alias ll='ls -la'
alias watch="watch -c " # watchでaliasが使用できない対応
alias grep='grep -i --color=auto'
alias vim='nvim'
alias vimdiff='nvim -d'

# git
alias gs='git status -s'
alias gb='git branch'
alias gba='git branch --all'
alias gl='git lg'
alias gla='git lga'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gagca='git add . && git commit --amend'
alias gagcan='git add . && git commit --amend --no-edit'
alias ga='git add'
alias gr='git rebase -i HEAD~50 || git rebase -i $(git log --oneline --reverse --pretty=format:"%h" | head -1)'
alias gra='echo "please use => git abort"'
alias grc='git add . && git rebase --continue'
alias gma='echo "please use => git abort"'
alias grrreset='git revert HEAD --no-edit; git revert HEAD --no-edit; git reset HEAD^'
alias gacsagyo='git add . && git commit -m "[WIP]:"'
alias gcfixup='BashrcCommitFixup'
alias gacfixup='git add . && BashrcCommitFixup'
alias rebase_check='BashrcGitRebaseCheck'
alias gupdate='git remote update'
alias gpr='git pull --rebase'

alias gfchk='git fupchk'
alias gfinc='git fupinc'
alias gfset='git fupset'
alias gfrst='git fupreset'

# etc
alias qqq_bashrc_renew='source ~/.bashrc'
alias qqq_relogin='exec $SHELL -l'
alias qqq_killpts='bashrc_pts_kill'
alias qqq_shutdown='sudo shutdown -h now'
alias qqq_tmux_reload='tmux source-file ~/.tmux.conf'

alias COLOR_CHK='curl -s https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash'

#######################
### LoadSettings
#######################
source ~/.git-prompt.sh

PS1='\[\e[0;32m\][\[\e[0;36m\]$(GitAccuntNow)\[\e[0;32m\] \w]\[\e[m\]\\$ '

##########################
### Notifications
##########################
function TndotUpdateCheck() {
  cd ~/tndot
  git fetch
  HASH_TNDOT_LOCAL=$(git rev-parse main)
  HASH_TNDOT_ORIGIN=$(git rev-parse origin/main)
  HASH_TNDOT_MERGEBASE=$(git merge-base main origin/main)
  if [ "${HASH_TNDOT_LOCAL}" != "${HASH_TNDOT_ORIGIN}" ]; then
    echo
    echo "======== [tndot update check] ========"
    echo
    echo "  << update needed >>  main != origin/main"
    if [ "${HASH_TNDOT_LOCAL}" == "${HASH_TNDOT_MERGEBASE}" ]; then
      echo
      echo "  << update command >> ( cd ~/tndot; git checkout main; git merge origin/main )"
    fi
    echo
    echo "======================================"
    echo
  fi

  HASH_TNDOT_LOCAL=
  HASH_TNDOT_ORIGIN=
  HASH_TNDOT_MERGEBASE=
}
TndotUpdateCheck &
