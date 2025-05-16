# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force -part xczu2cg-sfvc784-1-e proj 
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]

#read_ip ../dgen_rom/dgen_rom.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

read_verilog -sv ../../iir_verilog/iir_filter.sv
read_verilog -sv ../../iir_verilog/iir_sos_dsp48.sv
read_verilog -sv ../../iir_verilog/round_n_sat.sv
read_verilog -sv ../../iir_verilog/iir_mult_accum.sv

read_verilog -sv ../../gng/rtl/gng_coef.v  
read_verilog -sv ../../gng/rtl/gng_ctg.v  
read_verilog -sv ../../gng/rtl/gng_interp.v  
read_verilog -sv ../../gng/rtl/gng_lzd.v  
read_verilog -sv ../../gng/rtl/gng_smul_16_18_sadd_37.v  
read_verilog -sv ../../gng/rtl/gng_smul_16_18.v  
read_verilog -sv ../../gng/rtl/gng.v

read_verilog -sv ../source/vsource.sv  
read_verilog -sv ../source/vinstru.sv  
read_verilog -sv ../source/vinstru_tb.sv  

add_files -fileset sim_1 -norecurse ./vinstru_tb_behav.wcfg

close_project

#########################



