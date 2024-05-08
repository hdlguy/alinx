
set_property IOSTANDARD LVCMOS18    [get_ports {led[*]}]
set_property PACKAGE_PIN AC16       [get_ports led[1]]
set_property PACKAGE_PIN W21        [get_ports led[0]]

set_property IOSTANDARD LVCMOS18    [get_ports pcie_perstn]
set_property PACKAGE_PIN T19        [get_ports pcie_perstn]
set_property PACKAGE_PIN AB6        [get_ports pcie_refclk_n]
set_property PACKAGE_PIN AB7        [get_ports pcie_refclk_p]
