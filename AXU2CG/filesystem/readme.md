
# Installing a Debian root filesystem using debootstrap
Follow instructions at this link to confgure the root file system: https://akhileshmoghe.github.io/_post/linux/debian_minimal_rootfs

## the most important commands listed for convenience. 

### Run QEMU
```
    sudo apt install qemu-user-static
    sudo apt install debootstrap

    sudo debootstrap --arch=arm64 --foreign bookworm debianMinimalRootFS
    sudo cp /usr/bin/qemu-aarch64-static ./debianMinimalRootFS/usr/bin/
    sudo cp /etc/resolv.conf ./debianMinimalRootFS/etc/resolv.conf
    sudo chroot ./debianMinimalRootFS
    export LANG=C

    /debootstrap/debootstrap --second-stage (this takes several minutes)
```

### Add apt sources
Add these sources to /etc/apt/sources.list

deb http://deb.debian.org/debian bookworm main contrib non-free-firmware non-free
deb http://deb.debian.org/debian bookworm-updates main contrib non-free-firmware non-free
deb http://security.debian.org/debian-security bookworm-security main contrib non-free-firmware non-free

### More file system configuration.

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

    exit

### Write filesystem to SD card.
```
sudo cp --recursive --preserve ./debianMinimalRootFS/* /media/pedro/rootfs/; sync
```

## Run-time FPGA Configuration
Modify your FPGA build script to produce a .bin file in addition to the normal .bit file. The FPGA example in this project has that command in compile.tcl.
```
cp .../fpga/implement/results/top.bit.bin to /lib/firmware
sudo su
echo top.bit.bin > /sys/class/fpga_manager/fpga0/firmware
```

