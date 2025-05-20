
#define     FPGA_BASE_ADDRESS       0xa0000000
#define     FPGA_SIZE               0x00100000

#define     FPGA_REG_OFFSET         0x00000000

// register numbers
#define     FPGA_ID                 0
#define     FPGA_VERSION            1
#define     FPGA_LED                2 // [0] = PL LED value, read/write

#define     VINSTRU_PULSE_ENABLE    4 // [0] = pulse enable (r/w), [4] = capture run (r/w), [8] = capture done (ro)
#define     VINSTRU_PULSE_PERIOD    5 // [31:0] = period between pulses in samples (r/w)
#define     VINSTRU_PULSE_WIDTH     6 // [15:0] = pulse width in samples (r/w)
#define     VINSTRU_PULSE_AMPLITUDE 7 // [15:0] = pulse amplitide in counts (r/w)
#define     VINSTRU_NOISE_AMPLITUDE 8 // [15:0] = noise amplitude (standard deviation) in counts



#define     TEST_RAM_OFFSET         0x00010000
#define     TEST_RAM_SIZE           0x00001000 // 4k

#define     VINSTRU_BRAM_OFFSET      0x00040000
#define     VINSTRU_BRAM_SIZE        0x00004000 // 16k


