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

# Configure the 'Task Bar'
wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/panel.conf -O /etc/xdg/lxqt/panel2.conf

wget https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/preseed/Finish2.sh -O /home/user/Finish2.sh
exit

