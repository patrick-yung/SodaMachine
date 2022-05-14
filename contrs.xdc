#Motor Stuff
set_property PACKAGE_PIN W12 [get_ports {motorA[3]}];
set_property PACKAGE_PIN W11 [get_ports {motorA[2]}];
set_property PACKAGE_PIN V10 [get_ports {motorA[1]}];
set_property PACKAGE_PIN W8 [get_ports {motorA[0]}];
set_property IOSTANDARD LVCMOS33 [get_ports motorA];

set_property PACKAGE_PIN Y11 [get_ports {motorB[3]}];
set_property PACKAGE_PIN AA11 [get_ports {motorB[2]}];
set_property PACKAGE_PIN Y10 [get_ports {motorB[1]}];
set_property PACKAGE_PIN AA9 [get_ports {motorB[0]}];
set_property IOSTANDARD LVCMOS33 [get_ports motorB];

set_property PACKAGE_PIN AB6 [get_ports {motorC[3]}];
set_property PACKAGE_PIN AB7 [get_ports {motorC[2]}];
set_property PACKAGE_PIN AA4 [get_ports {motorC[1]}];
set_property PACKAGE_PIN Y4 [get_ports {motorC[0]}];
set_property IOSTANDARD LVCMOS33 [get_ports motorC];

#Sensor Stuff
set_property PACKAGE_PIN W7 [get_ports mosi];
set_property IOSTANDARD LVCMOS33 [get_ports mosi];
set_property PACKAGE_PIN V7 [get_ports cs];
set_property IOSTANDARD LVCMOS33 [get_ports cs];
set_property PACKAGE_PIN V4 [get_ports sclk];
set_property IOSTANDARD LVCMOS33 [get_ports sclk];
set_property PACKAGE_PIN V5 [get_ports miso];
set_property IOSTANDARD LVCMOS33 [get_ports miso];

#Button
set_property PACKAGE_PIN P16 [get_ports {btnC}];
set_property IOSTANDARD LVCMOS25 [get_ports btnC];
set_property PACKAGE_PIN N15 [get_ports {btnL}];
set_property IOSTANDARD LVCMOS25 [get_ports btnL];
set_property PACKAGE_PIN R18 [get_ports {btnR}];
set_property IOSTANDARD LVCMOS25 [get_ports btnR];


#OTHERS
set_property PACKAGE_PIN T22 [get_ports {Y0}];
set_property IOSTANDARD LVCMOS33 [get_ports Y0]
set_property PACKAGE_PIN T21 [get_ports {A0}];
set_property IOSTANDARD LVCMOS33 [get_ports A0]

set_property PACKAGE_PIN U22 [get_ports {B0}];
set_property IOSTANDARD LVCMOS33 [get_ports B0]

set_property PACKAGE_PIN Y9 [get_ports clk];
set_property IOSTANDARD LVCMOS33 [get_ports clk];
