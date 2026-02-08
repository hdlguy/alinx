
#include "xil_printf.h"
#include "xparameters.h"
#include "fpga.h"

int main()
{

    xil_printf("\n\rHello World!\n\r");
    
    uint32_t* regptr = (uint32_t *)XPAR_REGFILE_CTRL_BASEADDR;
    
    xil_printf("FPGA_VERSION = 0x%08x\n\r", regptr[FPGA_VERSION]);
    xil_printf("FPGA_ID      = 0x%08x\n\r", regptr[FPGA_ID]);    
    
    for(int j=0;; j++){    
    	xil_printf("0x%08x: Success!\n\r", j);
    	for(int i=0; i<10000000; i++); // wait
    }

    return 0;
}
