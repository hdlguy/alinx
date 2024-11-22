# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property part xczu2cg-sfvc784-1-e [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

#read_ip ../source/top_ila/top_ila.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

#source ../source/system.tcl
#generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
#set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

#read_verilog -sv ../source/axi_regfile/axi_regfile_v1_0_S00_AXI.sv

read_verilog -sv ../source/alexforencich/rgmii_phy_if.v
read_verilog -sv ../source/alexforencich/ssio_ddr_in.v
read_verilog -sv ../source/alexforencich/iddr.v
read_verilog -sv ../source/alexforencich/oddr.v
read_verilog -sv ../source/alexforencich/eth_mac_1g.v
read_verilog -sv ../source/alexforencich/axis_gmii_rx.v
read_verilog -sv ../source/alexforencich/lfsr.v
read_verilog -sv ../source/alexforencich/axis_gmii_tx.v
read_verilog -sv ../source/alexforencich/eth_axis_rx.v
read_verilog -sv ../source/alexforencich/eth_axis_tx.v
read_verilog -sv ../source/alexforencich/udp_complete.v

read_verilog -sv ../source/alexforencich/eth_mac_1g_rgmii_fifo.v
read_verilog -sv ../source/alexforencich/eth_mac_1g_rgmii.v
read_verilog -sv ../source/alexforencich/mac_ctrl_tx.v
read_verilog -sv ../source/alexforencich/mac_ctrl_rx.v
read_verilog -sv ../source/alexforencich/mac_pause_ctrl_tx.v
read_verilog -sv ../source/alexforencich/mac_pause_ctrl_rx.v
read_verilog -sv ../source/alexforencich/ip_arb_mux.v
read_verilog -sv ../source/alexforencich/ip_complete.v
read_verilog -sv ../source/alexforencich/eth_arb_mux.v
read_verilog -sv ../source/alexforencich/ip.v
read_verilog -sv ../source/alexforencich/ip_eth_rx.v
read_verilog -sv ../source/alexforencich/ip_eth_tx.v
read_verilog -sv ../source/alexforencich/arp.v
read_verilog -sv ../source/alexforencich/arp_eth_rx.v
read_verilog -sv ../source/alexforencich/arp_eth_tx.v
read_verilog -sv ../source/alexforencich/arp_cache.v
read_verilog -sv ../source/alexforencich/udp_checksum_gen.v
read_verilog -sv ../source/alexforencich/udp_ip_rx.v
read_verilog -sv ../source/alexforencich/udp_ip_tx.v
read_verilog -sv ../source/alexforencich/udp.v

read_verilog -sv ../source/axis/rtl/axis_async_fifo.v
read_verilog -sv ../source/axis/rtl/axis_async_fifo_adapter.v
read_verilog -sv ../source/axis/rtl/axis_adapter.v
read_verilog -sv ../source/axis/rtl/axis_fifo.v
read_verilog -sv ../source/axis/rtl/arbiter.v
read_verilog -sv ../source/axis/rtl/priority_encoder.v

read_verilog -sv ../source/fpga_core.sv
read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc

#set_property used_in_synthesis false [get_files ../source/top.xdc]

close_project

#########################



