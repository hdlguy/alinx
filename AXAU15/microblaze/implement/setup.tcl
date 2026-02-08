# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs

create_project -part xcau15p-ffvb676-2-i -force proj 
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

#read_ip ../source/top_ila/top_ila.xci
#upgrade_ip -quiet  [get_ips *]
#generate_target {all} [get_ips *]

source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

read_verilog -sv ../source/mem_regfile.sv
read_verilog -sv ../source/top.sv

read_xdc ../source/top.xdc

#set_property used_in_synthesis false [get_files ../source/top.xdc]

add_files -norecurse ../vitis/release/production.elf
set_property SCOPED_TO_REF system [get_files -all -of_objects [get_fileset sources_1] {production.elf}]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] {production.elf}]

close_project

#########################



