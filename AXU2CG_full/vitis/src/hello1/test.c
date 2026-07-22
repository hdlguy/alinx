#include <stdio.h>
#include <string.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "common_headers/fpga.h"
#include "sleep.h"

int main()
{

    uint32_t *regptr = (uint32_t *)XPAR_REGFILE_CTRL_BASEADDR;
    xil_printf("FPGA_VERSION = 0x%08x, FPGA_ID = 0x%08x\r\n", regptr[FPGA_VERSION], regptr[FPGA_ID]);


    int whilecount = 0;
    for(;;){
    	
        xil_printf("0x%08x: Hello!\r\n", whilecount);   

        whilecount++;
        usleep(1000000);
        
    }

    return 0;
}
