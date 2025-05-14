# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property board_part em.avnet.com:ultrazed_eg_iocc_production:part0:1.0 [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

#read_ip ../dgen_rom/dgen_rom.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

read_verilog -sv ../../../iir/iir_filter.sv
read_verilog -sv ../../../iir/iir_sos_dsp48.sv
read_verilog -sv ../../../iir/round_n_sat.sv
read_verilog -sv ../../../iir/iir_mult_accum.sv

read_verilog -sv ../vinstru.sv  
read_verilog -sv ../vinstru_tb.sv  

add_files -fileset sim_1 -norecurse ./vinstru_tb_behav.wcfg

close_project

#########################



