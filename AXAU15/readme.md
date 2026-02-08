# AXAU15
Two fpga designs are here for testing different parts of the board.

## microblaze
This is a simple microblaze design with associated Vitis SDK software projects.  The main purpose is to test the DDR4 memory but I have not made that work yet.

## pcie
This is a simple PCIe design based on the XDMA bridge IP core. I have not been successful making this enumerate reliably.

## heater
A version of the heater design was created to do thermal and powersupply testing. https://github.com/hdlguy/heater.git  The cooling and power supply survived extreme testing with margin.

