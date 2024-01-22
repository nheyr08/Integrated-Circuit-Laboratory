# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2023.09
# platform  : Linux 3.10.0-1160.88.1.el7.x86_64
# version   : 2023.09p001 64 bits
# build date: 2023.10.25 14:35:20 UTC
# ----------------------------------------
# started   : 2023-11-14 01:22:42 CST
# hostname  : ee24.EEHPC
# pid       : 111767
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:39368' '-style' 'windows' '-data' 'AAAAjHicY2RgYLCp////PwMYMFcBCQEGHwZfhiAGVyDpzxAGpOGA8QGUYcPIgAwYAxtQaAYGVphCmBImIOZg0GVIZkgBYgYGHoYshnQGPYYSIC8HzAcAU+INbA==' '-proj' '/RAID2/COURSE/iclab/iclab129/Lab07/Exercise/05_JG/jgproject/sessionLogs/session_0' '-init' '-hidden' '/RAID2/COURSE/iclab/iclab129/Lab07/Exercise/05_JG/jgproject/.tmp/.initCmds.tcl' 'jg.tcl'
check_cdc -init
clear -all

## --------------- Environment Setting ---------------- ##
set_schematic_viewer_simplify_concatenations on
set_reset_max_iterations 2000

## ----------------- Setting Variables ---------------- ##
set design_path "../01_RTL"
set mem_path "../04_MEM"
set report_dir "./Report"
set DESIGN "PRGN_TOP"
set MEM "DUAL_64X32X1BM1"

## ------------- Loading Custom Rule File ------------- ##

## --------------- Analyzing the Design --------------- ##
analyze -sv ${mem_path}/$MEM\.v
analyze -sv ${design_path}/$DESIGN\.v 

## ----------------- Reading Liberty ------------------ ##
liberty -load ${mem_path}/$MEM\_WC.lib 

## -------------- Elaborating the design -------------- ##
elaborate -top $DESIGN 

## ---------------- Decalaring Resets ----------------- ##
config_rtlds -reset -async rst_n -polarity low  

## ------------------- Reading SDC -------------------- ##
read_sdc $DESIGN\_SYN.sdc

## --------------- Defining False Path ---------------- ##

## ---------------- Defining Constants ---------------- ##
# config_rtlds -rule -parameter {fifo_detection = true}
# config_rtlds -rule -parameter {handshake_detection = true}

## ------------ Clock Association of Ports ------------ ##

## --------------- Structural Analysis ---------------- ##
# Find Clock Domains
check_cdc -clock_domain -find
# Find CDC pairs
check_cdc -pair -find
# Find Schemes
# check_cdc -scheme -add ndff -module NDFF_syn -map {{dout Q} {data D}}
# check_cdc -scheme -add ndff_bus -module NDFF_BUS_syn -map {{dout Q} {data D}}
# check_cdc -scheme -add pulse -module PULSE_syn -map {{data P} {dout OUT} {enable IN}}
check_cdc -scheme -add handshake -module Handshake_syn -map {{data din} {sreq sreq} {dreq dreq} {dack dack} {sack sack}}
# check_cdc -scheme -add mux_pulse -module MUX_PULSE_syn -map {{data data} {enable sready_in} {sready u_ready_pulse.P} {dready dready} {dout dout}}
check_cdc -scheme -add fifo -module FIFO_syn -map {{rdata rdata} {wdata wdata} {wptr wptr} {rptr rptr} {wfull wfull} {rempty rempty} {winc winc} {rinc rinc}}
check_cdc -scheme -find
# Find Convergence
check_cdc -group -find

## ------------------ Reset Analysis ------------------ ##
# check_cdc -reset -find

## ---------------- Functional Checks ----------------- ##
check_cdc -protocol_check -generate
check_cdc -protocol_check -prove

## ---------- Proving Signal Configuration ------------ ##
# config_rtlds -signal -prove

## ----------------- Validate Waiver ------------------ ##
check_cdc -waiver -generate
check_cdc -waiver -prove
