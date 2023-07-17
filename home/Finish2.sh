#!/bin/bash

#echo "Running Finish2"

# Cleanup the calling script
rm -f "/home/user/Finish1.sh"

#if [ ! -f "/home/user/Finish1.sh" ]; then
#  rm -f "/home/user/Finish1.sh"
#fi

echo " "
echo "Applying system configuration files"
cp -f -R /home/user/Downloads/ThinClient/etc /
rm -f -R /home/user/Downloads/ThinClient/etc

echo "Setting grub timeout"
sed -i 's/"GRUB_TIMEOUT=5"/"GRUB_TIMEOUT=0"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 </dev/null

echo "Setting hostname"
hostnamectl set-hostname thinclient 2>&1 </dev/null

echo "Updating installed packages"
apt update && apt upgrade 2>&1 </dev/null

# Install Pulse VPN Client
#if [ ! -f /opt/pulsesecure/bin/pulseUI ]; then
#  echo 'Installing Pulse Secure VPN Client'
#  apt -y install '/home/user/Downloads/ThinClient/installs/ps-pulse-linux-installer.deb'
#fi

#if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then
#  echo 'Installing Cef Runtime'
#  /opt/pulsesecure/bin/setup_cef.sh install
#fi

# Configure Pulse Client
#if [ -f /opt/pulsesecure/bin/pulseUI ]; then
#  echo 'Configuring Pulse Secure VPN Client'
#  /opt/pulsesecure/bin/jamCommand /importfile /home/user/Downloads/ThinClient/installs/EOTSS_Azure.pulsepreconfig
#fi

# VMware Horizon View
#echo 'Installing VMware Horizon View Client'
#echo "y" | '/home/user/Downloads/ThinClient/installs/VMware-Horizon-Client.bundle' --console --required --stop-services

#rm '/home/user/Downloads/VMware-Horizon-Client.bundle' >/dev/null
#rm '/home/user/Downloads/ps-pulse-linux-installer.deb' >/dev/null
#rm '/home/user/Downloads/EOTSS_Azure.pulsepreconfig' >/dev/null
#rm -f -R /home/user/Downloads/ThinClient/installs

#apt -y remove wget git zutty qlipper pulseaudio featherpad pcmanfm-qt qps lximage-qt xarchiver qterminal
#apt -y autoremove

# Reboot
#systemctl --no-wall reboot
#exit
