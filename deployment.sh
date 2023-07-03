#!/bin/bash

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

systemctl restart apache2
systemctl start sshd