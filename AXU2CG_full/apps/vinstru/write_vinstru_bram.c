#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// write_vinstru_bram.c
// Can be used to write data to the vinstru bram
// usage: sudo ./write_vinstru_bram <val0> <val1> ... <val(N-1)>
// writes up to 4096 values in decimal format to the vinstru bram.
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

    uint32_t *bramptr = base_addr + VINSTRU_BRAM_OFFSET;

    for(uint32_t i=1; i<argc; i++) bramptr[i-1] = atoi(argv[i]);

    munmap(base_addr,FPGA_SIZE);

    return 0;
}


