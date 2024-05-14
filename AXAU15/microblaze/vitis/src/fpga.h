#define 	REG_BASEADDR 		XPAR_M00_AXI_BASEADDR

// define AXI registers
#define     Nreg                64  // number of 32 bit AXI registers

#define 	FPGA_VERSION		0	// currently 0x07010100
#define		FPGA_ID				1	// currently 0xdeadbeef

#define		LED_CONTROL			2	// [3:0] = [blue, green, yellow, red].

#define     TEC_CONTROL         3   // [0] = TEC Enable, [4] = TEC 1 COOL/HEATn, [8] = TEC 2 COOL/HEATn

#define     HV_CONTROL          4   // [0] = HV Enable

#define     FREE_COUNT          5   // [31:0] = free running 100MHz counter

#define		UNUSED6				6
#define		UNUSED7				7

#define     FAN_SPEED0          8	// [31:0] = speed indication from the tachometer
#define     FAN_SPEED1          9
#define     FAN_SPEED2          10
#define     FAN_SPEED3          11
// The fan speed registers report the number of 100MHz counts between tach pulses from the fan.
// rpm = 30.0*(100.0e6/FAN_SPEEDx)
// below 100 rpm the register reports 0.


#define		FAN_PWM3210			12 	// [7:0] = pwm 0, [15:8] = pwm 1, ...
#define		FAN_PWM4			13	// [7:0] = pwm 4
// Load the pwm fields with the one's complement of the pwm value you want.
// For example if you want 25% duty factor 0.25*256 = 64 = 0x40= 0100_0000, so load the value ~0x40 = 0xBf = 1011_1111.


// DAC values written here will go out the DACs at the next opportunity.
// ADC values read here are from the latest ADC conversion.
// 16-bit values are packed into the 32-bit software accessible registers.
// "not used" DAC values are controled by UDP.
#define		AMC0_ADC1_0			14	// [31:16] = amc0, adc1, [15:0] = amc0, adc0, read-only
#define		AMC0_ADC3_2			15	// [31:16] = amc0, adc3, [15:0] = amc0, adc2, read-only
#define		AMC0_ADC5_4			16	// [31:16] = amc0, adc5, [15:0] = amc0, adc4, read-only
#define		AMC0_ADC7_6			17	// [31:16] = amc0, adc7, [15:0] = amc0, adc6, read-only
#define		AMC0_GPIO_ADC8		18	// [31:16] = amc0, gpio, [15:0] = amc0, adc8, read-only

#define		AMC1_ADC1_0			19	// [31:16] = amc1, adc1, [15:0] = amc1, adc0, read-only
#define		AMC1_ADC3_2			20	// [31:16] = amc1, adc3, [15:0] = amc1, adc2, read-only
#define		AMC1_ADC5_4			21	// [31:16] = amc1, adc5, [15:0] = amc1, adc4, read-only
#define		AMC1_ADC7_6			22	// [31:16] = amc1, adc7, [15:0] = amc1, adc6, read-only
#define		AMC1_GPIO_ADC8		23	// [31:16] = amc1, gpio, [15:0] = amc1, adc8, read-only

#define		AMC0_DAC1_0			24	// [31:16] = amc0, dac1, [15:0] = amc0, dac0
#define		AMC0_DAC3_2			25	// [31:16] = amc0, dac3, [15:0] = amc0, dac2
#define		AMC0_DAC5_4			26	// [31:16] = amc0, dac5, [15:0] = amc0, dac4
#define		AMC0_DAC7_6			27	// [31:16] = not used,   [15:0] = amc0, dac6

#define		AMC1_DAC1_0			28	// [31:16] = amc1, dac1, [15:0] = amc1, dac0
#define		AMC1_DAC3_2			29	// [31:16] = amc1, dac3, [15:0] = not used,   
#define		AMC1_DAC5_4			30	// [31:16] = amc1, dac5, [15:0] = amc1, dac4
#define		AMC1_DAC7_6			31	// [31:16] = not used,   [15:0] = amc1, dac6

#define		UNUSED32			32

#define		DPOT_VALUE			33	// [31:16] = dpot tolerance, [7:0] = dpot stored value
#define		DPOT_CONTROL		34	// [7:0] = dpot value to be written, [8] = dpot write/busy

#define		RHT_SENSOR			35  // SHT35-DIS-F2.5KS sensor
// [15: 0] = temperature
// [31:16] = humidity

#define		MAG_Y_X 			36
#define		MAG_TEMP_Z			37

#define		GYRO_TEMP			38
#define		GYRO_ACCEL_YX		39
#define		GYRO_ACCEL_Z		40
#define		GYRO_GYRO_YX		41
#define		GYRO_GYRO_Z			42
#define		UNUSED43			43
#define		UNUSED44			44
#define		UNUSED45			45
#define		UNUSED46			46
#define		UNUSED47			47
#define		UNUSED48			48
#define		UNUSED49			49
#define		UNUSED50			50
#define		UNUSED51			51
#define		UNUSED52			52
#define		UNUSED53			53
#define		UNUSED54			54
#define		UNUSED55			55
#define		UNUSED56			56
#define		UNUSED57			57
#define		UNUSED58			58
#define		UNUSED59			59
#define		UNUSED60			60
#define		UNUSED61			61
#define		UNUSED62			62
#define		UNUSED63			63



//// AMC7823IRTAT SPI ADC/DAC
// DAC 1 channels
#define		THERM_BIAS1			0
#define		UNUSED_DAC1_1		1
#define		THERM_BIAS2			2
#define		THERM_BIAS4			3
#define		THERM_BIAS3			4
#define		UNUSED_DAC1_5		5
#define		SPARE_DAC			6
#define		PHOTON_TRIG			7
// ADC 1 channels
#define		TMON4_REAR			0
#define		EM_MON				1
#define		TMON1_COLD			2
#define		TMON2_HOT			3
#define		TMON3_AMB			4
#define 	VMON_HEATER			5
#define		VMON_TEC			6
#define		THERM_LC			7
// DAC 2 channels
#define		SET_HTRV			0
#define		UNUSED_DAC2_1		1
#define		DAC_LC				2
#define		THERM_BIAS5			3
#define		SET_TECV			4
#define		UNUSED_DAC2_5		5
#define		N5MON_BIAS			6
#define		PULSE_TRIG			7
// ADC 2 channels
#define		TMON5_FRONT			0
#define		VMON_5V				1  	// 2.446mV/bit
#define		VMON_12V			2	// 8.942mV/bit
#define		VMON_24V			3	// 8.942mV/bit
#define		VMON_N5V			4	// 2.500V - (4095-ADC) * 3.062mV/bit
#define		UNUSED_ADC2_5		5
#define		VMON_3V3			6	// 1.597mV/bit
#define		SPARE_ADC			7



// I2C 7-bit Addresses
#define     I2C_MAG             0x1E
#define     I2C_GYRO            0x6A
#define     I2C_HUMIDITY        0x44
#define     I2C_RTC             0x6F
#define     I2C_EEPROM          0x50
#define		I2C_DIGIPOT			0x18


// The AMC7823 has a free running controller that writes the DACs and reads the ADCs at the fastest practical rate.
