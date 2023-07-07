#!/bin/bash

# This part should NOT be run as root

# Get it & Run it (in terminal)
# wget -q https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/user/Desktop/Finish1.sh -O /home/user/Desktop/Finish1.sh; chmod a+x /home/user/Desktop/Finish1.sh; /home/user/Desktop/Finish1.sh

cd /home/user/Downloads
echo "Downloading required files"
git clone --quiet https://github.com/MichaelWatts-EHS/ThinClient.git ThinClient > /dev/null
rm ThinClient/README.md
rm -f -R ThinClient/.git
rm -f -R ThinClient/preseed

cp -f -R ThinClient/home/user/.config /home/user
cp -f -R ThinClient/home/user/.local /home/user
cp -f -R ThinClient/home/user/Desktop /home/user
cp -f -R ThinClient/home/user/Downloads /home/user
rm -f -R ThinClient/home

# Get the Pulse VPN Client
target_path="/home/user/Downloads"
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
target_path="/home/user/Downloads"
target_name="EOTSS_Azure.pulsepreconfig"
source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/user/Downloads"
source_name="EOTSS_Azure.pulsepreconfig"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  #echo "$target_name not found. Downloading"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

# Get the VMware Horizon Client
target_path="/home/user/Downloads"
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
target_path="/home/user/Downloads"
target_name="Finish2.sh"
source_path="https://raw.githubusercontent.com/MichaelWatts-EHS/ThinClient/main/home/user/Downloads"
source_name="Finish2.sh"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  #echo "$target_name not found. Downloading"
  wget -q $source_file -O $target_file
fi
chmod +x $target_file

read -n1 -r -p "So far so good.  Press any key to continue..."
SCRIPT_PATH="/home/user/Downloads/Finish2.sh"
echo "password" | sudo -S $SCRIPT_PATH #>/dev/null
