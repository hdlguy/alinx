# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force -part xczu2cg-sfvc784-1-e proj 
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

#set_property  ip_repo_paths ../../hls/cholesky_inverse/csynth/solution1/impl/ip/ [current_project]
#update_ip_catalog

#read_ip ../source/gps_synthesizer/doppler_rom/doppler_rom.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

# make the Zynq block diagram
#source ../source/system.tcl
#generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
#set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]
#write_hwdef -force -verbose ./results/system.hdf

# Read in the hdl source.
read_verilog -sv ../rtl/gng_coef.v  
read_verilog -sv ../rtl/gng_ctg.v  
read_verilog -sv ../rtl/gng_interp.v  
read_verilog -sv ../rtl/gng_lzd.v  
read_verilog -sv ../rtl/gng_smul_16_18_sadd_37.v  
read_verilog -sv ../rtl/gng_smul_16_18.v  
read_verilog -sv ../rtl/gng.v

read_verilog -sv ../tb/tb_gng.sv
add_files -fileset sim_1 -norecurse ./tb_gng_behav.wcfg

#read_verilog -sv ../rtl/gng_cmplx.sv
#read_verilog -sv ../tb/tb_gng_cmplx.sv
#add_files -fileset sim_1 -norecurse ./tb_gng_cmplx_behav.wcfg


close_project

#########################



