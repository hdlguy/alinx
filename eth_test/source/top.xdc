
create_clock -period 5.000 -name clkin200_p     -waveform {0.00 2.50}  [get_ports clkin200_p]
create_clock -period 8.000 -name eth_mii_rx_clk -waveform {0.00 4.00}  [get_ports eth_mii_rx_clk]
#create_clock -period 8.000 -name eth_mii_tx_clk [get_ports eth_mii_tx_clk]

set_property IOSTANDARD DIFF_HSTL_I_12  [get_ports {clkin200_*}]
set_property ODT RTT_NONE               [get_ports {clkin200_*}]
set_property PACKAGE_PIN AE5            [get_ports clkin200_p]
set_property PACKAGE_PIN AF5            [get_ports clkin200_n]

set_property IOSTANDARD LVCMOS33    [get_ports led]
set_property PACKAGE_PIN AE12       [get_ports led]

set_property IOSTANDARD LVCMOS33    [get_ports fan_pwm]
set_property PACKAGE_PIN AA11       [get_ports fan_pwm]

set_property IOSTANDARD LVCMOS18    [get_ports eth_mii_*]
set_property PACKAGE_PIN A7         [get_ports eth_mii_tx_clk]
set_property PACKAGE_PIN A8         [get_ports eth_mii_txd[3]]
set_property PACKAGE_PIN A9         [get_ports eth_mii_txd[2]]
set_property PACKAGE_PIN D9         [get_ports eth_mii_txd[1]]
set_property PACKAGE_PIN E9         [get_ports eth_mii_txd[0]]
set_property PACKAGE_PIN B9         [get_ports eth_mii_tx_ctl]

set_property PACKAGE_PIN E5         [get_ports eth_mii_rx_clk]
set_property PACKAGE_PIN C9         [get_ports eth_mii_rxd[3]]
set_property PACKAGE_PIN F8         [get_ports eth_mii_rxd[2]]
set_property PACKAGE_PIN B5         [get_ports eth_mii_rxd[1]]
set_property PACKAGE_PIN A5         [get_ports eth_mii_rxd[0]]
set_property PACKAGE_PIN B8         [get_ports eth_mii_rx_ctl]

set_property PACKAGE_PIN D5         [get_ports eth_mii_rst_n]

set_property IOB TRUE [get_ports eth_mii_rxd[*]]
set_property IOB TRUE [get_ports eth_mii_rx_ctl]

set_property IOB TRUE [get_ports eth_mii_txd[*]]
set_property IOB TRUE [get_ports eth_mii_tx_ctl]
set_property IOB TRUE [get_ports eth_mii_tx_clk]

#set_property PACKAGE_PIN A6         [get_ports eth_mii_mdc]
#set_property PACKAGE_PIN C8         [get_ports eth_mii_mdio]


set_max_delay -to [get_ports {led}]    16.666
set_min_delay -to [get_ports {led}]    0.0

set_max_delay -to [get_ports {fan_pwm}]    16.666
set_min_delay -to [get_ports {fan_pwm}]    0.0

set_input_delay -clock [get_clocks {eth_mii_rx_clk}] -clock_fall    -min -add_delay 3.0 [get_ports {eth_mii_rxd[*]}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}] -clock_fall    -max -add_delay 3.9 [get_ports {eth_mii_rxd[*]}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}]                -min -add_delay 3.0 [get_ports {eth_mii_rxd[*]}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}]                -max -add_delay 3.9 [get_ports {eth_mii_rxd[*]}]

set_input_delay -clock [get_clocks {eth_mii_rx_clk}] -clock_fall    -min -add_delay 3.0 [get_ports {eth_mii_rx_ctl}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}] -clock_fall    -max -add_delay 3.9 [get_ports {eth_mii_rx_ctl}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}]                -min -add_delay 3.0 [get_ports {eth_mii_rx_ctl}]
set_input_delay -clock [get_clocks {eth_mii_rx_clk}]                -max -add_delay 3.9 [get_ports {eth_mii_rx_ctl}]

#set_output_delay -clock [get_clocks {eth_mii_tx_clk}] -clock_fall   -min -add_delay 0.1 [get_ports {eth_mii_txd[*]}]
#set_output_delay -clock [get_clocks {eth_mii_tx_clk}] -clock_fall   -max -add_delay 3.8 [get_ports {eth_mii_txd[*]}]
#set_output_delay -clock [get_clocks {eth_mii_tx_clk}]               -min -add_delay 0.1 [get_ports {eth_mii_txd[*]}]
#set_output_delay -clock [get_clocks {eth_mii_tx_clk}]               -max -add_delay 3.8 [get_ports {eth_mii_txd[*]}]

set_max_delay -to [get_ports {eth_mii_txd[*]}]    16.666
set_min_delay -to [get_ports {eth_mii_txd[*]}]    0.0
set_max_delay -to [get_ports {eth_mii_rst_n}]     16.666
set_min_delay -to [get_ports {eth_mii_rst_n}]     0.0
set_max_delay -to [get_ports {eth_mii_tx_clk}]    16.666
set_min_delay -to [get_ports {eth_mii_tx_clk}]    0.0
set_max_delay -to [get_ports {eth_mii_tx_ctl}]    16.666
set_min_delay -to [get_ports {eth_mii_tx_ctl}]    0.0

