# EDF Linux on Custom Board Starting from XSA

## Build EDF Linux

### Put Vivado 2026.1 tools in path
source /tools/Xilinx/2026.1/Vivado/settings64.sh; source /tools/Xilinx/2026.1/Vitis/settings64.sh;

### Generate the sdt from the xsa
sdtgen -eval "set_dt_param -debug enable -zocl enable -dir ./hw_project_sdt -xsa ../implement/results/top.xsa; generate_sdt"

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
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v25.11 -m default-edf.xml  ;#(for 2025.2)
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
gen-machine-conf --hw-description ../../hw_project_sdt/ parse-sdt

### Build Linux
MACHINE=xlnx-zynqmp bitbake xilinx-bootbin

### make the wic disk image file
MACHINE=amd-cortexa53-mali-common bitbake edf-linux-disk-image

wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic ;# list partitions
wic ls tmp/deploy/images/amd-cortexa53-mali-common/edf-linux-disk-image-amd-cortexa53-mali-common.rootfs.wic:1 ;# list boot partition





## Installing a Debian root filesystem using debootstrap (possibly obsolete with EDF)
Follow instructions here to confgure the root file system: https://akhileshmoghe.github.io/_post/linux/debian_minimal_rootfs

### The most important commands listed for convenience. 

    sudo apt install qemu-user-static
    sudo apt install debootstrap

    sudo debootstrap --arch=arm64 --foreign bookworm debianMinimalRootFS
    sudo cp /usr/bin/qemu-aarch64-static ./debianMinimalRootFS/usr/bin/
    sudo cp /etc/resolv.conf ./debianMinimalRootFS/etc/resolv.conf
    sudo chroot ./debianMinimalRootFS
    export LANG=C

    /debootstrap/debootstrap --second-stage ;#(this takes several minutes)

Add these sources to /etc/apt/sources.list

deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware non-free

### Do some more file system configuration.

    apt update
    apt install locales dialog
    dpkg-reconfigure locales
    apt install vim openssh-server ntpdate sudo ifupdown net-tools udev iputils-ping wget dosfstools unzip binutils libatomic1
    passwd
    adduser myuser
    usermod -aG sudo myuser
    usermod --shell /bin/bash <user-name>

    Add to /etc/network/interfaces

    auto eth0
    iface eth0 inet dhcp

    Exit chroot.

exit

### Write filesystem to SD card.

sudo cp --recursive --preserve ./debianMinimalRootFS/* /media/pedro/rootfs/; sync

