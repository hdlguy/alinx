#!/bin/sh
./set_fpga_led 1
./set_pulse_params 1000 400 30000 0 # period, width, pulse amplitude, noise amplitude
./enable_pulse
./capture_waveform
./read_vinstru_bram 2000 > junk.txt
./set_fpga_led 0




