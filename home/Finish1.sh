#!/bin/bash

# This part should NOT be run as root
# Get it & Run it (in terminal)
#wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish1.sh; chmod a+x Finish1.sh; . Finish1.sh

CWD="$(pwd)"
UHOME="/home/user"
DLPATH="${UHOME}/Downloads"
TCFILES="${DLPATH}/ThinClient"
cd $DLPATH
echo "Downloading required files to $DLPATH"

# Get ThinClient files from github
echo "   + Configuration files"
git clone --quiet https://github.com/MichaelWatts-EHS/ThinClient.git ThinClient
rm ThinClient/README.md; rm -f -R ThinClient/.git; rm -f -R ThinClient/preseed; rm -f -R ThinClient/home/Finish1.sh
mv ThinClient/home/Finish2.sh ThinClient
chmod a+x ThinClient/Finish2.sh

# Get the Pulse VPN Client
target_path="/home/user/Downloads/ThinClient/installs"
target_name="ps-pulse-linux-installer.deb"
source_path="https://application.ivanti.com/SSG/Clients"
source_name="ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  echo "   + Pulse VPN Client"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

# Get the Pulse VPN Configuration
target_path="/home/user/Downloads/ThinClient/installs"
target_name="EOTSS_Azure.pulsepreconfig"
source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/user/Downloads"
source_name="EOTSS_Azure.pulsepreconfig"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  echo "   + VPN Configuration"
  wget -q $source_file -O $target_file
fi

# Get the VMware Horizon Client
target_path="/home/user/Downloads/ThinClient/installs"
target_name="VMware-Horizon-Client.bundle"
source_path="https://download3.vmware.com/software/CART24FQ1_LIN64_2303"
source_name="VMware-Horizon-Client-2303-8.9.0-21435420.x64.bundle"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  echo "   + VMware Horizon Client"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

# Get the Finish2.sh script
target_path="/home/user/Downloads/ThinClient"
target_name="Finish2.sh"
source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home"
source_name="Finish2.sh"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  echo "   + $target_name"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

echo "Applying user configuration files"
rm -f /home/user/Desktop/computer.desktop
rm -f /home/user/Desktop/network.desktop
rm -f /home/user/Desktop/trash-can.desktop
rm -f /home/user/Desktop/user-home.desktop
cp -f -R ThinClient/home/user /home
rm -f -R ThinClient/home

SCRIPT_PATH="/home/user/Downloads/ThinClient/Finish2.sh"
#read -n 1 -r -p "So far so good.  Press any key to continue..."
#echo $SCRIPT_PATH
echo "password" | sudo -S bash $SCRIPT_PATH
