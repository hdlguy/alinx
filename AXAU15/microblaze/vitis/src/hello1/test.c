
#include <stdio.h>
//#include "platform.h"
#include "xil_printf.h"
#include "fpga.h"


int main()
{
    //init_platform();

    xil_printf("Hello World\n\r");
    
    uint32_t *regptr = (uint32_t *)REG_BASEADDR;
    
    while(1) {
    	xil_printf("FPGA_VERSION = 0x%08x, FPGA_ID = 0x%08x\n\r", regptr[FPGA_VERSION], regptr[FPGA_ID]);
    	for(int i=0; i<4000000; i++);
    }
    
    //cleanup_platform();
    return 0;
}
