#!/bin/bash

# Cleanup the calling script
#rm "/home/user/Desktop/Finish1.sh"

cp -f -R /home/user/Downloads/ThinClient/etc /
sleep 10
rm -f -R /home/user/Downloads/ThinClient


# Pulse VPN Client
echo 'Installing Pulse Secure VPN Client'
apt -y install '/home/user/Downloads/ps-pulse-linux-installer.deb'
/opt/pulsesecure/bin/jamCommand /importfile /home/user/Downloads/EOTSS_Azure.pulsepreconfig
/opt/pulsesecure/bin/setup_cef.sh install
#rm /Downloads/ps-pulse-linux-installer.deb
#rm /Downloads/EOTSS_Azure.pulsepreconfig

# VMware Horizon View
echo 'Installing VMware Horizon View Client'
echo "y" | '/home/user/Downloads/VMware-Horizon-Client.bundle' --console --required --stop-services


echo "Did it work?"


