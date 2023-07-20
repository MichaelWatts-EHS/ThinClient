#!/bin/bash

# This all needs sudo

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
cat << EOF >> /home/user/.config/autostart/finish.desktop
[Desktop Entry]
Exec=/usr/bin/bash wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish1.sh; chmod +x Finish1.sh; . Finish1.sh
Name=Finish
Type=Application
Version=1.0
EOF

# Configure the user desktop
rm -f /home/user/Desktop/computer.desktop
rm -f /home/user/Desktop/network.desktop
rm -f /home/user/Desktop/trash-can.desktop
rm -f /home/user/Desktop/user-home.desktop


#/home/user/.config/autostart/finish.desktop
#/etc/xdg/autostart/finish.desktop
#grub-mkconfig -o /boot/grub/grub.cfg 2>&1 </dev/null &
#wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish1.sh; chmod +x Finish1.sh; . Finish1.sh
#wget -qO - https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish.sh | bash
