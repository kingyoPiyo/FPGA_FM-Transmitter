## Generated SDC file "fm_tx.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Lite Edition"

## DATE    "Mon Jul 30 22:44:51 2018"

##
## DEVICE  "10M02DCV36C8G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {mco50m} -period 20.000 -waveform { 0.000 10.000 } [get_ports {mco50m}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {PLL_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {PLL_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {mco50m} [get_pins {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {PLL_inst|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {PLL_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 5 -master_clock {mco50m} [get_pins {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {PLL_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {rst_n}]
set_false_path -from [get_ports {analog_L}]
set_false_path -from [get_ports {analog_R}]
set_false_path -from [get_ports {uart_mosi}]

set_false_path -to [get_ports {analog_L_cmp}]
set_false_path -to [get_ports {analog_R_cmp}]
set_false_path -to [get_ports {o_rclk}]
set_false_path -to [get_ports {o_ser}]
set_false_path -to [get_ports {o_srclk}]
set_false_path -to [get_ports {rf_out}]
set_false_path -to [get_ports {uart_miso}]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

