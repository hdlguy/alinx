# Script to compile the FPGA all the way to bit file.
close_project -quiet
file delete -force results
file mkdir ./results

open_project proj.xpr
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

launch_runs impl_1 -jobs 8
wait_on_run impl_1

open_run impl_1
write_debug_probes -force ./results/top.ltx
report_timing_summary   -file ./results/timing.rpt
report_utilization      -file ./results/utilization.rpt
report_io               -file ./results/io.rpt

set_property BITSTREAM.GENERAL.COMPRESS TRUE [get_designs impl_1]
write_bitstream -bin_file -force ./results/top.bit

file copy ./results/top.bit ./proj.runs/impl_1/ 
write_hw_platform -fixed -include_bit -force -file ./results/top.xsa

close_project

exec bootgen -image bitstream.bif -arch zynqmp -o ./results/top.bit.bin -w

#file delete -force ./results/sdt
#exec sdtgen -eval "set_dt_param -dir ./results/sdt -xsa ./results/top.xsa; generate_sdt;"

#write_cfgmem -disablebitswap -force -format BIN -size 256 -interface SMAPx32 -loadbit "up 0x0 ./results/top.bit" -verbose ./results/top.bit.bin

