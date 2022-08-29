# ALINX Board
Some fpga and software logic to test out the new ALINX AXU2CG-E development board.

    [http://www.alinx.com/en/index.php/default/content/147.html]
    [http://www.alinx.com/en/index.php/default/content/108.html]

## Methodology
First, an fpga design was created with Zynq MPSOC system and this was compiled.  The resulting XSA file was then used to 
create a Petalinux boot image that mounts the sd card as a Debian root filesystem.

Features of the the board were then tested using Linux command, C programs and fpga logic.

## Things Tested
    - Xilinx XCZU2CG-1SFVC784E MPSOC device
    - PS DDR4 memory
    - ALINX AL321 USB debug/download cable
    - fan PWM control
    - PL LED
    - eMMC drive
    - QSPI boot to Petalinux
    - SD card
    - PS UART
    - PL UART
    - PS Ethernet
    - 200MHz differential PL clock
    - PS I2C board temperature sensor
    - M.2 PCIe

## Things Not Yet Tested
    - PL DDR4 memory (not installed on ACU2G SOM module)
    - CAN Bus
    - Camera Interface
    - Mini-Displayport Interface
    - PS LED
    - PL Ethernet
    - Dual 40 pin expansion connectors
    - USB 3.0 hub


## Test and Review
After purchase, ALINX provides schematics of the core SOM board and the carrier board as well as a thorough user's guide in English and Chinese.  Lacking are Vivado board definition files and Petalinux BSP.

An fpga test design was created with PS peripherals enabled and Petalinux was built using the resulting XSA file.

###  Xilinx XCZU2CG-1SFVC784E MPSOC
Both the PS and PL sides of the device were used extensively in these tests.

### PS DDR4 memory
The 2 GB PS DDR4 memory was used to run Petalinux and some Vitis applications.  DDR4 timing was found by selecting a Samsung memory and then adjusting slightly. The settings were not optimized but no problems have been seen.

### ALINX AL321 USB debug/download cable
ALINX ships a very fine JTAG debug cable with the development board.  The usb cable is bright red which is helpful on a crowded bench covered with black cables. The debug cable enumerates as Digilent logic so ALINX must have licensed it from them. That's good. The cable supports both 14 pin and the older 10 pin connections.
We used this cable for all work which included QSPI programming, Vitis SDK and ILA Chipscope.

### fan PWM control
We applied a 1KHz 1/8 duty cycle pwm signal to the fan and got a nice quiet fan speed.

### PL LED
The PL LED is flashing.

### eMMC drive
The eMMC drive was tested by enabling the interface in Vivado and rebuilding Petalinux.  That results in /dev/mmcblk0 showing up under Linux. Standard Linux commands were then used to partition, format and mount the drive resulting in:

    sudo fdisk /dev/mmcblk0
    sudo mkfs.ext4 /dev/mmcblk0p1
    sudo mkdir /mnt/emmc
    sudo mount /dev/mmcblk0p1 /mnt/emmc

    /dev/mmcblk0p1  7.2G   33M  6.7G   1% /mnt/emmc

Write speed:

pedro@linaro-developer:\~$ time sudo dd if=/dev/zero of=/dev/mmcblk0p1 bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 21.6952 s, **96.7 MB/s**

Read speed:

pedro@linaro-developer:\~$ time sudo dd if=/dev/mmcblk0 of=/dev/null bs=2M count=1000
mmcblk0       mmcblk0boot0  mmcblk0boot1  mmcblk0p1     mmcblk0rpmb   
pedro@linaro-developer:\~$ time sudo dd if=/dev/mmcblk0p1 of=/dev/null bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 22.6514 s, **92.6 MB/s**

### QSPI boot to Petalinux
The QSPI was programed to boot Petalinux to ram filesystem from powerup.

### SD card boot 
The boot mode lines on the SOM were set to sd card.  An sd card was created to boot Petalinux to a Debian file system on the sd card. See instructions under petalinux folder.

Write speed:

pedro@linaro-developer:\~$ time sudo dd if=/dev/zero of=~/ddtarget bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 82.182 s, ***25.5 MB/s***

Read speed:

pedro@linaro-developer:\~$ time sudo dd if=~/ddtarget of=/dev/null bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 87.5167 s, ***24.0 MB/s***

### PS UART
The PS uart was enabled in Vivado and used as the Petalinux boot console and to print from Vitis applications.

### PL UART
A Vitis application was built using the axi_uartlite_0 device in the PL. The interface works.

### PS Ethernet
The GEM3 ethernet MAC of the PS was enabled and Petalinux automatically connects to the network. User control was then done using ssh. A minimal Apache2 web server was demonstrated.

### 200MHz differential PL clock
The 200MHz differential clock is used in the fpga design to run a counter that was observed with an ILA debug core.

### PS I2C board temperature sensor
The I2C bus to the onboard temperature sensor was enabled in Vivado. Petalinux was rebuild with new XSA file.  The temperature sensor was accessed using the linux driver, i2c-tools and a little linux program. See apps/i2c_test.


### M.2 PCIe
An nvme ssd was installed in the M.2 slot of the carrier board.  Vivado ZynqMP adjustments were made and the fpga recompiled. Petalinux kernel configurations were set to support nVME drive as block device. Standard linux commands were used to partition, format and mount the drive.

    sudo fdisk /dev/nvme0n1
    sudo mkfs.ext4 /dev/nvme0n1p1 
    sudo mkdir /mnt/nvme
    sudo mount /dev/nvme0n1p1 /mnt/nvme/

    /dev/nvme0n1p1 ext4      234G   60M  222G   1% /mnt/nvme

Write speed:

pedro@linaro-developer:\~$ time sudo dd if=/dev/zero of=/dev/nvme0n1p1 bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 6.54003 s, **321 MB/s**

Read speed:

pedro@linaro-developer:\~$ time sudo dd if=/dev/nvme0n1p1 of=/dev/null bs=2M count=1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 5.42412 s, **387 MB/s**


