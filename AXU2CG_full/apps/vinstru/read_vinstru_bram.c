#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// read_vinstru_bram.c
// Reads the data from the vinstru bram and writes it to stdout in signed decimal format.
// usage: sudo ./read_vinstru_bram <numvals>
// numvals (0..4096) is the number of values to read and print 
int main(int argc,char** argv)
{
    uint32_t num_vals = atoi(argv[1]);

    void* base_addr;
    int fd = open("/dev/mem",O_RDWR|O_SYNC);
    if(fd < 0) {
        fprintf(stderr,"Can't open /dev/mem, you must be root!\n");
    } else {
        base_addr=mmap(0,FPGA_SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,fd,FPGA_BASE_ADDRESS);
        if(base_addr == NULL) fprintf(stderr,"Can't mmap\n");
    }

    uint32_t *bramptr = base_addr + VINSTRU_BRAM_OFFSET;

    for(uint32_t i=0; i<num_vals; i++) fprintf(stdout, "%d\n", (int32_t)bramptr[i]);
    //fprintf(stdout, "\n");

    munmap(base_addr,FPGA_SIZE);

    return 0;
}


//#define     VINSTRU_BRAM_OFFSET      0x00040000
//#define     VINSTRU_BRAM_SIZE        0x00004000 // 16k
