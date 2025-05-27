
#define     FPGA_BASE_ADDRESS       0xa0000000
#define     FPGA_SIZE               0x00100000

#define     FPGA_REG_OFFSET         0x00000000

// register numbers
#define     FPGA_ID                 0
#define     FPGA_VERSION            1
#define     FPGA_LED                2 // [0] = PL LED value, read/write

#define     VINSTRU_PULSE_ENABLE    3 // [0] = pulse enable (rw), starts the pulse generator
#define     VINSTRU_CAPTURE_CONTROL 4 // [0] = capture run (rw), [4] = capture done (ro), [8] = reset (rw), 
#define     VINSTRU_PULSE_PERIOD    5 // [15:0] = period between pulses in samples (rw)
#define     VINSTRU_PULSE_WIDTH     6 // [15:0] = pulse width in samples (rw)
#define     VINSTRU_PULSE_AMPLITUDE 7 // [15:0] = pulse amplitide in counts (rw)
#define     VINSTRU_NOISE_AMPLITUDE 8 // [15:0] = noise amplitude (standard deviation) in counts (rw)


// Test Bram (rw)
#define     TEST_RAM_OFFSET         0x00010000
#define     TEST_RAM_SIZE           0x00001000 // 4KB

// Vinstru Bram that gets the capture output (rw)
#define     VINSTRU_BRAM_OFFSET      0x00020000
#define     VINSTRU_BRAM_SIZE        0x00004000 // 16KB = 4K 32-bit words


