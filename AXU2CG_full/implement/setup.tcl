# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force -part xczu2cg-sfvc784-1-e proj 
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

read_ip ../source/top_ila/top_ila.xci
read_ip ../source/vinstru/source/vinstru_ila/vinstru_ila.xci
upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_verilog -sv ../../../iir_filter/verilog/iir_filter.sv
read_verilog -sv ../../../iir_filter/verilog/iir_sos_dsp48.sv
read_verilog -sv ../../../iir_filter/verilog/round_n_sat.sv
read_verilog -sv ../../../iir_filter/verilog/iir_mult_accum.sv

read_verilog -sv ../source/gng/rtl/gng_coef.v  
read_verilog -sv ../source/gng/rtl/gng_ctg.v  
read_verilog -sv ../source/gng/rtl/gng_interp.v  
read_verilog -sv ../source/gng/rtl/gng_lzd.v  
read_verilog -sv ../source/gng/rtl/gng_smul_16_18_sadd_37.v  
read_verilog -sv ../source/gng/rtl/gng_smul_16_18.v  
read_verilog -sv ../source/gng/rtl/gng.v

read_verilog -sv ../source/vinstru/source/vsource.sv  
read_verilog -sv ../source/vinstru/source/vinstru.sv  

read_verilog -sv ../source/mem_regfile/mem_regfile.sv
read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc

close_project

#########################



