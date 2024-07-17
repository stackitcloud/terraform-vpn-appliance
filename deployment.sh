#!/bin/bash

systemctl restart --no-block apache2
systemctl start --no-block sshd

#
# Update System to latest state
#
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

#
# Enable Cert Based Auth
# Commend out to disable Cert based Auth
#
#a2dissite proxy
#a2ensite proxy-auth