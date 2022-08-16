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


/*
    fprintf(stdout,"FPGA ID: 0x%08X\n",read_reg(pcie_addr,FPGA_ID));
    fprintf(stdout,"VERSION: 0x%08X\n",read_reg(pcie_addr,FPGA_VERSION));
    write_reg(pcie_addr, LED_CONTROL, 0x0f);


    // write the pmod LEDs
    write_reg(pcie_addr, PMOD_GPIO_OFFSET+GPIO_TRI,  0x0000);
    write_reg(pcie_addr, PMOD_GPIO_OFFSET+GPIO_DATA, 0x1234);


    // Test the scratch bram.
    uint32_t* write_data = malloc(TEST_BRAM_SIZE);
    uint32_t* read_data  = malloc(TEST_BRAM_SIZE);
    // create test data.
    //srand(1);
    for (int i=0; i<TEST_BRAM_SIZE/4; i++) write_data[i] = rand();
    uint32_t* bram_ptr = pcie_addr + TEST_BRAM_OFFSET;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<TEST_BRAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<TEST_BRAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    int errors = 0;
    for (int i=0; i<TEST_BRAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "scratch bram errors = %d\n", errors);
    free(write_data);
    free(read_data);
*/


    munmap(base_addr,FPGA_SIZE);

    return 0;
}


/*
void* phy_addr_2_vir_addr(off_t phy_addr,size_t size)
{
   void* vir_addr=NULL;

   int fd = open("/dev/mem",O_RDWR|O_SYNC);
   if(fd < 0)
   {
       fprintf(stderr,"Can't open /dev/mem\n");
   }
   else
   {
                  //0 is not NULL
      vir_addr=mmap(0,size,PROT_READ|PROT_WRITE,MAP_SHARED,fd,phy_addr);
      if(vir_addr == NULL)
      {
          fprintf(stderr,"Can't mmap\n");
      }
      else
      {
          //DEBUG("phy_addr 0x%lX mapped to 0x%lX with size=0x%x bytes\n",phy_addr,(uint64_t)vir_addr,(uint32_t)size);
          //DEBUG("phy_addr 0x%lx mapped to 0x%p with size=0x%zx bytes\n", phy_addr, vir_addr, size);
      }
   }
   return vir_addr;
}


*/
