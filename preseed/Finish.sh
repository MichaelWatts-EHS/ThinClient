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
#  wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/EOTSS_Azure.pulsepreconfig
  echo "Downloading clients"
  wget https://application.ivanti.com/SSG/Clients/ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb
  wget https://download3.vmware.com/software/CART24FQ2_LIN64_DebPkg_2306/VMware-Horizon-Client-2306-8.10.0-21964631.x64.deb
fi

# Make them trusted and install
chmod -R a+x $install_dir
echo "Installing Clients"
find $install_dir/ -name '*.deb' | xargs apt -y install
if [ ! -f /opt/pulsesecure/lib/cefRuntime/Release/libcef.so ]; then /opt/pulsesecure/bin/setup_cef.sh install; fi


if [ ! -f $install_dir/EOTSS_Azure.pulsepreconfig ]; then
cat << EOF >> $install_dir/EOTSS_Azure.pulsepreconfig
schema version {
    version: "1"
}
machine settings {
    version: "5"
    guid: "1b8fea84-b452-4426-8e9a-bd7196a489cd"
    connection-source: "preconfig"
    server-id: "43aa2c42-bd61-4a9a-b045-09028b38d91f"
    connection-set-owner: "itdchearlps"
    connection-set-name: "Comm_of_Mass-Employee"
    connection-set-last-modified: "2021-06-16 19:40:01 UTC"
    connection-set-download-host: "itdchearlps:itdchearlps01"
    allow-save: "false"
    user-connection: "false"
    lock-down: "false"
    splashscreen-display: "true"
    dynamic-trust: "true"
    dynamic-connection: "true"
    eap-fragment-size: "1400"
    captive-portal-detection: "false"
    embedded-browser-saml: "true"
    enable-browser: "false"
    embedded-cef-browser-saml: "false"
    FIPSClient: "false"
    clear-smart-card-pin-cache: "false"
    block-traffic-on-vpn-disconnect: "false"
    wireless-suppression: "false"
    lockdown-exceptions-configured: "false"
}
ive "1bb6d4ba-d16b-4d2a-8894-fb9b39881809" {
    friendly-name: "Commonwealth_VPN"
    version: "10"
    guid: "1bb6d4ba-d16b-4d2a-8894-fb9b39881809"
    client-certificate-selection-rule: "AUTO"
    client-certificate-matching-rule-smartcard-logon-enabled: "true"
    client-certificate-matching-rule-eku-oid: ""
    client-certificate-matching-rule-eku-text: ""
    server-id: "43aa2c42-bd61-4a9a-b045-09028b38d91f"
    connection-source: "preconfig"
    uri-list: "https://mavpn.vpn.state.ma.us/azure/"
    uri: "https://mavpn.vpn.state.ma.us/azure/"
    connection-policy-override: "true"
    connection-lock-down: "false"
    enable-stealth-mode: "false"
    show-stealth-connection: "false"
    use-for-connect: "true"
    use-for-secure-meetings: "false"
    this-server: "false"
    uri-list-use-last-connected: "false"
    uri-list-randomize: "false"
    sso-cached-credential: "false"
    connection-identity: "user"
    connection-policy: "manual"
    client-certificate-location-system: "false"
    reconnect-at-session-timeout: "true"
}
EOF
fi

### Configure the clients
# Pulse Secure VPN Client
sed -i 's/.*Categories=.*/Categories=Application;Network;/' /usr/share/applications/pulse.desktop
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

cat << EOF >> /home/user/FinishU.sh
#!/bin/bash
rm -f $HOME/Desktop/computer.desktop
rm -f $HOME/Desktop/network.desktop
rm -f $HOME/Desktop/trash-can.desktop
rm -f $HOME/Desktop/user-home.desktop
rm -f /etc/xdg/autostart/RunOnce.desktop
rm $0
#systemctl --no-wall reboot
exit
EOF
chmod a+rwx /home/user/FinishU.sh

# Add RunOnce
cat << EOF >> /etc/xdg/autostart/RunOnce.desktop
[Desktop Entry]
Exec=/usr/bin/bash /home/user/FinishU.sh
Name=RunOnce
Type=Application
Version=1.0
EOF
chmod -R 777 /etc/xdg/autostart















# Finish and exit
exit

