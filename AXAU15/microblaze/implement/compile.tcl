# Script to compile the FPGA all the way to bit file.
close_project -quiet
file delete -force results
file mkdir ./results

open_project proj.xpr
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -jobs 8
wait_on_run impl_1

#if {[get_property NEEDS_REFRESH [get_runs synth_1]]} {
#    reset_run synth_1
#    launch_runs synth_1 -jobs 8
#    wait_on_run synth_1
#    open_run synth_1
#}

#if {[get_property NEEDS_REFRESH [get_runs impl_1]]} {
#    reset_run   impl_1
#    #launch_runs impl_1 -jobs 4 -to_step route_design
#    launch_runs impl_1 -jobs 8
#    wait_on_run impl_1
#    open_run    impl_1
#}

open_run impl_1

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 8.0 [current_design]
set_property BITSTREAM.Config.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

write_bitstream -bin_file -force ./proj.runs/impl_1/top.bit
write_hw_platform -include_bit -fixed -force -file ./results/top.xsa

write_debug_probes -force               ./results/top.ltx
report_io               -file           ./results/io.rpt
report_timing_summary   -file           ./results/timing.rpt
report_utilization      -file           ./results/utilization.rpt

close_project

