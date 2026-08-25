# EDF Linux on Custom Board Starting from XSA
This is an attempt to run Xilinx EDF linux on a custom board with a ZynqMP-2CG. Commands are run on Ubuntu 24.04 LTS with Vivado 2026.1. The XSA file was previously tested with Petalinux 2025.2.

This document is in markdown format but can be easily converted to a shell script.

## Setup Environment

### Install mtools
```
sudo apt install mtools
```

### Temporarily disable apparmor
```
sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns
```

### Put Vivado 2026.1 tools in path
```
source /tools/Xilinx/2026.1/Vivado/settings64.sh;
```

### Cleanup
```
sudo rm -rf edf/ hw_project_sdt/
```

## Build EDF Linux

### Generate the sdt from the xsa
```
sdtgen -eval "set_dt_param -dir ./hw_project_sdt -xsa ../implement/results/top.xsa -user_dts ./system-user.dtsi; generate_sdt"
```

### Install latest repo tool
```
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
rm -rf ~/bin/repo 
mv repo ~/bin/
PATH=~/bin:$PATH
repo --help
```

### Init repo
```
mkdir edf
cd edf
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v26.06 -m default-edf.xml  ;#(for 2026.1)
repo sync
```

### Init build
```
unset TEMPLATECONF  ;# This removes some sticky settings.
source edf-init-build-env
```

### Parse the sdt files from Vivado to make a custom MACHINE
```
gen-machine-conf parse-sdt --machine-name custom-zynqmp-machine -c ./conf --hw-description ../../hw_project_sdt/ ;#(several minutes)
```

### Make a meta-user layer for extra bootargs
```
# add the meta-user layer
bitbake-layers create-layer meta-user
bitbake-layers add-layer meta-user
mkdir -p meta-user/recipes-core/systemd/
cp ../../systemd-bootconf-edf_%.bbappend meta-user/recipes-core/systemd/systemd-bootconf-edf_%.bbappend
```

### Build boot.bin
```
MACHINE=custom-zynqmp-machine bitbake xilinx-bootbin
```

### Make the wic disk image file (note different MACHINE)
```
MACHINE=amd-cortexa53-mali-common bitbake edf-linux-disk-image
```

### Add the boot.bin to the wic image
```
wic cp tmp/deploy/images/custom-zynqmp-machine/boot.bin tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1

wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic    ;# list partitions
wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1  ;# list boot partition
```

### Copy to SD card to use EDF (busybox) filesystem
This will install a Red Hat style root filesystem on partition 3. Most commands are replaced with busybox calls to reduce size.

WARNING: change /dev/sdX to the SD card device on your machine. 
```
sudo umount /dev/sdX*
sudo dd if=tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic of=/dev/sdX bs=4M status=progress
sudo sync
```

### Update the Linux boot files without touching the root filesystem
These commands preserve the root filesystem on partition 3 of the SD card. This is useful if you are running Debian or similar and don't want to lose changes.

WARNING: change /dev/sdX to the SD card device on your machine. 
```
# read the boot files from the ESP partition (1)
rm -rf ./new_esp_contents/
mkdir ./new_esp_contents/
wic cp tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1 ./new_esp_contents/

# substitute the UUID in the esp files
ROOTFS_PARTUUID="05274f5d-7cda-4d41-a240-822dc97e0158"
sed -i "s/root=PARTUUID=[^ ]*/root=PARTUUID=${ROOTFS_PARTUUID}/" new_esp_contents/loader/entries/edf-linux.conf

# copy the files to the ESP partition
udisksctl mount -b /dev/sdX1
mkdir ./old_esp_contents
sudo cp -rf /media/pedro/esp/* ./old_esp_contents/ # save the old files
sudo cp new_esp_contents/boot.bin  /media/pedro/esp/
sudo cp new_esp_contents/Image     /media/pedro/esp/
sudo cp new_esp_contents/loader/entries/edf-linux.conf /media/pedro/esp/loader/entries/
sync
udisksctl unmount -b /dev/sdX1
```

### Boot Hardware
Insert the SD card into the board and open a terminal on the PS USB Uart port. Serial settings are 115200, 8 bits, no parity, 1 stop bit.

Apply power and hit the reset button. You should see Linux booting and eventually get to a login prompt, username = amd-edf.





