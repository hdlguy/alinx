ALL_EXE = get_fpga_version
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -I../ -Wall

DEPS = Makefile ../fpga.h 

# $@ = target file name, $^ = all prerequisites, $< = first prerequisite

get_fpga_version: get_fpga_version.c $(DEPS)
	$(CC) -g -o $@ $< $(CFLAGS)

clean:
	rm -rf $(ALL_EXE) 


