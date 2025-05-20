ALL_EXE = get_fpga_version set_fpga_led
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -I../ -Wall

DEPS = Makefile ../fpga.h 

# $@ = target file name, $^ = all prerequisites, $< = first prerequisite

set_fpga_led: set_fpga_led.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

get_fpga_version: get_fpga_version.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

clean:
	rm -rf $(ALL_EXE) 


