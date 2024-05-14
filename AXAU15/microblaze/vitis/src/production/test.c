#include "xparameters.h"
#include "xiic.h"
#include "xintc.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "math.h"
#include "fpga.h"

#define IIC_DEVICE_ID			XPAR_IIC_0_DEVICE_ID
#define INTC_DEVICE_ID			XPAR_INTC_0_DEVICE_ID
#define INTC_IIC_INTERRUPT_ID	XPAR_INTC_0_IIC_0_VEC_ID

static void SendHandler  (void *CallbackRef, int ByteCount);
static void RecvHandler  (void *CallbackRef, int ByteCount);
static void StatusHandler(void *CallbackRef, int Status);

XIic Iic;
XIntc InterruptController;

volatile struct {
	int EventStatus;
	int RemainingRecvBytes;
	int EventStatusUpdated;
	int RecvBytesUpdated;
	int RemainingSendBytes;
	int SendBytesUpdated;
} HandlerInfo;

// This application reads the SHT35-DIS-F2.5KS relative humidity and temperature sensors over I2C.
// We will try to control the AD5259BRMZ5 digital potentiometer as well.
int main(void)
{

	uint32_t* regptr = (uint32_t *)XPAR_M00_AXI_BASEADDR;
	xil_printf("\n\rFPGA_ID = 0x%08x, FPGA_VERSION = 0x%08x\n\r", regptr[FPGA_ID], regptr[FPGA_VERSION]);

	// setup and start the IIC Controller
	XIic_Config *ConfigPtr;
	ConfigPtr = XIic_LookupConfig(IIC_DEVICE_ID);
	XIic_CfgInitialize    (&Iic, ConfigPtr, ConfigPtr->BaseAddress);
	XIic_SetSendHandler   (&Iic, (void *)&HandlerInfo, SendHandler);
	XIic_SetRecvHandler   (&Iic, (void *)&HandlerInfo, RecvHandler);
	XIic_SetStatusHandler (&Iic, (void *)&HandlerInfo, StatusHandler);

	XIntc_Initialize(&InterruptController, INTC_DEVICE_ID);
	XIntc_Connect   (&InterruptController, INTC_IIC_INTERRUPT_ID, XIic_InterruptHandler, &Iic);
	XIntc_Start     (&InterruptController, XIN_REAL_MODE);
	XIntc_Enable    (&InterruptController, INTC_IIC_INTERRUPT_ID);
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler) XIntc_InterruptHandler, &InterruptController);
	Xil_ExceptionEnable();

	HandlerInfo.EventStatusUpdated = FALSE;
	HandlerInfo.RecvBytesUpdated = FALSE;

	int tx_status=-1, rx_status=-1;
	xil_printf("%d\n\r", tx_status+rx_status);
	u8 tx_ptr[10], rx_ptr[10];

	XIic_Start(&Iic);


	// write the RH reset register
	XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_HUMIDITY);
	tx_ptr[0] = 0x30; tx_ptr[1] = 0xA2;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2);
	for (int i=0; i<10000000; i++);
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2);
	for (int i=0; i<10000000; i++);

	// read the RH status register
	uint16_t dev_status;
	tx_ptr[0] = 0xF3; tx_ptr[1] = 0x2D;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	rx_status = XIic_MasterRecv(&Iic, rx_ptr, 3); for (int i=0; i<50000; i++);
	dev_status = ((rx_ptr[0]<<8) |  (rx_ptr[1]<<0)) & 0xfc1f;
	xil_printf("RH status = %04x\n\r", dev_status);

	// read the POT stored EEPROM value.
	XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_DIGIPOT);
	tx_ptr[0] = 0x20;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
	rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
	xil_printf("POT Stored EEPROM value = 0x%02x\n\r", rx_ptr[0]);

	// read the POT tolerance.
	int16_t pot_tol=0;
	tx_ptr[0] = 0x3e;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
	rx_status = XIic_MasterRecv(&Iic, rx_ptr, 2); for (int i=0; i<50000; i++);
	if ((rx_ptr[0] & 0x10) == 0) {
		pot_tol = +((rx_ptr[0]<<8) | (rx_ptr[1]<<0));
	} else {
		pot_tol = -(((rx_ptr[0] & 0x7f)<<8) | (rx_ptr[1]<<0));
	}
	xil_printf("POT Tolerance = 0x%02x%02x = %d.%d%%\n\r", rx_ptr[0], rx_ptr[1], pot_tol/256, (int)(1000.0*(pot_tol&0x00ff)/256.0));


	// read mag whoami register
	XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_MAG);
	tx_ptr[0] = 0x4f;  // whoami
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
	rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
	xil_printf("magnetometer whoami = 0x%02x\n\r",rx_ptr[0]);
	// reset mag
	tx_ptr[0] = 0x60;  // cfg_a
	tx_ptr[1] = 0x20;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	// write mag configuration registers
	tx_ptr[0] = 0x60;  // cfg_a
	tx_ptr[1] = 0x80;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	tx_ptr[0] = 0x61;  // cfg_b
	tx_ptr[1] = 0x03;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	tx_ptr[0] = 0x62;  // cfg_c
	tx_ptr[1] = 0x10;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);

	// gyro/accellerometer initialization
	XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_GYRO);
	tx_ptr[0] = 0x0f;  // whoami
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
	rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
	xil_printf("gyro whoami = 0x%02x\n\r",rx_ptr[0]);
	// reset the gyro chip
	tx_ptr[0] = 0x12;  // ctrl3_c
	tx_ptr[1] = 0x01;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	// enable auto increment of register address
	tx_ptr[0] = 0x12;  // ctrl3_c
	tx_ptr[1] = 0x04;
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
	tx_ptr[0] = 0x10;  // ctrl1_xl address
	tx_ptr[1] = 0x10;  // ctrl1_xl value
	tx_ptr[2] = 0x10;  // ctrl2_g
//	tx_ptr[3] = 0x04;  // ctrl3_c
//	tx_ptr[3] = 0x00;  // ctrl4_c
//	tx_ptr[3] = 0x00;  // ctrl5_c
//	tx_ptr[3] = 0x90;  // ctrl6_c
//	tx_ptr[3] = 0x00;  // ctrl7_g
	tx_status = XIic_MasterSend(&Iic, tx_ptr, 3); for (int i=0; i<50000; i++);



	uint32_t whilecount = 0;
	int16_t rh, tc;
	float humR, tempC;
	uint8_t dpot_stored, dpot_rdac, dpot_desired;
	int16_t dpot_tol;
	//uint8_t mag_data[8];
	uint16_t mag_temp, mag_x, mag_y, mag_z;
	int16_t gyro_temp, gyro_accel_x, gyro_accel_y, gyro_accel_z, gyro_gyro_x, gyro_gyro_y, gyro_gyro_z;
	float gyro_temp_int, gyro_temp_frac;
	while(1) {



		// send the RH measurement command
		XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_HUMIDITY);
		tx_ptr[0] = 0x24; tx_ptr[1] = 0x00;
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);

		for (int i=0; i<20000000; i++);
		//xil_printf("\n\r");
		xil_printf("\n\rwhilecount = %u\n\r", whilecount);

		// get RH measurement results
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 6); for (int i=0; i<50000; i++);
		//xil_printf("\n\r%02x %02x %02x %02x %02x %02x\n\r", rx_ptr[0], rx_ptr[1], rx_ptr[2], rx_ptr[3], rx_ptr[4], rx_ptr[5]);
		tc = (rx_ptr[0] <<8) | (rx_ptr[1] << 0);
		rh = (rx_ptr[3] <<8) | (rx_ptr[4] << 0);
		//xil_printf("tc=0x%04x, rh=0x%04x\n\r", tc, rh);
		tempC = -45.0+175.0*tc/65535.0;
		humR  = 100.0*rh/65535.0;
		xil_printf("Temp C = %d,  Rel Hum = %d\n\r", (int)(tempC), (int)(humR) );
		regptr[RHT_SENSOR] = (rh<<16) | tc;



		// read the POT stored EEPROM value.
		XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_DIGIPOT);
		tx_ptr[0] = 0x20;
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
		dpot_stored = rx_ptr[0];
		xil_printf("POT Stored EEPROM value = 0x%02x\n\r", dpot_stored);

		// read the POT rdac value.
		tx_ptr[0] = 0x00;
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
		dpot_rdac = rx_ptr[0];
		xil_printf("POT rdac value = 0x%02x\n\r", dpot_rdac);

		// read the POT tolerance.
		tx_ptr[0] = 0x3e;
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 2); for (int i=0; i<50000; i++);
		if ((rx_ptr[0] & 0x10) == 0) {
			dpot_tol = +(((rx_ptr[0] & 0x7f)<<8) | (rx_ptr[1]<<0));
		} else {
			dpot_tol = -(((rx_ptr[0] & 0x7f)<<8) | (rx_ptr[1]<<0));
		}
		xil_printf("POT Tolerance = 0x%02x%02x = %d.%d%%\n\r", rx_ptr[0], rx_ptr[1], dpot_tol/256, (int)(1000.0*(dpot_tol&0x00ff)/256.0));

		regptr[DPOT_VALUE] = (dpot_tol<<16) | (dpot_stored<<0);

		if ((regptr[DPOT_CONTROL] & 0x0100) != 0) { // is there a request to change the DPOT setting?
			dpot_desired = regptr[DPOT_CONTROL] & 0x00ff;
			xil_printf("**** Programming Digital Potentiometer with 0x%02x\n\r", dpot_desired);
			// write rdac value
			tx_ptr[0] = 0x00; tx_ptr[1] = dpot_desired;
			tx_status = XIic_MasterSend(&Iic, tx_ptr, 2); for (int i=0; i<50000; i++);
			// transfer rdac to eeprom
			tx_ptr[0] = 0xc0;
			tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
			regptr[DPOT_CONTROL] = 0x0100; // clear the semaphore
		}


		// magnetometer
		XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_MAG);
		tx_ptr[0] = 0x68;  // mag output start address
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 8); for (int i=0; i<50000; i++);
//		for (int i=0; i<8; i++) {
//			xil_printf("0x%02x, ",rx_ptr[i]);
//		}
//		xil_printf("\n\r");
		mag_x    = (rx_ptr[1]<<8) | ( rx_ptr[0]<<0);
		mag_y    = (rx_ptr[3]<<8) | ( rx_ptr[2]<<0);
		mag_z    = (rx_ptr[5]<<8) | ( rx_ptr[4]<<0);
		mag_temp = (rx_ptr[7]<<8) | ( rx_ptr[6]<<0);
//		xil_printf("%04x  %04x  %04x  %04x\n\r", mag_x, mag_y, mag_z, mag_temp);
		xil_printf("magnetometer: x=%d, y=%d, z=%d, temp=%d\n\r", (int16_t)mag_x, (int16_t)mag_y, (int16_t)mag_z, (int)round(10.0*(((int16_t)mag_temp)/8.0+25.0)));
		regptr[MAG_Y_X]    = (mag_y<<16)    | mag_x;
		regptr[MAG_TEMP_Z] = (mag_temp<<16) | mag_z;
//		xil_printf("%08x  %08x\n\r", regptr[MAG_Y_X], regptr[MAG_TEMP_Z]);
		
		
		// gyro
		XIic_SetAddress(&Iic, XII_ADDR_TO_SEND_TYPE, I2C_GYRO);
//		tx_ptr[0] = 0x0f;  // whoami
//		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
//		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 1); for (int i=0; i<50000; i++);
//		xil_printf("gyro whoami = 0x%02x\n\r",rx_ptr[0]);
		tx_ptr[0] = 0x20;  // sensors
		tx_status = XIic_MasterSend(&Iic, tx_ptr, 1); for (int i=0; i<50000; i++);
		rx_status = XIic_MasterRecv(&Iic, rx_ptr, 14); for (int i=0; i<50000; i++);
		gyro_temp = (rx_ptr[1]<<8) | rx_ptr[0];
//		xil_printf("gyro temp = 0x%04x = %d\n\r", gyro_temp, (int)(1000.0*(gyro_temp/256.0+25.0)));
		gyro_temp_frac = modff(gyro_temp/256.0+25.0, &gyro_temp_int);
		xil_printf("gyro temperature = %d.%3d\n\r", (int)gyro_temp_int, (int)(gyro_temp_frac*1000.0));
//		for (int i=0; i<14; i++) {
//			xil_printf("%02x  ", rx_ptr[i]);
//		}
//		xil_printf("\n\r");
		gyro_gyro_x = (rx_ptr[3]<<8) | rx_ptr[2];
		gyro_gyro_y = (rx_ptr[5]<<8) | rx_ptr[4];
		gyro_gyro_z = (rx_ptr[7]<<8) | rx_ptr[6];
		gyro_accel_x = (rx_ptr[9]<<8) | rx_ptr[8];
		gyro_accel_y = (rx_ptr[11]<<8) | rx_ptr[10];
		gyro_accel_z = (rx_ptr[13]<<8) | rx_ptr[12];
		regptr[GYRO_TEMP] = 0x0000ffff & gyro_temp;
		regptr[GYRO_ACCEL_YX] = ((0x0000ffff & gyro_accel_y)<<16) | (0x0000ffff & gyro_accel_x);
		regptr[GYRO_ACCEL_Z]  = 0x0000ffff & gyro_accel_z;
		regptr[GYRO_GYRO_YX]  = ((0x0000ffff & gyro_gyro_y)<<16) | (0x0000ffff & gyro_gyro_x);
		regptr[GYRO_GYRO_Z]   = 0x0000ffff & gyro_gyro_z;		
		xil_printf("gyro: temp = %d, accel = %d, %d, %d, gyro = %d, %d, %d\n\r",
			gyro_temp, gyro_accel_x, gyro_accel_y, gyro_accel_z, gyro_gyro_x, gyro_gyro_y, gyro_gyro_z);


		whilecount++;
	}
	
	return(0);

}


static void RecvHandler(void *CallbackRef, int ByteCount)
{
	HandlerInfo.RemainingRecvBytes = ByteCount;
	HandlerInfo.RecvBytesUpdated = TRUE;
}

static void SendHandler(void *CallbackRef, int ByteCount)
{
	HandlerInfo.RemainingSendBytes = ByteCount;
	HandlerInfo.SendBytesUpdated = TRUE;
}

static void StatusHandler(void *CallbackRef, int Status)
{
	HandlerInfo.EventStatus |= Status;
	HandlerInfo.EventStatusUpdated = TRUE;
}

