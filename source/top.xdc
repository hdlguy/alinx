
set_property IOSTANDARD LVCMOS33    [get_ports {pl_led1}]
set_property PACKAGE_PIN AE12       [get_ports {pl_led1}]

set_property IOSTANDARD LVCMOS33    [get_ports {fan_pwm}]
set_property PACKAGE_PIN AA11       [get_ports {fan_pwm}]

create_clock -period 5.000 -name clkin200_p -waveform {0.000 2.500} [get_ports {clkin200_p}]

set_property IOSTANDARD DIFF_HSTL_I_12  [get_ports {list clkin200_*}]   ;# common mode voltage = 0.6 Volts
set_property ODT RTT_NONE               [get_ports {list clkin200_*}]   ;# 100 Ohm resistor on the board.
set_property PACKAGE_PIN AE5            [get_ports {clkin200_p}]
set_property PACKAGE_PIN AF5            [get_ports {clkin200_n}]

