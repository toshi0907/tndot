#!/bin/bash

sudo apt install -y cmake zlib1g-dev libboost-system-dev libboost-program-options-dev libpthread-stubs0-dev libfuse-dev libudev-dev fuse build-essential git

mkdir -p ~/install/pcloud
cd ~/install/pcloud

git clone https://github.com/pcloudcom/console-client.git
cd console-client/pCloudCC/lib/pclsync/
make clean && make fs
cd ../mbedtls/
cmake . && make clean && make
cd ../..
cmake . && make
sudo make install
sudo ldconfig

mkdir -p ~/pcloud
sudo chown $USER:$USER ~/pcloud


