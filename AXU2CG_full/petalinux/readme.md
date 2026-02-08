# Petalinux (2025.1) on ZynqMP

# Download and uncompress sstate artifacts
I find that the compile time download from petalinux.xilinx.com is just unreliable. The trick is to have those files local. Then, in petalinux-config we point to the local files.

https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html
    * Downloads (TAR/GZIP - 61.27 GB) 
    * sstate_aarch64 (TAR/GZIP - 33.95 GB) 

## Convert XSA to SDT
/tools/Xilinx/2025.1/Vitis/bin/sdtgen -eval "set_dt_param -dir ./sdt -xsa ../implement/results/top.xsa -user_dts ./system-user.dtsi; generate_sdt;"

### Create Petalinux project
petalinux-create project --template zynqMP --name proj1
cd proj1

### configure project from hardware
petalinux-config --get-hw-description=../sdt/

    * Image Packaging Configuration -> Root Filesystem Type -> EXT4                         (if you want a persistent rootfs)
    * Image Packaging Configuration -> Device node of SD device -> mmcblk1p2                (if you have the eMMC device enabled in Vivado IPI)
    * Subsystem Auto Hardware Settings -> SD/SDIO Settings -> Primary SD/SDIO -> sdhci1     (if you have the eMMC device enabled in Vivado IPI)
    * DTG Settings -> Kernel Bootargs -> manual bootargs -> earlycon console=ttyPS0,115200 root=/dev/mmcblk1p2 rw rootwait clk_ignore_unused (mmc 1, rw, clk_ignore_unused)

    * Yocto Settings -> Local sstate feeds settings -> local sstate feeds url ->    file://~/Downloads/xilinx/petalinux/sstate_download_2025_1/aarch64/
    * Yocto Settings -> Add pre-mirror url ->                                       file://~/Downloads/xilinx/petalinux/mirror_download_2025_1/downloads/

    * save and exit

### Build the bootloader
petalinux-build -c bootloader -x distclean

### Configure the kernel
petalinux-config -c kernel

    * Device Drivers -> nvme -> nvme as block device.
    * save and exit

### Build
petalinux-build

### Package 
petalinux-package --force --boot --fsbl --pmufw --u-boot --fpga 

    * Use this to just update the bitfile.

petalinux-package --force --boot --fsbl --pmufw --u-boot --fpga ../../implement/results/top.bit

### Copy to SD Card
cp images/linux/BOOT.BIN /media/pedro/BOOT/; cp images/linux/image.ub /media/pedro/BOOT/; cp images/linux/boot.scr /media/pedro/BOOT/; sync




#--------------------------------

# Petalinux (2024.2) on ZynqMP

## Petalinux Build instructions

    * open https://petalinux.xilinx.com/ in a web browser. this makes sure we have a good connection to the yocto downloads.

### Convert the vivado .xsa file to the system device tree files that Petalinux 2024.x wants.

/tools/Xilinx/Vitis/2024.2/bin/xsct ./gensdt.tcl


### Create Petalinux project

petalinux-create project --template zynqMP --name proj1

### configure project from hardware

cd proj1

petalinux-config --get-hw-description=../sdt/

    * Image Packaging Configuration -> Root Filesystem Type -> EXT4                         (if you want a persistent rootfs)
    * Image Packaging Configuration -> Device node of SD device -> mmcblk1p2                (if you have the eMMC device enabled in Vivado IPI)
    * Subsystem Auto Hardware Settings -> SD/SDIO Settings -> Primary SD/SDIO -> sdhci1   (if you have the eMMC device enabled in Vivado IPI)
    * DTG Settings -> Kernel Bootargs -> manual bootargs -> earlycon console=ttyPS0,115200 root=/dev/mmcblk1p2 rw rootwait clk_ignore_unused (mmc 1, rw, clk_ignore_unused)
    * save and exit

### Build the bootloader

petalinux-build -c bootloader -x distclean

### Configure the kernel

petalinux-config -c kernel

    * Device Drivers -> nvme -> nvme as block device.
    * save and exit

### Build

petalinux-build

    * NOTE: frequently petalinux-build generates error messages. Just rerun the previous three commands to resolve that. (Who knows why?)

### Package 

petalinux-package --force --boot --fsbl --pmufw --u-boot --fpga 

    * Use this to just update the bitfile.

petalinux-package --force --boot --fsbl --pmufw --u-boot --fpga ../../implement/results/top.bit


### Copy to SD Card

cp images/linux/BOOT.BIN /media/pedro/BOOT/; cp images/linux/image.ub /media/pedro/BOOT/; cp images/linux/boot.scr /media/pedro/BOOT/; sync

cd ..



# Petalinux v2021.2 Build instructions

    * open https://petalinux.xilinx.com/ in a web browser. this makes sure we have a good connection to the yocto downloads.

petalinux-create --force --type project --template zynqMP --name proj1

cp system-user.dtsi proj1/project-spec/meta-user/recipes-bsp/device-tree/files/

cd proj1

petalinux-config --get-hw-description=../../implement/results/

    * Yocto Settings -> Add pre-mirror url -> change http: to https:
    * Yocto Settings -> Network State Feeds url -> change http: to https:
    * Image Packaging Configuration -> EXT4                                                 (if you want a persistent rootfs)
    * Image Packaging Configuration -> Device node of SD device -> mmcblk1p2                (if you have the eMMC device enabled in Vivado IPI)
    * Subsystem Auto Hardware Settings -> SD/SDIO Settings -> Primary SD/SDIO -> psu_sd_1   (if you have the eMMC device enabled in Vivado IPI)
    * save and exit

petalinux-build -c bootloader -x distclean

petalinux-config -c kernel

    * Device Drivers -> nvme -> nvme as block device.
    * Device Drivers -> Phy Subsystem -> PHY Core.
    * Device Drivers -> Phy Subsystem -> Xilinx ZynqMP PHY driver.
    * save and exit

petalinux-build

    * NOTE: frequently petalinux-build generates error messages. Just rerun the previous three commands to resolve that. (Who knows why?)

petalinux-package --force --boot --u-boot --kernel --offset 0xF40000 --fpga ../../implement/results/top.bit


cp images/linux/BOOT.BIN /media/pedro/BOOT/; cp images/linux/image.ub /media/pedro/BOOT/; cp images/linux/boot.scr /media/pedro/BOOT/

cd ..


## Installing a Debian root filesystem using debootstrap
Then follow instructions here to confgure the root file system: https://akhileshmoghe.github.io/_post/linux/debian_minimal_rootfs

Here are the most important commands listed for convenience. 

    sudo apt install qemu-user-static
    sudo apt install debootstrap

    sudo debootstrap --arch=arm64 --foreign bookworm debianMinimalRootFS
    sudo cp /usr/bin/qemu-aarch64-static ./debianMinimalRootFS/usr/bin/
    sudo cp /etc/resolv.conf ./debianMinimalRootFS/etc/resolv.conf
    sudo chroot ./debianMinimalRootFS
    export LANG=C

    /debootstrap/debootstrap --second-stage (this takes several minutes)

Add these sources to /etc/apt/sources.list

deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware non-free

    Do some more file system configuration.

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
    Write filesystem to SD card.

sudo cp --recursive --preserve ./debianMinimalRootFS/* /media/pedro/rootfs/; sync



# Commands to burn Petalinux into the flash prom (not used)

petalinux-package --boot --u-boot --fpga ../../implement/results/top.bit --format MCS

program_flash -f ./proj1/images/linux/boot.mcs -offset 0 -flash_type qspi-x4-single -fsbl ./proj1/images/linux/zynqmp_fsbl.elf -cable type xilinx_tcf url TCP:127.0.0.1:3121



# Commands to create and install a wic image (not used)

petalinux-package --wic

sudo dd if=images/linux/petalinux-sdimage.wic of=/dev/sdc conv=fsync


# FPGA boot mode dip switch

SW1 controls boot mode. Setting a switch to the "on" positions asserts a "0" on the mode line, ON = 0. OFF = 1;

Switch positions 1, 2, 3 and 4 correspond to mode lines 3, 2, 1, 0.

SD Card mode: switch 1 = on, switch 2 = off, switch 3 = on, switch 4 = off.

## Run-time FPGA Configuration

Modify your FPGA build script to produce a .bin file in addition to the normal .bit file. The FPGA example in this project has that command in compile.tcl.
    
cp .../fpga/implement/results/top.bit.bin to /lib/firmware

sudo su

echo top.bit.bin > /sys/class/fpga_manager/fpga0/firmware

