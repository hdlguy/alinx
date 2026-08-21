#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

//#include "mem-io.h"
//#include "utils.h"
//#include "proto2_hw.h"
#include "fpga.h"


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

    printf("FPGA_BASE_ADDRESS = 0x%08x, base_addr = %p\n", FPGA_BASE_ADDRESS, base_addr);

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    printf("FPGA_ID = 0x%08x, FPGA_VERSION = 0x%08x\n", regptr[FPGA_ID], regptr[FPGA_VERSION]);


    uint32_t* write_data;
    uint32_t* read_data;
    uint32_t* bram_ptr;
    int errors;

    // Test the scratch bram.
    fprintf(stdout, "\nTEST_RAM_SIZE = %u\n", TEST_RAM_SIZE);
    write_data = malloc(TEST_RAM_SIZE);
    read_data  = malloc(TEST_RAM_SIZE);
    // create test data.
    for (int i=0; i<TEST_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + TEST_RAM_OFFSET;
    fprintf(stdout, "bram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<TEST_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<TEST_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<TEST_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "scratch bram errors = %d\n", errors);
    free(write_data);
    free(read_data);

    // Test the vinstru bram.
    fprintf(stdout, "\nVINSTRU_BRAM_SIZE = %u\n", VINSTRU_BRAM_SIZE);
    write_data = malloc(VINSTRU_BRAM_SIZE);
    read_data  = malloc(VINSTRU_BRAM_SIZE);
    // create test data.
    for (int i=0; i<VINSTRU_BRAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + VINSTRU_BRAM_OFFSET;
    fprintf(stdout, "bram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<VINSTRU_BRAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<VINSTRU_BRAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<VINSTRU_BRAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "vinstru bram errors = %d\n", errors);
    free(write_data);
    free(read_data);


    munmap(base_addr,FPGA_SIZE);

    return 0;
}


