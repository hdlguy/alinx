# EDF Linux on Custom Board Starting from XSA
This is an attempt to run Xilinx EDF linux on a custom board with a ZynqMP-2CG. Commands are run on Ubuntu 24.04 LTS with Vivado 2026.1.  The XSA file from an tested Vivado project is used for all hardware settings.

## Build EDF Linux

### Put Vivado 2026.1 tools in path
source /tools/Xilinx/2026.1/Vivado/settings64.sh;

### Generate the sdt from the xsa
sdtgen -eval "set_dt_param -dir ./hw_project_sdt -xsa ../implement/results/top.xsa; generate_sdt"

## Install latest repo tool
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
rm -rf ~/bin/repo 
mv repo ~/bin/
PATH=~/bin:$PATH
repo --help

### Init repo
mkdir edf
cd edf
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v26.06 -m default-edf.xml  ;#(for 2026.1)
repo sync

### Install mtools
sudo apt install mtools

### Init build
unset TEMPLATECONF
source edf-init-build-env

### Temporarily disable apparmor
sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns

### parse the sdt files from Vivado
gen-machine-conf parse-sdt --machine-name custom-zynqmp-machine -c ./conf --hw-description ../../hw_project_sdt/ ;#(several minutes)

### Build boot.bin
MACHINE=custom-zynqmp-machine bitbake xilinx-bootbin

### make the wic disk image file (note different MACHINE) (maybe mali is not on 2CG)
//MACHINE=amd-cortexa53-mali-common bitbake edf-linux-disk-image
MACHINE=amd-cortexa53-common bitbake edf-linux-disk-image

### Add the boot.bin to the wic image
wic cp tmp/deploy/images/custom-zynqmp-machine/boot.bin tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1

wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic ;# list partitions
wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1 ;# list boot partition

### Copy to SD card
This command fails because it cannot access /dev/sda. Use balenaEtcher.
wic write tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic /dev/sda






