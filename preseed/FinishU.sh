#!/bin/bash

rm -f $HOME/Desktop/computer.desktop
rm -f $HOME/Desktop/network.desktop
rm -f $HOME/Desktop/trash-can.desktop
rm -f $HOME/Desktop/user-home.desktop
rm -f /etc/xdg/autostart/RunOnce.desktop
rm $0
systemctl --no-wall reboot
exit
