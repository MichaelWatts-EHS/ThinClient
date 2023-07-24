#!/bin/bash

# Configure the grub (boot) timeout
sed -i 's/.*GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Configure auto-login
sed -i 's/.*autologin-user=.*/autologin-user=user/' /etc/lightdm/lightdm.conf
sed -i 's/.*autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Configure autostart apps
echo "Hidden=true" >> /etc/xdg/autostart/at-spi-dbus-bus.desktop
echo "Hidden=true" >> /etc/xdg/autostart/print-applet.desktop
echo "Hidden=true" >> /etc/xdg/autostart/pulseaudio.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-qlipper-autostart.desktop
echo "Hidden=true" >> /etc/xdg/autostart/lxqt-xscreensaver-autostart.desktop

# Configure 'leave' options
echo "NoDisplay=true" >> /usr/share/applications/lxqt-hibernate.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-leave.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-lockscreen.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-logout.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-reboot.desktop
echo "NoDisplay=true" >> /usr/share/applications/lxqt-suspend.desktop
sed -i 's/.*Exec=.*/Exec=systemctl poweroff --quiet/' /usr/share/applications/lxqt-shutdown.desktop

# Configure the 'Start Menu'
rm -f /usr/share/applications/lximage-qt.desktop
rm -f /usr/share/applications/lxqt-about.desktop
rm -f /usr/share/applications/pavucontrol-qt.desktop
rm -f /usr/share/applications/qlipper.desktop
rm -f /usr/share/applications/qps.desktop
rm -f /usr/share/applications/qterminal-drop.desktop
rm -f /usr/share/applications/xarchiver.desktop
rm -f /usr/share/applications/zutty.desktop
sed -i 's/.*Categories=.*/Categories=System;TextEditor;/' /usr/share/applications/featherpad.desktop
sed -i 's/.*Categories=.*/Categories=System;FileManager;/' /usr/share/applications/pcmanfm-qt.desktop
sed -i 's/.*Name=.*/Name=File Manager/' /usr/share/applications/pcmanfm-qt.desktop

### Download required install files
# Create the working directory if it doesn't exist
install_dir=/tmp/ThinClient
if [ ! -d $install_dir ]; then mkdir -p $install_dir; fi; cd $install_dir

# Get them from local media if we can
if [ -d /media/cdrom/preseed/ ]; then
  find /media/cdrom/preseed/ -name 'EOTSS_Azure.pulsepreconfig' | xargs cp -t $install_dir
  find /media/cdrom/preseed/ -name 'ps-pulse-linux-*.deb' | xargs cp -t $install_dir
  find /media/cdrom/preseed/ -name 'VMware-Horizon-Client-*.deb' | xargs cp -t $install_dir
elif [ -d /cdrom/preseed/ ]; then
  find /media/cdrom/preseed/ -name 'EOTSS_Azure.pulsepreconfig' | xargs cp -t $install_dir
  find /cdrom/preseed/ -name 'ps-pulse-linux-*.deb' | xargs cp -t $install_dir
  find /cdrom/preseed/ -name 'VMware-Horizon-Client-*.deb' | xargs cp -t $install_dir
else
  wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/EOTSS_Azure.pulsepreconfig
  wget https://application.ivanti.com/SSG/Clients/ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb
  wget https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
fi

# Make them trusted and install
chmod -R a+x $install_dir
find $install_dir/ -name '*.deb' | xargs apt -y install

### Configure the clients
# Pulse Secure VPN Client
sed -i 's/.*Categories=.*/Categories=Application;Network;/' /usr/share/applications/pulse.desktop
if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then /opt/pulsesecure/bin/setup_cef.sh install; fi
if [ -f $install_dir/EOTSS_Azure.pulsepreconfig ]; then /opt/pulsesecure/bin/jamCommand /importfile $install_dir/EOTSS_Azure.pulsepreconfig; fi

# VMware Horizon View Client
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

# Configure the 'Task Bar'
## ===================================
cat << EOF >> /etc/xdg/lxqt/panel.conf
[General]
iconTheme=Papirus-Dark
[kbindicator]
alignment=Right
type=kbindicator
[panel1]
plugins=mainmenu, spacer, quicklaunch, spacer2, taskbar, tray, networkmonitor, worldclock, spacer3, quicklaunch2
[quicklaunch]
alignment=Left
apps\1\desktop=/usr/share/applications/vmware-view.desktop
apps\2\desktop=/usr/share/applications/pulse.desktop
apps\size=2
type=quicklaunch
[quicklaunch2]
alignment=left
apps\1\desktop=/usr/share/applications/lxqt-shutdown.desktop
apps\size=1
type=quicklaunch
[spacer]
alignment=Left
type=spacer
[spacer2]
alignment=Left
type=spacer
[spacer3]
alignment=Left
type=spacer
[taskbar]
buttonWidth=200
raiseOnCurrentDesktop=true
[tray]
alignment=Right
type=tray
[networkmonitor]
alignment=Right
type=networkmonitor
[worldclock]
alignment=Right
type=worldclock
EOF
## ===================================

# Add RunOnce
cat << EOF >> /etc/xdg/autostart/RunOnce.desktop
[Desktop Entry]
Exec=/usr/bin/bash wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/FinishU.sh; chmod +x FinishU.sh; . FinishU.sh
Name=RunOnce
Type=Application
Version=1.0
EOF















# Finish and exit
#wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/Finish2.sh -O /home/user/Finish2.sh
exit

