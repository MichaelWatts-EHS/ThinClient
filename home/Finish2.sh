#!/bin/bash

echo "Running Finish2"

# Cleanup the calling script
rm Finish1.sh

cp -f -R /home/user/Downloads/ThinClient/etc /
rm -f -R /home/user/Downloads/ThinClient/etc

sed -i 's/"GRUB_TIMEOUT=5"/"GRUB_TIMEOUT=0"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg >/dev/null

hostnamectl set-hostname thinclient

apt update

# Install Pulse VPN Client
if [ ! -f /opt/pulsesecure/bin/pulseUI ]; then
  echo 'Installing Pulse Secure VPN Client'
  apt -y install '/home/user/Downloads/ThinClient/installs/ps-pulse-linux-installer.deb'
fi

if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then
  echo 'Installing Cef Runtime'
  /opt/pulsesecure/bin/setup_cef.sh install
fi

# Configure Pulse Client
if [ -f /opt/pulsesecure/bin/pulseUI ]; then
  echo 'Configuring Pulse Secure VPN Client'
  /opt/pulsesecure/bin/jamCommand /importfile /home/user/Downloads/ThinClient/installs/EOTSS_Azure.pulsepreconfig
fi

# VMware Horizon View
echo 'Installing VMware Horizon View Client'
echo "y" | '/home/user/Downloads/ThinClient/installs/VMware-Horizon-Client.bundle' --console --required --stop-services

#rm '/home/user/Downloads/VMware-Horizon-Client.bundle' >/dev/null
#rm '/home/user/Downloads/ps-pulse-linux-installer.deb' >/dev/null
#rm '/home/user/Downloads/EOTSS_Azure.pulsepreconfig' >/dev/null
rm -f -R /home/user/Downloads/ThinClient/installs

read -n 1 -r -p "So far so good.  Press any key to reboot ..."

# Reboot
systemctl --no-wall reboot
exit
