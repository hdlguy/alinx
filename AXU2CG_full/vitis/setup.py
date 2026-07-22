# vitis -s setup.py hello1
# vitis -w workspace

import vitis
import sys
import shutil
import subprocess
import stat
import os
from pathlib import Path

app_name = sys.argv[1]
print("app_name = ", app_name, "\n")

plat_name = "standalone_plat"
hw_xsa = "../implement/results/top.xsa"
#cpu_name = "microblaze_0"
cpu_name = "psu_cortexa53_0"

def handle_rm_error(func, path, exc_info):
    try:
        os.chmod(path, stat.S_IWRITE)
        func(path)
    except:
        # this seems to always fail on workspace since _ide is restricted and held by vitis - this doesn't seem to break anything though
        print("failed to remove path after perms: " + path)

shutil.rmtree('workspace', ignore_errors=False, onerror=handle_rm_error)

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

status = platform.build()

# create empty application
comp = client.create_app_component(
    name=app_name,
    platform = str(Path("./workspace/standalone_plat/export/standalone_plat/standalone_plat.xpfm").resolve()),
    domain = "standalone_domain_0",
    template = "empty_application"
)

sources = []
for path in Path(f"src/{app_name}").rglob('*'):
    if path.is_file():
        if path.suffix == ".c":
            relative_path = os.path.relpath(path, "src/")
            sources.append(str(relative_path))

# adds the main file to the sources
comp.set_app_config(key='USER_COMPILE_SOURCES', values=sources)

def link_dir(target, link):
    if os.name == 'nt':
        subprocess.call(['mklink', '/J', link, target], shell=True)
    else:
        link.symlink_to(target)

# add source folders as symbolic links
link_dir(Path(f"src/common_headers").resolve(), Path(f"workspace/{app_name}/src/common_headers").resolve())
link_dir(Path(f"src/{app_name}").resolve(),     Path(f"workspace/{app_name}/src/{app_name}").resolve())

status = comp.clean()
status = platform.build()
comp.build()
vitis.dispose()

