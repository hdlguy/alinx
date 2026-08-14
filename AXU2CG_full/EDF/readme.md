# EDF Linux Build from XSA

## Put Vivado 2026.1 tools in path
source /tools/Xilinx/2026.1/Vivado/settings64.sh; source /tools/Xilinx/2026.1/Vitis/settings64.sh;

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
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v25.11 -m default-edf.xml  ;#(for 2025.2)
repo init -u https://github.com/Xilinx/yocto-manifests.git -b refs/tags/amd-edf-rel-v26.06 -m default-edf.xml  ;#(for 2026.1)

repo sync

## Init build
unset TEMPLATECONF
source edf-init-build-env

## Temporarily disable apparmor
sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns

## parse the sdt files from Vivado
gen-machine-conf --hw-description ../../hw_project_sdt/ parse-sdt

## Start build
MACHINE=xlnx-zynqmp bitbake xilinx-bootbin



