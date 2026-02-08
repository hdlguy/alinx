# vitis -s setup.py hello1
# vitis --workspace ./workspace/

import vitis
import os
import sys

app_name = "hello1"
#app_name = sys.argv[1]
print("app_name = ", app_name)

plat_name = "standalone_plat"
hw_xsa = "../implement/results/top.xsa"
cpu_name = "microblaze_0"
#cpu_name = "ps7_cortexa9_0"
#cpu_name = "psu_cortexa53_0"

os.system('rm -rf workspace')

client = vitis.create_client()
client.set_workspace(path="workspace")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(
    name = plat_name,
    hw_design = hw_xsa,
    os = "standalone",
    cpu = cpu_name,
    domain_name = "standalone_domain_0",
    generate_dtb = False,
    advanced_options = advanced_options,
    compiler = "gcc"
)

#platform = client.get_component(name=plat_name)

status = platform.build()

# create empty application
comp = client.create_app_component(
    name=app_name,
    platform = "./workspace/standalone_plat/export/standalone_plat/standalone_plat.xpfm",
    domain = "standalone_domain_0",
    template = "empty_application"
)

# import source files by reference
comp.import_files(from_loc = f"./src/{app_name}/",  files = ["test.c"], is_skip_copy_sources=True)
comp.import_files(from_loc = f"./src/",             files = ["fpga.h"], is_skip_copy_sources=True)

status = comp.clean()
status = platform.build()
comp.build()
vitis.dispose()

