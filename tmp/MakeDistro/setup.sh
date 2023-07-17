#!/bin/bash

# Install pre-reqs
apt -y install squashfs-tools mkisofs

chmod -R +x /tmp/MakeDistro
/tmp/MakeDistro/tools/isolinux.bin.update
/tmp/MakeDistro/build
