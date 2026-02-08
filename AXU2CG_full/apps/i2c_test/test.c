// this little program uses direct access to the i2c driver to read the temperature register of the LM75.
#include <stdint.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>
#include <sys/fcntl.h> 
#include <sys/stat.h>
#include <sys/ioctl.h>      
#include <linux/i2c-dev.h>
#include <unistd.h>     
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char** argv)
{
    static const ulong addr = 0x48;  // address of LM75 on the I2C bus

    char dev[32] = "/dev/i2c-0";
    int fd = open(dev, O_RDWR);
    if (fd == -1) {
        perror("open device:");
        return -1;
    }

    printf("%s open, fd = 0x%08x\n", dev, fd);

    ioctl(fd, I2C_SLAVE, addr);  // tell the driver what i2c address to use.

    char sendbuf[16], recvbuf[16];
    sendbuf[0] = 0; 
    sendbuf[1] = 0;
    write(fd, sendbuf, 2);  // send 0,0 to the LM75 to tell it we want to access the temperature register.
    read(fd, recvbuf, 2);

    printf("0x%02x, 0x%02x\n", recvbuf[0], recvbuf[1]);

    uint16_t temp_val = recvbuf[0]<<8 | recvbuf[1];
    temp_val /= 128;  // 9 bit value is in bits 15:7 so divide by 128

    printf("temp_var = 0x%04x\n", temp_val);
    float tempC = 0.5*temp_val; // LM75 gives temperature in 0.5 degree increments.

    printf("tempC = %f\n", tempC);

    close(fd);

    return 0;
}


