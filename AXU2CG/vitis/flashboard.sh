#!/bin/bash

## ./flashboard.sh  command_proc

appname=$1

echo -e "the_ROM_image:\n{\n\t[bootloader]./workspace/standalone_plat/export/standalone_plat/sw/standalone_plat/boot/fsbl.elf\n\t../implement/results/top.bit\n\t./workspace/$appname/Debug/$appname.elf\n}\n" > output.bif

bootgen -image ./output.bif -arch zynqmp -o ./BOOT.bin -w on 

program_flash -f ./BOOT.bin -offset 0 -flash_type qspi-x4-single -fsbl ./workspace/standalone_plat/export/standalone_plat/sw/standalone_plat/boot/fsbl.elf -cable type xilinx_tcf url TCP:127.0.0.1:3121 

