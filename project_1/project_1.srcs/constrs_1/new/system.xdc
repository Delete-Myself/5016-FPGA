#clock
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports clock]
#IO_L13P_T2_MRCC_35 Sch=clock
create_clock -period 20.000 -name clock_pin -waveform {0.000 10.000} -add [get_ports clock]

#GPIO in
#
#IO_L1N_T0_34
set_property { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [ get_ports { left } ];
#IO_L11P_T1_SRCC_14
set_property { PACKAGE_PIN M4 IOSTANDARD LVCMOS33 } [ get_ports { right } ];
#IO_L23N_T3_34
#GPIO out
set_property -dict{ PACKAGE_PIN F4 IOSTANDARD TIMDS_33 } [ get_ports { hsync } ];
#IO_L12N_T1_MRCC_34
set_property -dict{ PACKAGE_PIN G4 IOSTANDARD TIMDS_33 } [ get_ports { vsync } ];
#IO_L12P_T1_MRCC_34
set_property -dict{ PACKAGE_PIN  IOSTANDARD TIMDS_33 } [ get_ports { disp_RGB } ];
#IO_L13P_T2_MRCC_34

set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports left]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports right]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports middle]
set_property PACKAGE_PIN M4 [get_ports right]
set_property PACKAGE_PIN C3 [get_ports middle]
set_property PACKAGE_PIN F4 [get_ports hsync]
set_property PACKAGE_PIN G4 [get_ports vsync]

set_property PACKAGE_PIN D2 [get_ports {disp_RGB[2]}]
set_property PACKAGE_PIN E2 [get_ports {disp_RGB[3]}]
set_property PACKAGE_PIN D1 [get_ports {disp_RGB[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN F1 [get_ports {disp_RGB[0]}]
set_property PACKAGE_PIN G1 [get_ports {disp_RGB[1]}]
set_property PACKAGE_PIN C1 [get_ports {disp_RGB[5]}]
set_property PACKAGE_PIN D14 [get_ports rst]
set_property PACKAGE_PIN E4 [get_ports left]
