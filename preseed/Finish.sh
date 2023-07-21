#!/bin/bash

# Configure the grub (boot) timeout
sed -i 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Configure auto-login
sed -i 's/.*autologin-user=.*/autologin-user=user/' /etc/lightdm/lightdm.conf
sed -i 's/.*autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Configure (disable) autostart apps
echo "Hidden=true" >> /etc/xdg/autostart/at-spi-dbus-bus.desktop
echo "Hidden=true" >> /etc/xdg/autostart/print-applet.desktop
echo "Hidden=true" >> /etc/xdg/autostart/pulseaudio.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-qlipper-autostart.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-xscreensaver-autostart.desktop

# Set the hostname
#hostnamectl set-hostname thinclient

### Downloads
# Make the working directory if it doesn't exist
if [ ! -d /tmp/ThinClient/installs ]; then mkdir -p /tmp/ThinClient/installs; fi

# Download the required files
source_file="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/installs/EOTSS_Azure.pulsepreconfig"
target_file="/tmp/ThinClient/installs/EOTSS_Azure.pulsepreconfig"
wget -q $source_file -O $target_file

source_file="https://application.ivanti.com/SSG/Clients/ps-pulse-linux-installer.deb"
target_file="/tmp/ThinClient/installs/ps-pulse-linux-installer.deb"
wget -q $source_file -O $target_file

source_file="https://download3.vmware.com/software/CART24FQ1_LIN64_2303/VMware-Horizon-Client.bundle"
target_file="/tmp/ThinClient/installs/VMware-Horizon-Client.bundle"
wget -q $source_file -O $target_file

# Make them exectuable
chmod -R a+x /tmp/ThinClient/installs

### Installs
# Install Pulse VPN Client
if [ ! -f /opt/pulsesecure/bin/pulseUI ]; then
  apt -y install '/tmp/ThinClient/installs/ps-pulse-linux-installer.deb'
fi
if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then
  /opt/pulsesecure/bin/setup_cef.sh install
fi
if [ -f /opt/pulsesecure/bin/pulseUI ]; then
  /opt/pulsesecure/bin/jamCommand /importfile /tmp/ThinClient/installs/EOTSS_Azure.pulsepreconfig
fi

# Install the VMware Horizon View Client
echo "y" | '/tmp/ThinClient/installs/VMware-Horizon-Client.bundle' --console --required --stop-services

# Configure the Horizon Client
if [ ! -d /etc/vmware ]; then mkdir -p /etc/vmware; fi
cat << EOF >> /etc/vmware/view-default-config
view.autoConnectBroker="vdi.ehs.govt.state.ma.us"
view.defaultBroker="vdi.ehs.govt.state.ma.us"
view.defaultDesktop="Standard Desktop"
view.hideClientAfterLaunchSession=TRUE
view.autoConnectDesktop=TRUE
view.autoHideToolbar=TRUE
view.fullScreen=TRUE
view.nomenubar=TRUE
view.once=TRUE
view.defaultDomain=EHS
view.usbAutoConnectOnInsert=TRUE
EOF
cat << EOF >> /etc/vmware/view-mandatory-config
view.allowautoConnectBroker=FALSE
view.allowdefaultBroker=FALSE
EOF


exit


