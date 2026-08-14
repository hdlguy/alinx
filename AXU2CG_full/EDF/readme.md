# EDF Linux Build

## Put Vivado tools in path
source ~/vivado_setup

## Generate the sdt from the xsa
sdtgen -eval "set_dt_param -debug enable -zocl enable -dir ./hw_project_sdt -xsa ../implement/results/top.xsa; generate_sdt"

## Install latest repo tool
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
rm -rf ~/bin/repo 
mv repo ~/bin/
PATH=~/bin:$PATH
repo --help

## Init repo
mkdir edf
cd edf
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v25.11 -m default-edf.xml  
repo sync

## Init build
unset TEMPLATECONF
source edf-init-build-env

## Temporarily disable apparmor
sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns

## parse the sdt files from Vivado
gen-machine-conf --hw-description ../../hw_project_sdt/ parse-sdt

## Start build
MACHINE=zynqmp-generic-xczu2cg bitbake xilinx-bootbin



*****************************************

## parse the .xsa file from Vivado
gen-machine-conf --hw-description ../../../implement/results/top.xsa parse-xsa

source vivado 2025.2

sdtgen
set_dt_param -debug enable
set_dt_param -zocl enable
set_dt_param -dir ./hw_project_sdt
set_dt_param -xsa ../implement/results/top.xsa
generate_sdt
 
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
mkdir ~/bin
mv repo ~/bin/
PATH=~/bin:$PATH
repo --help

mkdir edf
cd edf
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v25.11 -m default-edf.xml  
repo sync

unset TEMPLATECONF
source edf-init-build-env

gen-machine-conf --hw-description ../../../implement/results/top.xsa parse-xsa
MACHINE=zynqmp-generic-xczu2cg bitbake xilinx-bootbin

gen-machine-conf --hw-description ../../hw_project_sdt/ parse-sdt
MACHINE=xlnx-zynqmp bitbake xilinx-bootbin

gen-machine-conf parse-sdt --hw-description ../hw_project_sdt -g full --add-config CONFIG_YOCTO_BBMC_CORTEXR52_1_BAREMETAL=y --add-config CONFIG_SUBSYSTEM_TF-A_SERIAL_SERIAL1_SELECT=y --add-config CONFIG_SUBSYSTEM_SERIAL_TF-A_IP_NAME="pl011_1" --add-config CONFIG_SUBSYSTEM_OP-TEE_SERIAL_SERIAL1_SELECT=y --add-config CONFIG_SUBSYSTEM_SERIAL_OP-TEE_IP_NAME="1" --add-config CONFIG_SUBSYSTEM_UBOOT_APPEND_BASEADDR=disable --add-config CONFIG_YOCTO_BBMC_MICROBLAZE_RISCV_ASU=disable -O versal-2ve-2vm-vek385-sdt-seg



sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns

MACHINE=<machine-name> bitbake xilinx-bootbin
MACHINE=zynqmp-zcu104-sdt-full bitbake xilinx-bootbin

MACHINE=amd-cortexa53-mali-common bitbake xilinx-bootbin
MACHINE=amd-cortexa53-mali-common bitbake meta-edf-app-sdk

MACHINE=amd-cortexa53-mali-common bitbake edf-linux-disk-image








*****************************
source vivado 2025.2

sdtgen
set_dt_param -debug enable
set_dt_param -zocl enable
set_dt_param -dir ./hw_project_sdt
set_dt_param -xsa ../implement/results/top.xsa
set_dt_param -board_dts versal2-vek385-revb/versal2-vek385-reva
generate_sdt
 

curl https://storage.googleapis.com/git-repo-downloads/repo > repo

chmod a+x ./repo

./repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v25.11 -m default-edf.xml

./repo sync

source edf-init-build-env

gen-machine-conf parse-sdt --hw-description <path to sdt> -g full --add-config CONFIG_YOCTO_BBMC_CORTEXR52_1_BAREMETAL=y --add-config CONFIG_SUBSYSTEM_TF-A_SERIAL_SERIAL1_SELECT=y --add-config CONFIG_SUBSYSTEM_SERIAL_TF-A_IP_NAME="pl011_1" --add-config CONFIG_SUBSYSTEM_OP-TEE_SERIAL_SERIAL1_SELECT=y --add-config CONFIG_SUBSYSTEM_SERIAL_OP-TEE_IP_NAME="1" --add-config CONFIG_SUBSYSTEM_UBOOT_APPEND_BASEADDR=disable --add-config CONFIG_YOCTO_BBMC_MICROBLAZE_RISCV_ASU=disable -O versal-2ve-2vm-vek385-sdt-seg

MACHINE=<machine name> bitbake xilinx-bootbin

MACHINE=amd-cortexa78-mali-common bitbake edf-linux-disk-image
***********************************

