
#include "xil_printf.h"
#include "xparameters.h"
#include "fpga.h"

int main()
{

    xil_printf("\n\rHello World!\n\r");
    
    uint32_t* regptr = (uint32_t *)REG_BASEADDR;
    
    xil_printf("FPGA_VERSION = 0x%08x\n\r", regptr[FPGA_VERSION]);
    xil_printf("FPGA_ID      = 0x%08x\n\r", regptr[FPGA_ID]);    


    // flash LED
    for(int j=0;; j++){    
    	xil_printf("0x%08x: Success!\n\r", j);
    	regptr[LED_CONTROL] += 1;
    	for(int i=0; i<10000000; i++); // wait
    }

    return 0;
}
