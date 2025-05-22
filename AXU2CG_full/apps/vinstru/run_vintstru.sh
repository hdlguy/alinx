#!/bin/sh
./set_fpga_led 1
./set_pulse_params 10000 800 +30000 3000 # period, width, pulse amplitude, noise amplitude
./enable_pulse
./capture_waveform
./read_vinstru_bram 2000 > junk.txt
./set_fpga_led 0




