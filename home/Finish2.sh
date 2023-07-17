#!/bin/bash

# Cleanup the calling script
rm -f "/home/user/Finish1.sh"

echo " "
echo "Applying system configuration files"
cp -f -R /home/user/Downloads/ThinClient/etc /
rm -f -R /home/user/Downloads/ThinClient/etc

echo "Setting grub timeout"
sed -i 's/"GRUB_TIMEOUT=5"/"GRUB_TIMEOUT=0"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg 2>&1 </dev/null &

echo "Setting hostname"
hostnamectl set-hostname thinclient 2>&1 </dev/null &

echo "Updating installed packages"
apt update && apt -y upgrade 2>&1 </dev/null

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
#rm '/home/user/Downloads/ps-pulse-linux-installer.deb'
#rm '/home/user/Downloads/EOTSS_Azure.pulsepreconfig'

# VMware Horizon View
echo 'Installing VMware Horizon View Client'
echo "y" | '/home/user/Downloads/ThinClient/installs/VMware-Horizon-Client.bundle' --console --required --stop-services
#rm '/home/user/Downloads/VMware-Horizon-Client.bundle'

# Cleanup
rm -f -R /home/user/Downloads/ThinClient/installs
apt -y remove wget zutty qlipper pulseaudio qps xarchiver #lximage-qt qterminal featherpad pcmanfm-qt git
apt -y autoremove


# Install pre-reqs for Linux-Live kit
apt -y install squashfs-tools mkisofs
git clone --quiet https://github.com/Tomas-M/linux-live.git /tmp/Make-Live
chmod -R +x /tmp/Make-Live
sed -i 's/.*LIVEKITNAME=.*/LIVEKITNAME="MyLiveLinux"/' /tmp/Make-Live/config






# Reboot
#systemctl --no-wall reboot
#exit
