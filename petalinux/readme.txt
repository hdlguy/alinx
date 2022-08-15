
petalinux-create --force --type project --template zynqMP --name proj1

cp system-user.dtsi proj1/project-spec/meta-user/recipes-bsp/device-tree/files/

cd proj1

petalinux-config --get-hw-description=../../implement/results/

    * Yocto Settings -> Add pre-mirror url -> change http: to https:
    * Yocto Settings -> Network State Feeds url -> change http: to https:
    * Image Settings -> EXT4 (if you want the rootfs on the sd card)
    * save and exit

petalinux-build -c bootloader -x distclean

petalinux-config -c kernel --silentconfig

petalinux-build

petalinux-package --force --boot --u-boot --kernel --offset 0xF40000 --fpga ../../implement/results/top.bit


cp images/linux/BOOT.BIN /media/pedro/BOOT/
cp images/linux/image.ub /media/pedro/BOOT/
cp images/linux/boot.scr /media/pedro/BOOT/

cd ..

wget https://releases.linaro.org/debian/images/developer-arm64/latest/linaro-stretch-developer-20180416-89.tar.gz

sudo tar --preserve-permissions -zxvf linaro-stretch-developer-20180416-89.tar.gz

sudo cp --recursive --preserve binary/* /media/pedro/rootfs/; sync


**********************************

petalinux-package --boot --u-boot --fpga ../../implement/results/top.bit --format MCS

program_flash -f ./proj1/images/linux/boot.mcs -offset 0 -flash_type qspi-x4-single -fsbl ./proj1/images/linux/zynqmp_fsbl.elf -cable type xilinx_tcf url TCP:127.0.0.1:3121


*********** wic on sd card ************* 

petalinux-package --wic

sudo dd if=images/linux/petalinux-sdimage.wic of=/dev/sdc conv=fsync



**** something like this will burn the qspi

program_flash -f ./images/linux/BOOT.BIN -offset 0 -flash_type qspi-x4-single -fsbl ./images/linux/zynqmp_fsbl.elf -cable type xilinx_tcf url TCP:127.0.0.1:3121
