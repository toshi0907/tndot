#!/bin/bash

echo -n "input email to login => "
read emailstr

pcloudcc -s -u ${emailstr} -p -m ~/pcloud

mkdir ~/.config/pcloud
echo ${emailstr} > ~/.config/pcloud/email.txt

# pcloudcc options
# -h [ --help ]             produce help message
# -u [ --username ] arg     pCloud account name
# -p [ --password ]         Ask pCloud account password
# -c [ --crypto ]           Ask crypto password
# -y [ --passascrypto ] arg Use user password as crypto password also.
# -d [ --daemonize ]        Daemonize the process.
# -o [ --commands  ]        Parent stays alive and processes commands.
# -m [ --mountpoint ] arg   Mount point where drive to be mounted.
# -k [ --commands_only ]    Daemon already started pass only commands
# -n [ --newuser ]          Switch if this is a new user to be registered.
# -s [ --savepassword ]     Save password in database.
