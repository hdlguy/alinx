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
    - PS Ethernet
    - USB 3.0 hub
    - 200MHz differential PL clock

## Tings Not Yet Tested
    - PL DDR4 memory
    - CAN Bus
    - Camera Interface
    - Display Interface
    - Mini-Displayport Interface
    - PS LED
    - PL Ethernet
    - M.2 PCIe
    - Dual 40 pin expansion connectors



