# Script to compile the FPGA all the way to bit file.
close_project -quiet

open_project proj.xpr
update_compile_order -fileset sources_1

if {[get_property NEEDS_REFRESH [get_runs synth_1]]} {
    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    open_run synth_1
    report_drc                  -file ./results/post_synth_drc.rpt
}

reset_run impl_1
launch_runs impl_1 -jobs 4
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

open_run impl_1
write_debug_probes -force               ./results/top.ltx
write_hw_platform -fixed -force -file   ./results/top.xsa
report_timing_summary   -file           ./results/timing.rpt
report_utilization      -file           ./results/utilization.rpt
report_io               -file           ./results/io.rpt

write_bitstream -bin_file -force ./results/top.bit

close_project

