#!/bin/bash

# Cleanup the calling script
rm "/home/user/Desktop/Finish1.sh"

cp -f -R /home/user/Downloads/ThinClient/etc /
sleep 1; rm -f -R /home/user/Downloads/ThinClient


# Pulse VPN Client
echo 'Installing Pulse Secure VPN Client'
apt -y install '/home/user/Downloads/ps-pulse-linux-installer.deb' >/dev/null
/opt/pulsesecure/bin/jamCommand /importfile /home/user/Downloads/EOTSS_Azure.pulsepreconfig >/dev/null
/opt/pulsesecure/bin/setup_cef.sh install >/dev/null
rm /Downloads/ps-pulse-linux-installer.deb
rm /Downloads/EOTSS_Azure.pulsepreconfig

# VMware Horizon View
echo 'Installing VMware Horizon View Client'
echo "y" | '/home/user/Downloads/VMware-Horizon-Client.bundle' --console --required --stop-services >/dev/null
rm /home/user/Downloads/VMware-Horizon-Client.bundle


echo "Did it work?"


