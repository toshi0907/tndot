#!/bin/bash

GithubKeyName=id_rsa_github

if [ -e ~/.ssh/id_rsa_github ]; then
  cp ~/.ssh/config ~/.ssh/config_backup
  cp config ~/.ssh

  cd ~/.ssh
  chmod 600 ${GithubKeyName}

  cd ~/
  ssh -T github
else
  echo "${GithubKeyName} is not exist."
fi
