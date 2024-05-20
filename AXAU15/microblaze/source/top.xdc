
create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports {sysclk_p}]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IBUFDS_sysclk/O]


set_max_delay -to [get_ports {led[*]}]            21.112
set_max_delay -to [get_ports {usb_uart_txd}]      21.112


set_input_delay -clock [get_clocks {sysclk}] -min -add_delay 0 [get_ports {usb_uart_rxd}]
set_input_delay -clock [get_clocks {sysclk}] -min -add_delay 0 [get_ports {resetn}]


set_property IOSTANDARD LVCMOS18    [get_ports {led[*]}]
set_property PACKAGE_PIN AC16       [get_ports led[1]]
set_property PACKAGE_PIN W21        [get_ports led[0]]

set_property IOSTANDARD LVDS        [get_ports {sysclk_*}]
set_property DIFF_TERM  TRUE        [get_ports {sysclk_*}]
set_property PACKAGE_PIN T24        [get_ports sysclk_p]
set_property PACKAGE_PIN U24        [get_ports sysclk_n]

set_property IOSTANDARD LVCMOS18    [get_ports {resetn}]
set_property PACKAGE_PIN N26        [get_ports resetn]

set_property IOSTANDARD LVCMOS33    [get_ports {usb_uart_*}]
set_property PACKAGE_PIN A13        [get_ports usb_uart_txd]
set_property PACKAGE_PIN A12        [get_ports usb_uart_rxd]

##################

#set_property PACKAGE_PIN G25        [get_ports {ddr4_adr[0]}]
#set_property PACKAGE_PIN M26        [get_ports {ddr4_adr[1]}]
#set_property PACKAGE_PIN L25        [get_ports {ddr4_adr[2]}]
#set_property PACKAGE_PIN E26        [get_ports {ddr4_adr[3]}]
#set_property PACKAGE_PIN M25        [get_ports {ddr4_adr[4]}]
#set_property PACKAGE_PIN F22        [get_ports {ddr4_adr[5]}]
#set_property PACKAGE_PIN H26        [get_ports {ddr4_adr[6]}]
#set_property PACKAGE_PIN F24        [get_ports {ddr4_adr[7]}]
#set_property PACKAGE_PIN G26        [get_ports {ddr4_adr[8]}]
#set_property PACKAGE_PIN J23        [get_ports {ddr4_adr[9]}]
#set_property PACKAGE_PIN J25        [get_ports {ddr4_adr[10]}]
#set_property PACKAGE_PIN J24        [get_ports {ddr4_adr[11]}]
#set_property PACKAGE_PIN F25        [get_ports {ddr4_adr[12]}]
#set_property PACKAGE_PIN H24        [get_ports {ddr4_adr[13]}]
#set_property PACKAGE_PIN K26        [get_ports {ddr4_adr[14]}]
#set_property PACKAGE_PIN H22        [get_ports {ddr4_adr[15]}]
#set_property PACKAGE_PIN H21        [get_ports {ddr4_adr[16]}]
#set_property PACKAGE_PIN J26        [get_ports {ddr4_ba[1]}]
#set_property PACKAGE_PIN G22        [get_ports {ddr4_ba[0]}]
#set_property PACKAGE_PIN L22        [get_ports {ddr4_bg[0]}]
#set_property PACKAGE_PIN L23        [get_ports {ddr4_cke[0]}]
#set_property PACKAGE_PIN H23        [get_ports {ddr4_cs_n[0]}]
#set_property PACKAGE_PIN L18        [get_ports {ddr4_dm_n[1]}]
#set_property PACKAGE_PIN E25        [get_ports {ddr4_dm_n[0]}]
#set_property PACKAGE_PIN K21        [get_ports {ddr4_dq[15]}]
#set_property PACKAGE_PIN K20        [get_ports {ddr4_dq[14]}]
#set_property PACKAGE_PIN J21        [get_ports {ddr4_dq[13]}]
#set_property PACKAGE_PIN L20        [get_ports {ddr4_dq[12]}]
#set_property PACKAGE_PIN M21        [get_ports {ddr4_dq[11]}]
#set_property PACKAGE_PIN J19        [get_ports {ddr4_dq[10]}]
#set_property PACKAGE_PIN J20        [get_ports {ddr4_dq[9]}]
#set_property PACKAGE_PIN M20        [get_ports {ddr4_dq[8]}]
#set_property PACKAGE_PIN C26        [get_ports {ddr4_dq[7]}]
#set_property PACKAGE_PIN B25        [get_ports {ddr4_dq[6]}]
#set_property PACKAGE_PIN D26        [get_ports {ddr4_dq[5]}]
#set_property PACKAGE_PIN D24        [get_ports {ddr4_dq[4]}]
#set_property PACKAGE_PIN B26        [get_ports {ddr4_dq[3]}]
#set_property PACKAGE_PIN E23        [get_ports {ddr4_dq[2]}]
#set_property PACKAGE_PIN D25        [get_ports {ddr4_dq[1]}]
#set_property PACKAGE_PIN F23        [get_ports {ddr4_dq[0]}]
#set_property PACKAGE_PIN M24        [get_ports {ddr4_odt[0]}]
#set_property PACKAGE_PIN G24        [get_ports ddr4_reset_n]
#set_property PACKAGE_PIN K25        [get_ports ddr4_act_n]
#set_property PACKAGE_PIN D23        [get_ports {ddr4_dqs_t[0]}]
#set_property PACKAGE_PIN M19        [get_ports {ddr4_dqs_t[1]}]
#set_property PACKAGE_PIN K22        [get_ports {ddr4_ck_t[0]}]

#set_property IOSTANDARD DIFF_SSTL12_DCI [get_ports {ddr4_ck_t[0]}]
#set_property IOSTANDARD POD12_DCI   [get_ports  ddr4_reset_n]
#set_property IOSTANDARD SSTL12_DCI  [get_ports  ddr4_act_n]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_odt[0]}]

#set_property IOSTANDARD POD12_DCI   [get_ports {ddr4_dm_n[*]}]
#set_property IOSTANDARD POD12_DCI   [get_ports {ddr4_dq[*]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_cs_n[0]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_cke[0]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_bg[0]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_ba[0]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_ba[1]}]
#set_property IOSTANDARD SSTL12_DCI  [get_ports {ddr4_adr[*]}]

