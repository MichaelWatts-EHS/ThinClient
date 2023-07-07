#!/bin/bash

# WIP
git clone https://github.com/MichaelWatts-EHS/ThinClient.git /home/user/Downloads/ThinClient
cp -f -R /home/user/Downloads/ThinClient/home/user/.config /home/user
cp -f -R /home/user/Downloads/ThinClient/home/user/.local /home/user

# These binaries are too big for github so we'll get them from the manufacturers

# Get the Pulse VPN Client
target_path="/home/user/Downloads"
target_name="ps-pulse-linux-installer.deb"
source_path="https://application.ivanti.com/SSG/Clients"
source_name="ps-pulse-linux-9.1r11.4-b8575-64-bit-installer.deb"
target_file="${target_path}/${target_name}"
source_file="${source_path}/${source_name}"
if [ ! -f $target_file ]; then
  echo "$target_name not found. Downloading"
  wget $source_file -O $target_file
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
  echo "$target_name not found. Downloading"
  wget $source_file -O $target_file
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
  echo "$target_name not found. Downloading"
  wget $source_file -O $target_file
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
  echo "$target_name not found. Downloading"
  wget $source_file -O $target_file
fi
chmod +x $target_file

# Run Finish2.sh
"/home/user/Downloads/Finish2.sh" | sudo bash




