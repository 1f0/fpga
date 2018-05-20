@echo off
set xv_path=D:\\Xilinx\\Vivado\\2014.3\\bin
call %xv_path%/xelab  -wto d2b764374c91499c84264593b0e94e95 -m64 --debug typical --relax --include "../../../styx_uvga.srcs/sources_1/imports/styx" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot styxcpu_soc_behav xil_defaultlib.styxcpu_soc xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
