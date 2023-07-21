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

# Create the working directory if it doesn't exist
if [ ! -d /tmp/ThinClient/installs ]; then mkdir -p /tmp/ThinClient/installs; fi; cd /tmp/ThinClient/installs

### Downloads
vpnclient_url="https://application.ivanti.com/SSG/Clients/ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb"
vdiclient_url="https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb"

vpnclient_file=ps-pulse-linux-installer.deb
if [ -f /cdrom/preseed/$vpnclient_file ]; then
  cp /cdrom/preseed/$vpnclient_file ./$vpnclient_file
else
  wget $vpnclient_url -O $vpnclient_file
fi

vdiclient_file=VMware-Horizon-Client.deb
if [ -f /cdrom/preseed/$vdiclient_file ]; then
  cp /cdrom/preseed/$vdiclient_file ./$vdiclient_file
else
  wget $vdiclient_url -O $vdiclient_file
fi



### Installs
chmod -R a+x /tmp/ThinClient/installs

# VPN Client
if [ ! -f /opt/pulsesecure/bin/pulseUI ]; then
  apt install ./$vpnclient_file -y
fi
if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then
  /opt/pulsesecure/bin/setup_cef.sh install
fi


# VMware Horizon View Client
apt install libudev0 -y
apt install ./$vdiclient_file -y
#echo "y" | ./$vdiclient_file --console --required --stop-services
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


