#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"

// capture_waveform.c
// uses the capture control logic of the vinstru to collect virtual instrument data.
// The pulse generator must be running in advance of this command to trigger the capture.
// usage: sudo ./capture_waveform
// The results are returned in the vinstru block ram to be read by the read_vinstru_bram command.
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
    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    regptr[VINSTRU_CAPTURE_CONTROL] = (1<<8); // reset capture logic
    regptr[VINSTRU_CAPTURE_CONTROL] = 0; 

    regptr[VINSTRU_CAPTURE_CONTROL] = 0; // clear capture run
    //printf("waiting for done to clear\n");
    while((0x10 & regptr[VINSTRU_CAPTURE_CONTROL]) != 0); // wait for capture done to clear

    regptr[VINSTRU_CAPTURE_CONTROL] = 1; // set capture run
    //printf("waiting for done to assert\n");
    while((0x10 & regptr[VINSTRU_CAPTURE_CONTROL]) != 0x10); // wait for capture done to assert

    regptr[VINSTRU_CAPTURE_CONTROL] = 0; // clear capture run
    //printf("waiting for done to clear\n");
    while((0x10 & regptr[VINSTRU_CAPTURE_CONTROL]) != 0); // wait for capture done to clear

    munmap(base_addr,FPGA_SIZE);

    return 0;
}

//#define     VINSTRU_PULSE_ENABLE    3 // [0] = pulse enable (r/w), [4] = capture run (r/w), [8] = capture done (ro)
//#define     VINSTRU_CAPTURE_CONTROL 4 // [0] = capture run (r/w), [4] = capture done (ro)
//#define     VINSTRU_PULSE_PERIOD    5 // [31:0] = period between pulses in samples (r/w)
//#define     VINSTRU_PULSE_WIDTH     6 // [15:0] = pulse width in samples (r/w)
//#define     VINSTRU_PULSE_AMPLITUDE 7 // [15:0] = pulse amplitide in counts (r/w)
//#define     VINSTRU_NOISE_AMPLITUDE 8 // [15:0] = noise amplitude (standard deviation) in counts
