
create_clock -period 5.000 -name clkin200_p -waveform {0.000 2.500} [get_ports clkin200_p]

set_property IOSTANDARD DIFF_HSTL_I_12  [get_ports {clkin200_*}]
set_property ODT RTT_NONE               [get_ports {clkin200_*}]
set_property PACKAGE_PIN AE5            [get_ports clkin200_p]
set_property PACKAGE_PIN AF5            [get_ports clkin200_n]

set_property IOSTANDARD LVCMOS33    [get_ports {uart_*}]
set_property PACKAGE_PIN AH12       [get_ports uart_txd]
set_property PACKAGE_PIN AH11       [get_ports uart_rxd]


set_property IOSTANDARD LVCMOS33    [get_ports pl_led1]
set_property PACKAGE_PIN AE12       [get_ports pl_led1]

set_property IOSTANDARD LVCMOS33    [get_ports fan_pwm]
set_property PACKAGE_PIN AA11       [get_ports fan_pwm]


set_max_delay -to [get_ports {fan_pwm}]    16.666
set_max_delay -to [get_ports {pl_led1}]    16.666
set_max_delay -to [get_ports {uart_txd}]   16.666

set_max_delay -from [get_ports {uart_rxd}] 16.666
set_min_delay -from [get_ports {uart_rxd}] 16.666

