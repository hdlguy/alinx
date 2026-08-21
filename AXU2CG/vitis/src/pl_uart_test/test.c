#include <stdio.h>
#include <string.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "fpga.h"


int main()
{
    init_platform();

    int unused;

    uint32_t *regptr = (uint32_t *)XPAR_M00_AXI_BASEADDR;
    xil_printf("FPGA_VERSION = 0x%08x, FPGA_ID = 0x%08x\r\n", regptr[FPGA_VERSION], regptr[FPGA_ID]);


    int count = 0;
    int acc = 0;
    for(;;){
        for(int i=0; i<10000000; i++) acc += count;
        xil_printf("0x%08x, 0x%08x: Hello!\r\n", count, acc);
        count++;
    }

    cleanup_platform();
    return 0;
}
