ALL_EXE = test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -I..  -I../API -I../hw -Wall

DEPS = Makefile ../fpga.h

PUBLIC_LIBS = 
LIB_FILES =

LIB_OBJS := $(subst .c,.o,$(LIB_FILES))

test: test.o $(LIB_OBJS) $(PUBLIC_LIBS)
# $@: target file name, $^: all prerequisites
	gcc -g -o $@ $^

run: test 
	@echo "You must be in root."
	./test  f0000000

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.c $(DEPS) 
# $<: first prerequisite
	$(CC) -g -c -o $@ $< $(CFLAGS)
