#!/bin/bash

# This part should NOT be run as root

# Cleanup the desktop
rm -f /home/user/Desktop/computer.desktop
rm -f /home/user/Desktop/network.desktop
rm -f /home/user/Desktop/trash-can.desktop
rm -f /home/user/Desktop/user-home.desktop
cd /home/user/Downloads
echo "Downloading required files"

# Get it & Run it (in terminal)
#wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/Finish1.sh; chmod a+x Finish1.sh; sh Finish1.sh

# Get ThinClient files from github
echo "   + Configuration files"
git clone --quiet https://github.com/MichaelWatts-EHS/ThinClient.git ThinClient > /dev/null
rm ThinClient/README.md
rm -f -R ThinClient/.git
rm -f -R ThinClient/preseed
#mkdir ThinClient/installs

# Get the Pulse VPN Client
echo "   + Pulse VPN Client"
target_path="/home/user/Downloads/ThinClient/installs"
target_name="ps-pulse-linux-installer.deb"
source_path="https://application.ivanti.com/SSG/Clients"
source_name="ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  #echo "$target_name not found. Downloading"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

# Get the Pulse VPN Configuration
#target_path="/home/user/Downloads/ThinClient/installs"
#target_name="EOTSS_Azure.pulsepreconfig"
#source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/user/Downloads"
#source_name="EOTSS_Azure.pulsepreconfig"
#target_file="${target_path}/${target_name}"
#source_file="${source_path}/${source_name}"
#if [ ! -f $target_file ]; then
#  #echo "$target_name not found. Downloading"
#  wget -q $source_file -O $target_file
#fi
#chmod +x $target_file

# Get the VMware Horizon Client
echo "   + VMware Horizon Client"
target_path="/home/user/Downloads/ThinClient/installs"
target_name="VMware-Horizon-Client.bundle"
source_path="https://download3.vmware.com/software/CART24FQ1_LIN64_2303"
source_name="VMware-Horizon-Client-2303-8.9.0-21435420.x64.bundle"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  #echo "$target_name not found. Downloading"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

# Get the Finish2.sh script
#target_path="/home/user/Downloads/ThinClient/home"
#target_name="Finish2.sh"
#source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home"
#source_name="Finish2.sh"
#target_file="${target_path}/${target_name}"
#source_file="${source_path}/${source_name}"
#if [ ! -f $target_file ]; then
#  #echo "$target_name not found. Downloading"
#  wget -q $source_file -O $target_file
#fi
#chmod +x $target_file

echo "Applying configuration files"
cp -f -R ThinClient/home/user /home
rm -f -R ThinClient/home/user

#read -n1 -r -p "So far so good.  Press any key to continue..."
SCRIPT_PATH="/home/user/Downloads/ThinClient/home/Finish2.sh"
#echo "password" | sudo -S $SCRIPT_PATH >/dev/null
