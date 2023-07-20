#!/bin/bash

# Configure auto-login
sed -i 's/.*autologin-user=.*/autologin-user=user/' /etc/lightdm/lightdm.conf
sed -i 's/.*autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Configure the grub (boot) timeout
sed -i 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub

# Configure autostart apps
"Hidden=true" | tee -a /etc/xdg/autostart/at-spi-dbus-bus.desktop
"Hidden=true" | tee -a /etc/xdg/autostart/print-applet.desktop
"Hidden=true" | tee -a /etc/xdg/autostart/pulseaudio.desktop
"Hidden=true" | tee -a /etc/xdg/autostart/lxqt-qlipper-autostart.desktop
"Hidden=true" | tee -a /etc/xdg/autostart/lxqt-xscreensaver-autostart.desktop

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


#cat << EOF >> /home/user/.config/autostart/finish.desktop
#[Desktop Entry]
#Exec=/usr/bin/bash wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish1.sh; chmod +x Finish1.sh; . Finish1.sh
#Name=Finish
#Type=Application
#Version=1.0
#EOF
