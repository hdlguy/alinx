#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

float read_temp()
{
    //FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_temp0_ps_temp_raw", "r");
    FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_temp20_raw", "r");

    char iio_str[256];
    fscanf(fd_iio, "%s", iio_str);
    fclose(fd_iio);
    int iio_int = atoi(iio_str);
    //float temp = iio_int*503.975/4096.0 - 273.15;
    float temp = iio_int*503.975/65536.0 - 273.15;
    return(temp);
}

float read_vccint()
{
    //FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_voltage2_vccint_raw", "r");
    FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_voltage2_raw", "r");

    char iio_str[256];
    fscanf(fd_iio, "%s", iio_str);
    fclose(fd_iio);
    int iio_int = atoi(iio_str);
    float vccint = iio_int*3.0/65536.0;
    return(vccint);
}

float read_vccaux()
{
    //FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_voltage4_vccaux_raw", "r");
    FILE* fd_iio = fopen("/sys/bus/iio/devices/iio:device0/in_voltage4_raw", "r");
    char iio_str[256];
    fscanf(fd_iio, "%s", iio_str);
    fclose(fd_iio);
    int iio_int = atoi(iio_str);
    float vccaux = iio_int*3.0/65536.0;
    return(vccaux);
}

int main(int argc,char** argv)
{

    float temp = read_temp();
    float vccint = read_vccint();
    float vccaux = read_vccaux();

    int select = atoi(argv[1]);
    if (select == 1) fprintf(stdout, "%3.2f\n", temp);
    if (select == 2) fprintf(stdout, "%2.3f\n", vccint);
    if (select == 3) fprintf(stdout, "%2.3f\n", vccaux);

    return 0;
}


