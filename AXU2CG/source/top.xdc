
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


set_property IOSTANDARD LVCMOS18    [get_ports mdio_*]
set_property PACKAGE_PIN A6         [get_ports mdio_mdc]
set_property PACKAGE_PIN C8         [get_ports mdio_mdio]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports mdio_mdio]


set_property IOSTANDARD LVCMOS18    [get_ports rgmii_*]
set_property PACKAGE_PIN A7         [get_ports rgmii_txc]
set_property PACKAGE_PIN A8         [get_ports rgmii_txd[3]]
set_property PACKAGE_PIN A9         [get_ports rgmii_txd[2]]
set_property PACKAGE_PIN D9         [get_ports rgmii_txd[1]]
set_property PACKAGE_PIN E9         [get_ports rgmii_txd[0]]
set_property PACKAGE_PIN B9         [get_ports rgmii_tx_ctl]

set_property PACKAGE_PIN E5         [get_ports rgmii_rxc]
set_property PACKAGE_PIN C9         [get_ports rgmii_rxd[3]]
set_property PACKAGE_PIN F8         [get_ports rgmii_rxd[2]]
set_property PACKAGE_PIN B5         [get_ports rgmii_rxd[1]]
set_property PACKAGE_PIN A5         [get_ports rgmii_rxd[0]]
set_property PACKAGE_PIN B8         [get_ports rgmii_rx_ctl]

set_property PACKAGE_PIN D5         [get_ports rgmii_reset_n]

set_property IOB TRUE               [get_ports rgmii_rxd[*]]
set_property IOB TRUE               [get_ports rgmii_rx_ctl]

#set_property IOB TRUE               [get_ports rgmii_txd[*]]
#set_property IOB TRUE               [get_ports rgmii_tx_ctl]
#set_property IOB TRUE               [get_ports rgmii_txc]



set_max_delay -to [get_ports {fan_pwm}]    16.666
set_max_delay -to [get_ports {pl_led1}]    16.666
set_max_delay -to [get_ports {uart_txd}]   16.666

set_max_delay -from [get_ports {uart_rxd}] 16.666
set_min_delay -from [get_ports {uart_rxd}] 16.666

