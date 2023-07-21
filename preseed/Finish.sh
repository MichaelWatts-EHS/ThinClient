#!/bin/bash

### Variables
vpnclient_url="https://application.ivanti.com/SSG/Clients/ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb"
vdiclient_url="https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb"


# Configure the grub (boot) timeout
sed -i 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Configure auto-login
sed -i 's/.*autologin-user=.*/autologin-user=user/' /etc/lightdm/lightdm.conf
sed -i 's/.*autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Configure (disable) autostart and desktop apps
echo "Hidden=true" >> /etc/xdg/autostart/at-spi-dbus-bus.desktop
echo "Hidden=true" >> /etc/xdg/autostart/print-applet.desktop
echo "Hidden=true" >> /etc/xdg/autostart/pulseaudio.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-qlipper-autostart.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-xscreensaver-autostart.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-hibernate.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-leave.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-lockscreen.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-logout.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-reboot.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-suspend.desktop
sed -i 's/.*Exec=.*/Exec=systemctl poweroff --quiet/' /usr/share/applications/lxqt-shutdown.desktop
sed -i 's/.*Categories=.*/Categories=System;TextEditor;/' /usr/share/applications/featherpad.desktop
sed -i 's/.*Categories=.*/Categories=FileManager;System;Core;Qt;/' /usr/share/applications/pcmanfm-qt.desktop
wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/panel.conf -O /etc/xdg/lxqt/panel.conf
cd /usr/share/applications
rm -f lximage-qt.desktop
rm -f lxqt-about.desktop
rm -f pavucontrol-qt.desktop
rm -f qlipper.desktop
rm -f qps.desktop
rm -f qterminal-drop.desktop
rm -f xarchiver.desktop
rm -f zutty.desktop



# Create the working directory if it doesn't exist
if [ ! -d /tmp/ThinClient/installs ]; then mkdir -p /tmp/ThinClient/installs; fi; cd /tmp/ThinClient/installs

### Download required install files
vpnconfig_file=EOTSS_Azure.pulsepreconfig
if [ -f /cdrom/preseed/$vpnconfig_file ]; then
  cp /cdrom/preseed/$vpnconfig_file ./$vpnconfig_file
else
  vpnconfig_url="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/EOTSS_Azure.pulsepreconfig"
  wget $vpnconfig_url -O $vpnconfig_file
fi

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

# Make them all executable
chmod -R a+x /tmp/ThinClient/installs

### Installs

# VPN Client
if [ ! -f /opt/pulsesecure/bin/pulseUI ]; then
  apt install ./$vpnclient_file -y
fi
if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then
  /opt/pulsesecure/bin/setup_cef.sh install
fi
if [ -f /tmp/ThinClient/installs/EOTSS_Azure.pulsepreconfig ]; then
  /opt/pulsesecure/bin/jamCommand /importfile /tmp/ThinClient/installs/EOTSS_Azure.pulsepreconfig
fi
sed -i 's/.*Categories=.*/Categories=Application;Network;/' /usr/share/applications/pulse.desktop



# VMware Horizon View Client
apt install libudev0 -y
apt install ./$vdiclient_file -y
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
sed -i 's/.*Exec=.*/Exec=vmware-view --fullscreen/' /usr/share/applications/vmware-view.desktop
cp /usr/share/applications/vmware-view.desktop /etc/xdg/autostart/vmware-view.desktop


# Prep the final step
finishU_file=FinishU.sh
if [ -f /cdrom/preseed/$finishU_file ]; then
  cp /cdrom/preseed/$finishU_file /home/user/$finishU_file
else
  wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/FinishU.sh -O /home/user/$finishU_file
fi
chmod a+x /home/user/$finishU_file

#cat << EOF >> /etc/xdg/autostart/finishU.desktop
#[Desktop Entry]
#Exec=$HOME/FinishU.sh
#Name=finishU
#Type=Application
#Version=1.0
#EOF



# Cleanup
#apt -y remove zutty qlipper pulseaudio qps xarchiver #lximage-qt qterminal featherpad pcmanfm-qt
apt -y autoremove


exit


