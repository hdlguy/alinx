ALL_EXE = get_fpga_version set_fpga_led read_vinstru_bram write_vinstru_bram set_pulse_params enable_pulse disable_pulse capture_waveform
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -I../ -Wall

DEPS = Makefile ../fpga.h 

# $@ = target file name, $^ = all prerequisites, $< = first prerequisite

capture_waveform: capture_waveform.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

disable_pulse: disable_pulse.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

enable_pulse: enable_pulse.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

set_pulse_params: set_pulse_params.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

write_vinstru_bram: write_vinstru_bram.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

read_vinstru_bram: read_vinstru_bram.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

set_fpga_led: set_fpga_led.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

get_fpga_version: get_fpga_version.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

clean:
	rm -rf $(ALL_EXE) 


