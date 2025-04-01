#!/bin/bash

PCLOUD_MOUNT_DIR=/home/${USER}/pcloud
PCLOUD_USERNAME=$(cat ~/.config/pcloud/email.txt)

str="
[Unit]
Description=pCloud mount
After=network-online.target

[Service]
Type=forking
User=${USER}
Group=${USER}
WorkingDirectory=/home/${USER}
ExecStart=/usr/local/bin/pcloudcc -u ${PCLOUD_USERNAME} -m ${PCLOUD_MOUNT_DIR} -d
ExecStop=/usr/local/bin/pcloudcc -u ${PCLOUD_USERNAME} -k < <(printf "finalize")
Restart=always

[Install]
WantedBy=multi-user.target
"

# echo "${str}"
# exit

echo "${str}" >~/install/pcloud.service
sudo cp ~/install/pcloud.service /etc/systemd/system/pcloud.service

sudo systemctl daemon-reload
sudo systemctl start pcloud
sudo systemctl enable pcloud
