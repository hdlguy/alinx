#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// enable_pulse.c
// enables pulse generation
// usage: sudo ./enable_pulse
int main(int argc,char** argv)
{

    void* base_addr;

    int fd = open("/dev/mem",O_RDWR|O_SYNC);
    if(fd < 0) {
        fprintf(stderr,"Can't open /dev/mem, you must be root!\n");
    } else {
        base_addr=mmap(0,FPGA_SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,fd,FPGA_BASE_ADDRESS);
        if(base_addr == NULL) fprintf(stderr,"Can't mmap\n");
    }

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    regptr[VINSTRU_PULSE_ENABLE] = 1;

    munmap(base_addr,FPGA_SIZE);

    return 0;
}


//#define     VINSTRU_PULSE_ENABLE    4
//#define     VINSTRU_PULSE_PERIOD    5
//#define     VINSTRU_PULSE_WIDTH     6
//#define     VINSTRU_PULSE_AMPLITUDE 7
//#define     VINSTRU_NOISE_AMPLITUDE 8
