#!/bin/bash

echo "Run Finish2"

# Cleanup the calling script
#rm "/home/user/Downloads/Finish1.sh"

#cp -f -R /home/user/Downloads/ThinClient/etc /
#hostnamectl set-hostname thinclient
#rm -f -R /home/user/Downloads/ThinClient
#sed -i 's/"GRUB_TIMEOUT=5"/"GRUB_TIMEOUT=0"/' /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg >/dev/null

# Pulse VPN Client
#echo 'Installing Pulse Secure VPN Client'
#apt -y install '/home/user/Downloads/ps-pulse-linux-installer.deb' >/dev/null
#sleep 1
#/opt/pulsesecure/bin/jamCommand /importfile /home/user/Downloads/EOTSS_Azure.pulsepreconfig >/dev/null
#sleep 1
#/opt/pulsesecure/bin/setup_cef.sh install >/dev/null
#sleep 1
#rm '/home/user/Downloads/ps-pulse-linux-installer.deb' >/dev/null
#rm '/home/user/Downloads/EOTSS_Azure.pulsepreconfig' >/dev/null

# VMware Horizon View
#echo 'Installing VMware Horizon View Client'
#echo "y" | '/home/user/Downloads/VMware-Horizon-Client.bundle' --console --required --stop-services >/dev/null
#sleep 1
#rm '/home/user/Downloads/VMware-Horizon-Client.bundle' >/dev/null

# Reboot
#systemctl --no-wall reboot
#exit
