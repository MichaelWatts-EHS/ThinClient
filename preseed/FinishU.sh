#!/bin/bash

echo "#!/bin/bash" >/tmp/FinishU.sh
echo "" >>/tmp/FinishU.sh
cat << EOF >> /tmp/FinishU.sh
rm -f /home/user/FinishU.sh
CWD="$(pwd)"
rm -f $HOME/Desktop/computer.desktop
rm -f $HOME/Desktop/network.desktop
rm -f $HOME/Desktop/trash-can.desktop
rm -f $HOME/Desktop/user-home.desktop
# ===========================



# ===========================
systemctl --no-wall reboot
exit
EOF


chmod a+x /tmp/FinishU.sh
/tmp/FinishU.sh
