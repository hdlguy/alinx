# run at linux command line 
#       xsct setup.tcl
#       vitis -workspace ./workspace
#
file delete -force ./workspace

set hw ../implement/results/top.xsa
#set proc "ps7_cortexa9_0"
#set proc "psu_cortexr5_0"
set proc "psu_cortexa53_0"
#set proc "microblaze_0"

setws ./workspace

platform create -name "standalone_plat" -hw $hw -proc $proc -os standalone
#platform create -name "freertos_plat" -hw $hw -proc $proc -os freertos

#app create -name hello1 -platform standalone_plat -domain standalone_domain -template "Empty Application(C)"
#file link -symbolic ./workspace/hello1/src/hello1.c             ../../../src/hello1/hello1.c
#file link -symbolic ./workspace/hello1/src/fpga.h               ../../../src/fpga.h
#file link -symbolic ./workspace/hello1/src/platform.c           ../../../src/hello1/platform.c
#file link -symbolic ./workspace/hello1/src/platform.h           ../../../src/hello1/platform.h
#file link -symbolic ./workspace/hello1/src/platform_config.h    ../../../src/hello1/platform_config.h
#file delete -force  ./workspace/hello1/src/lscript.ld
#file link -symbolic ./workspace/hello1/src/lscript.ld           ../../../src/hello1/lscript.ld



#app create -name freetest1 -platform freertos_plat -domain freertos_domain -template "Empty Application(C)"
#file link -symbolic ./workspace/freetest1/src/test.c             ../../../src/freetest1/test.c
#file delete -force  ./workspace/freetest1/src/lscript.ld
#file link -symbolic ./workspace/freetest1/src/lscript.ld         ../../../src/freetest1/lscript.ld


app build all


