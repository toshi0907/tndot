#!/bin/bash

### 参考 : https://qiita.com/24Century/items/5360b36d1b5c535f7bfa

cd ~/
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

cd ~/.local/bin
wget -O ~/.local/bin/dropbox "https://www.dropbox.com/download?dl=packages/dropbox.py"
chmod +x ~/.local/bin/dropbox

sudo mkdir -p /share/dropbox
ln -s /share/dropbox ~/Dropbox

~/.dropbox-dist/dropboxd
~/.local/bin/dropbox lansync n
~/.local/bin/dropbox start

