#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// get_register.c
// usage: sudo ./get_register <regnum>
// prints the value of register regnum in hex format
int main(int argc,char** argv)
{
    int32_t regnum = atoi(argv[1]);

    void* base_addr;

    int fd = open("/dev/mem",O_RDWR|O_SYNC);
    if(fd < 0) {
        fprintf(stderr,"Can't open /dev/mem, you must be root!\n");
    } else {
        base_addr=mmap(0,FPGA_SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,fd,FPGA_BASE_ADDRESS);
        if(base_addr == NULL) fprintf(stderr,"Can't mmap\n");
    }

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    fprintf(stdout, "%08x\n", regptr[regnum]);

    munmap(base_addr,FPGA_SIZE);

    return 0;
}


