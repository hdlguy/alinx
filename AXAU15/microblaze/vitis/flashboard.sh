#!/bin/bash

## ./flashboard.sh  command_proc

appname=$1
memfile=../implement_neso/results/top.mmi
bitfile=../implement_neso/results/top.bit

echo $appname

updatemem --force --meminfo $memfile  --bit $bitfile --data ./workspace/$appname/Debug/$appname.elf --proc mb_inst/system_i/microblaze_0 --out ./download.bit 

echo "the_ROM_image: { ./download.bit }" > bootgen754.bif

bootgen -arch fpga -image ./bootgen754.bif -w -o ./BOOT.bin -interface spi 

#program_flash -f ./BOOT.bin -offset 0 -flash_type mt25ql128-spi-x1_x2_x4 -url TCP:127.0.0.1:3121 
program_flash -f ./BOOT.bin -offset 0 -flash_type is25lp128f-spi-x1_x2_x4 -url TCP:127.0.0.1:3121 

