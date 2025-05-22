#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// set_fpga_led.c
// writes the value (1 or 0) to the LED on the board.
// usage: sudo ./set_fpga_led <val>
int main(int argc,char** argv)
{
    uint32_t led = atoi(argv[1]);

    void* base_addr;

    int fd = open("/dev/mem",O_RDWR|O_SYNC);
    if(fd < 0) {
        fprintf(stderr,"Can't open /dev/mem, you must be root!\n");
    } else {
        base_addr=mmap(0,FPGA_SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,fd,FPGA_BASE_ADDRESS);
        if(base_addr == NULL) fprintf(stderr,"Can't mmap\n");
    }

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    regptr[FPGA_LED] = led;

    munmap(base_addr,FPGA_SIZE);

    return 0;
}


