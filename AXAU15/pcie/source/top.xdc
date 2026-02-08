set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

create_clock -period 5.000 -name sysclk    -waveform {0.000 2.500} [get_ports {sysclk_p}]
create_clock -period 10.00 -name pcirefclk -waveform {0.000 5.000} [get_ports {pcie_refclk_p}]

set_property IOSTANDARD LVCMOS18    [get_ports {led[*]}]
set_property PACKAGE_PIN AC16       [get_ports led[1]]
set_property PACKAGE_PIN W21        [get_ports led[0]]

set_property IOSTANDARD LVDS        [get_ports {sysclk_*}]
set_property PACKAGE_PIN T24        [get_ports sysclk_p]
set_property PACKAGE_PIN U24        [get_ports sysclk_n]

set_property IOSTANDARD LVCMOS18    [get_ports pcie_perstn]
set_property PACKAGE_PIN T19        [get_ports pcie_perstn]
set_property PACKAGE_PIN AB6        [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AB7        [get_ports pcie_refclk_p]

set_property PACKAGE_PIN AF2        [get_ports pcie_mgt_rxp[3]]
set_property PACKAGE_PIN AE4        [get_ports pcie_mgt_rxp[2]]
set_property PACKAGE_PIN AD2        [get_ports pcie_mgt_rxp[1]]
set_property PACKAGE_PIN AB2        [get_ports pcie_mgt_rxp[0]]

set_property PACKAGE_PIN AF7        [get_ports pcie_mgt_txp[3]]
set_property PACKAGE_PIN AE9        [get_ports pcie_mgt_txp[2]]
set_property PACKAGE_PIN AD7        [get_ports pcie_mgt_txp[1]]
set_property PACKAGE_PIN AC5        [get_ports pcie_mgt_txp[0]]

set_property PACKAGE_PIN AB7        [get_ports pcie_refclk_p]

###########
#set_property PACKAGE_PIN T24 [get_ports sys_clk_clk_p]
#set_property PACKAGE_PIN T19 [get_ports pcie_rstn]
#set_property PACKAGE_PIN AC16 [get_ports {led[0]}]
#set_property PACKAGE_PIN AB7 [get_ports {pcie_ref_clk_p[0]}]
#set_property PACKAGE_PIN AF2 [get_ports {pcie_mgt_rxp[3]}]
#set_property PACKAGE_PIN AE4 [get_ports {pcie_mgt_rxp[2]}]
#set_property PACKAGE_PIN AD2 [get_ports {pcie_mgt_rxp[1]}]
#set_property PACKAGE_PIN AB2 [get_ports {pcie_mgt_rxp[0]}]

#set_property PACKAGE_PIN AF7 [get_ports {pcie_mgt_txp[3]}]
#set_property PACKAGE_PIN AE9 [get_ports {pcie_mgt_txp[2]}]
#set_property PACKAGE_PIN AD7 [get_ports {pcie_mgt_txp[1]}]
#set_property PACKAGE_PIN AC5 [get_ports {pcie_mgt_txp[0]}]
