# ALINX Board
Some fpga and software logic to test out the new ALINX AXU2CG-E development board.

## Methodology
First, an fpga design was created with Zynq MPSOC system and this was compiled.  The resulting XSA file was then used to 
create a Petalinux boot image that mounts the sd card as a Debian root filesystem.

Features of the the board were then tested using Linux command, C programs and fpga logic.

## Things Tested
    - Xilinx XCZU2CG-1SFVC784E MPSOC device
    - PS DDR4 memory
    - AlINX AL321 USB debug/download cable
    - fan PWM control
    - PL LED
    - eMMC drive
    - QSPI boot to Petalinux
    - SD card boot to Petalinux with Debian root filesyste on sd card
    - PS UART
    - PL UART
    - PS Ethernet
    - 200MHz differential PL clock

## Tings Not Yet Tested
    - PL DDR4 memory (not installed on ACU2G SOM module)
    - CAN Bus
    - Camera Interface
    - Display Interface
    - Mini-Displayport Interface
    - PS LED
    - PL Ethernet
    - M.2 PCIe
    - Dual 40 pin expansion connectors
    - USB 3.0 hub


## Test and Review
An fpga test design was created with PS peripherals enabled and Petalinux was built using the resulting XSA file

###  Xilinx XCZU2CG-1SFVC784E MPSOC
Both the PS and PL sides of the device were used extensively in these tests.

### PS DDR4 memory
The 2 GB PS DDR4 memory was used to run Petalinux and some Vitis applications.  DDR4 timing was found by selecting a Samsung memory and then adjusting slightly. The settings were not optimized but no problems have been seen.

### AlINX AL321 USB debug/download cable
ALINX ships a very fine JTAG debug cable with the development board.  The usb cable is bright red which is helpful on a crowded bench covered with black cables. The debug cable enumerates as Digilent logic so ALINX must have license it from them. That's good. The cable suppors both 14 pin and the older 10 pin connections.
We used this cable for all programming and debugging which included Vitis SDK and ILA Chipscope.

### fan PWM control
We applied a 1KHz 1/8 duty cycle pwm signal to the fan and got a nice quite fan speed.

### PL LED
The PL LED is flashing.

### eMMC drive
The eMMC drive was tested by enabling the interface in Vivado and rebuilding Petalinux.  That results in /dev/mmcblk0 showing up under Linux. Standard Linux commands were then used to partition, format and mount the drive resulting in:

    /dev/mmcblk0p1  7.2G   33M  6.7G   1% /mnt/emmc


### QSPI boot to Petalinux
The QSPI was programed to boot Petalinux to ram filesystem from powerup.

### SD card boot to Petalinux with Debian root filesyste on sd card
The boot mode lines on the SOM were set to sd card.  An sd card was created to boot Petalinux to a Debian file system on the sd card. See instructions under petalinux folder.

### PS UART
The PS uart was enable in Vivado and used to interact with the Petalinux boot process and print from Vitis applications.

### PL UART
A Vitis application was built using the axi_uartlite_0 device in the PL. The interface works.

### PS Ethernet
The GEM3 ethernet MAC of the PS was enabled and Petalinux automatically connects to the network. User control was then done using ssh.

### 200MHz differential PL clock
The 200MHz differential clock as used in the fpga design to run a counter that was observed with an ILA debug core.

