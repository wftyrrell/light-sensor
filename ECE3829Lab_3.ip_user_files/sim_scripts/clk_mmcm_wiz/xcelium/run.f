-makelib xcelium_lib/xpm -sv \
  "C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../ECE3829Lab_3.gen/sources_1/ip/clk_mmcm_wiz/clk_mmcm_wiz_clk_wiz.v" \
  "../../../../ECE3829Lab_3.gen/sources_1/ip/clk_mmcm_wiz/clk_mmcm_wiz.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

