# ----------------------------------------------------------------------
# Copyright (c) 2016, The Regents of the University of California All
# rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
# 
#     * Neither the name of The Regents of the University of California
#       nor the names of its contributors may be used to endorse or
#       promote products derived from this software without specific
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL REGENTS OF THE
# UNIVERSITY OF CALIFORNIA BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
# DAMAGE.
# ----------------------------------------------------------------------
#----------------------------------------------------------------------------
# Filename:            DE5QGen3x4If128.sdc (Qsys)
# Version:             1.00.a
# Verilog Standard:    Verilog-2001
# Description:         Synopsys Design Constraints for the DE5 board.
# These design constrains constrain the PCIE_REFCLK, and 50 MHz Clock Input
# Author:              Dustin Richmond (@darichmond)
#-----------------------------------------------------------------------------
create_clock -name PCIE_REFCLK -period 10.000 [get_ports {PCIE_REFCLK}]

create_clock -name osc_50MHz -period 20.000 [get_ports {OSC_BANK3D_50MHZ}]


### Salehs's Modification (Adding Temp)
# set_operating_conditions -model slow -temperature 90 -voltage 900

################################################################################
# 13.1 Workround for http://www.altera.com/support/kdb/solutions/rd12162013_581.html?GSA_pos=1&WT.oss_r=1&WT.oss=adce_off_r
################################################################################

set_false_path -to [get_registers *|*.adce_off_r[0]]
set_false_path -to [get_registers *|*.adce_on_rr[0]]
set_false_path -to [get_registers *|reset_sync_pldclk_r[*]]

################################################################################
# End Workround 
################################################################################

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty

################################################################################
# Imports from Example Design (altera/13.1/ip/altera/altera_pcie/altera_pcie_hip_ast_ed/)
################################################################################

######################################################################
# HIP Soft reset controller SDC constraints
set_false_path -to   [get_registers *altpcie_rs_serdes|fifo_err_sync_r[0]]
set_false_path -from [get_registers *sv_xcvr_pipe_native*] -to [get_registers *altpcie_rs_serdes|*]

# HIP testin pins SDC constraints
set_false_path -from [get_pins -compatibility_mode *hip_ctrl*]

######################################################################
# Constraints for CV SIG asynchonous logic
set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_in_d0[*]}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_wr_clk}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_req_rd_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_rd_clk_d0}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_ack_wr_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_wr_clk}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_req_rd_clk|sync_regs[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_in_d0[*]}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_tls|altpcie_hip_vecsync:altpcie_hip_vecsync2|data_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|req_rd_clk_d0}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hip_eq_dprio:sigtesten.hip_eq_dprio_inst|altpcie_hip_vecsync2:vecsync_ltssm|altpcie_hip_vecsync:altpcie_hip_vecsync2|altpcie_hip_bitsync:u_ack_wr_clk|sync_regs[*]}]


set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|test_out[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_eqout[*]}]
                                                                                                                                                
set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_eqber[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_farend_lf[*]}]

set_false_path -from [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|stratixv_hssi_gen3_pcie_hip~SYNC_DATA_REG122}] -to [get_keepers {*|altpcie_hip_256_pipen1b:altpcie_hip_256_pipen1b|hd_altpe3_hip_eq_bypass_ph3:sigtesten.ep_eq_bypass_ph3_inst|test_dbg_farend_fs[*]}]


#### SDC From QSYS

# (C) 2001-2017 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# derive_pll_clock is used to calculate all clock derived from PCIe refclk
#  the derive_pll_clocks and derive clock_uncertainty should only
# be applied once across all of the SDC files used in a project
 derive_pll_clocks -create_base_clocks
 derive_clock_uncertainty

set testin_size_collection_pcie 0
set testin_collection_pcie [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
set testin_size_collection_pcie [get_collection_size $testin_collection_pcie]

if {$testin_size_collection_pcie > 0} {
  set_false_path -from [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
  set_false_path -to [get_registers {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_test_in_static_signal_to_be_false_path[*]}]
}

set_max_skew -from [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg[*]   *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg[*] }] 6.500
set_max_skew -from [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg_1[*]  *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg_1[*] }] 6.500

set_max_delay -from [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg}] -to [get_registers -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg[*]  *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_data_reg_1[*] *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg[*] *|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|dbg_rx_datak_reg_1[*] }] 10.000
set_false_path -from {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg} -to {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_sc_bitsync_node:rx_polinv_dbg.dbg_rx_valid_altpcie_sc_bitsync_1|altpcie_sc_bitsync:altpcie_sc_bitsync|altpcie_sc_bitsync_meta_dff[0]}
set_false_path -from {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys~pld_clk.reg} -to {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|altpcie_sc_bitsync_node:rx_polinv_dbg.dbg_rx_valid_altpcie_sc_bitsync|altpcie_sc_bitsync:altpcie_sc_bitsync|altpcie_sc_bitsync_meta_dff[0]}

set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_add[*]}] 2 
set_multicycle_path -setup -through [get_pins -compatibility_mode -nocase -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2 
set_multicycle_path -hold  -through [get_pins -compatibility_mode -nocase -nowarn {*|altpcie_a10_hip_pipen1b:altpcie_a10_hip_pipen1b|wys|tl_cfg_ctl[*]}] 2


##################################################### Utils #####################################################

proc skp_sdc_puts {msg {channelId stdout}} {
	puts $channelId "altera_pcie_a10_skp.sdc >> $msg"
}

proc parent_of_clock {clock_name {MAX_ATTEMPTS 100}} {
   skp_sdc_puts "***********************************************************************************************"
   skp_sdc_puts "************************ Searching for the hierarchy of $clock_name ***************************"
   skp_sdc_puts "***********************************************************************************************"

   set attempts 0
   set parent {}

   while { $attempts < $MAX_ATTEMPTS } {
	   skp_sdc_puts "Searching for clocks that match \"$parent$clock_name\"..."

      set matched_clock_collection [get_clocks -nowarn $parent$clock_name]                   ;# Try this wildcard.
	   set num_matched_clocks [get_collection_size $matched_clock_collection]

	   if { $num_matched_clocks == 1 } {                               ;# This is the hierarchy we are looking for.
		   # Find out the full name of the parent.
			global clk_parent_list

		   set parent [join [lrange [split [query_collection $matched_clock_collection] {|}] 0 {end-1}] {|}]

         skp_sdc_puts "Parent found : $parent"
         skp_sdc_puts "***********************************************************************************************"
         skp_sdc_puts "************************** Finish searching with result : $parent *****************************"
         skp_sdc_puts "***********************************************************************************************"

         return $parent
	   } elseif { $num_matched_clocks > 1 } {       ;# Multiple clocks with the same name
		   skp_sdc_puts "Multiple clocks match $parent$clock_name !" {stderr}
		   skp_sdc_puts "Matched clocks are:" {stderr}
		   skp_sdc_puts "[query_collection $matched_clock_collection -report_format]" {stderr}
         skp_sdc_puts "***********************************************************************************************"
         skp_sdc_puts "********************************** Finish searching *******************************************"
         skp_sdc_puts "***********************************************************************************************"
			
			global clk_parent_list
			
			set clk_list [query_collection $matched_clock_collection -list_format]
			foreach clk $clk_list { ;#store each unique parent to clk_parent_list
				set removed_child_clk [join [lrange [split $clk {|}] 0 {end-1}] {|}]
				lappend clk_parent_list $removed_child_clk
				#skp_sdc_puts "Parent list: $clk_parent_list"
				} 

         return
	   } else {                                                                    ;# Go up one level of hierarchy.
		   global clk_parent_list
			append parent {*|}
		   incr attempts
	   }
   }

   skp_sdc_puts "Error: Unable to find the parent of $clock_name in $MAX_ATTEMPTS attempts!"
   skp_sdc_puts "***********************************************************************************************"
   skp_sdc_puts "******************************* Finish searching with error ***********************************"
   skp_sdc_puts "***********************************************************************************************"

   return
}

################################################ Applying Constraints ################################################

#derive_pll_clocks -create_base_clocks     ;# derive_pll_clocks needs to be called before calling parent_of_clock
#derive_clock_uncertainty                  ;# in order to generate proper hierarchy.


set all_clk_parent_list {}
set clk_parent_list {}
set clk_parent_list_length {}
set pll_pcie_clock [get_clocks *pll_pcie_clk]
set num_matched_clocks [get_collection_size $pll_pcie_clock]

################################################ Find Clock Prefix ################################################
if {[get_collection_size $pll_pcie_clock] == 1} {												;# single instance
		set clk_prefix [join [lrange [split [query_collection $pll_pcie_clock] {|}] 0 {end-1}] {|}] 
		set clk_parent_list_length 1
} elseif {[get_collection_size $pll_pcie_clock] > 1} { 										;# multiple instances
		set clk_prefix [query_collection $pll_pcie_clock -list_format]
		
		foreach clk $clk_prefix { 																	;# store each unique parent to all_clk_parent_list
				set removed_child_clk [join [lrange [split $clk {|}] 0 {end-1}] {|}]
				lappend all_clk_parent_list $removed_child_clk
				}
		set clk_parent_list [lsort -unique $all_clk_parent_list]							;# only unique elements in list
		set clk_parent_list_length [llength $clk_parent_list]
} else {
		puts "Clock pll_pcie_clk does not exist"
		puts "Ensure derive_pll_clocks -create_base_clocks is run"
		set clk_parent_list_length 0
}
################################################ Find Clock Prefix End ################################################

################################################ Find Clock Pin Prefix ################################################	
set byte_ser_clk_pins [get_pins -compatibility_mode *altpcie_a10_hip_pipen1b*|byte_deserializer_pcs_clk_div_by_4_txclk_reg]
set hip_presence {}
set all_pin_prefix_list {}
set byte_ser_clk_pin0 {}
set clk_pin_prefix {}
set clk_pin_prefix_list {}
set clk_pin_prefix_list_length {} 

if {[get_collection_size $pll_pcie_clock] == 1} {												;# single instance
		set byte_ser_clk_pin0 [lindex [query_collection $byte_ser_clk_pins] 0]		;# one type of pin prefix	
		set hip_presence [regexp {(^.*)\|altpcie_a10_hip_pipen1b} $byte_ser_clk_pin0 all clk_pin_prefix]
		set clk_pin_prefix_list_length 1
} elseif {[get_collection_size $pll_pcie_clock] > 1} {											;# multiple instances
		set byte_ser_clk_pin0  [query_collection $byte_ser_clk_pins]					;# two or more type of pin prefix
		
		foreach clk $byte_ser_clk_pin0 {
			set hip_presence [regexp {(^.*)\|altpcie_a10_hip_pipen1b} $clk all clk_pin_prefix]
			lappend all_pin_prefix_list $clk_pin_prefix
			}
		
		set clk_pin_prefix_list [lsort -unique $all_pin_prefix_list]
		set clk_pin_prefix_list_length [llength $clk_pin_prefix_list]
		
} else {
		puts "Clock pin *altpcie_a10_hip_pipen1b*|byte_deserializer_pcs_clk_div_by_4_txclk_reg does not exist"
		#puts "Error: possibly a timing model issue"
		set clk_pin_prefix_list_length 0 
}
################################################ Find Clock Pin Prefix End ################################################	

global subsequent_sdc_flag

if {[info exists subsequent_sdc_flag] == 1} { 															;#check whether bypass_flag exists in order to skip the multiple parent clocks constraints block
			puts "Bypassing adding the duplicate constraints since they were previously added"
} else {
			puts "Adding the constraints for generated clocks"
}

set get_clk_prefix {}
set get_pin_prefix {}
	
if {[get_collection_size $pll_pcie_clock] > 1 && [info exists subsequent_sdc_flag] == 0 && $clk_parent_list_length == $clk_pin_prefix_list_length } { 		;# only for multiple parent clocks constraints
	
			set phy_lane0_size 0 ;#Gen 3x1
			set phy_lane1_size 0 ;#Gen 3x2
			set phy_lane3_size 0 ;#Gen 3x4
			set phy_lane7_size 0 ;#Gen 3x8
			
			set phy_lane0 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[0]*}]
			set phy_lane1 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[1]*}]
			set phy_lane3 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[3]*}]
			set phy_lane7 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[7]*}]
			
			set phy_lane0_size [get_collection_size $phy_lane0]
			set phy_lane1_size [get_collection_size $phy_lane1]
			set phy_lane3_size [get_collection_size $phy_lane3]
			set phy_lane7_size [get_collection_size $phy_lane7]
			
			if {$phy_lane7_size > 0} {
				set stop 8
				} elseif {$phy_lane3_size > 0} {
				set stop 4
				} elseif {$phy_lane1_size > 0} {
				set stop 2
				} elseif {$phy_lane0_size > 0} {
				set stop 1
				} else {
				set stop 0
				}
 		
		for {set j 0} {$j != [llength $clk_parent_list]} {incr j} {
			for {set k 0} {$k != [llength $clk_pin_prefix_list]} {incr k} {
				if {$j == $k} { 																						;#constraints applied only if indices are matching
					set get_clk_prefix [lindex $clk_parent_list $j]
					set get_pin_prefix [lindex $clk_pin_prefix_list $k]
					
				for {set i 0} {$i != $stop} {incr i} {
					create_generated_clock -divide_by 1 \
						-source     "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_2_txclk_reg" \
						-name       "$get_clk_prefix|rx_pcs_clk_div_by_4[$i]" \
										"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by2_1" ;# target
				
					create_generated_clock -multiply_by 1 -divide_by 1 \
						-source     "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|byte_serializer_pcs_clk_div_by_2_reg" \
						-name       "$get_clk_prefix|tx_pcs_clk_div_by_4[$i]" \
										"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|sta_tx_clk2_by2_1" ;# target
				}
				
				remove_clock      "$get_clk_prefix|tx_bonding_clocks[0]"
				
				# Constraint for Gen 3x2 and up
				if {$phy_lane1_size > 0} {
					create_generated_clock -multiply_by 1 -divide_by 5 \
					-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|clk_fpll_*" \
					-master_clock  "$get_clk_prefix|tx_serial_clk" \
					-name          "$get_clk_prefix|tx_bonding_clocks[0]" \
									"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|cpulse_out_bus[0]"
																																	
					set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_common_pld_pcs_interface.inst_twentynm_hssi_common_pld_pcs_interface~pld_rate_reg.reg}																													
					set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by2_1.reg}	
					set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by4_1.reg}	
					set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_common_pld_pcs_interface.inst_twentynm_hssi_common_pld_pcs_interface~pld_8g_eidleinfersel_reg.reg}	
				}
				# END Constraint for Gen 3x2 and up 
				
				#create_generated_clock -multiply_by 1 -divide_by 10 \
					-source        "$clk_pin_prefix_loop|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|clk_fpll_b" \
					-master_clock  "$get_clk_prefix|tx_serial_clk" \
					-name          "$get_clk_prefix|tx_bonding_clocks[0]" \
										"$clk_pin_prefix_loop|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|cpulse_out_bus[0]"
				
				#set_multicycle_path -setup -through [get_pins -compatibility_mode {*pld_rx_data*}] 0
				
				foreach_in_collection mpin [get_pins -compatibility_mode {*pld_rx_data*}]  {
					set mpin_name [get_pin_info -name $mpin]
					if [string match "*altpcie_a10_hip_pipen1b*" $mpin_name] {
						set_multicycle_path -setup -through $mpin 0
					}
				}
				
				set rx_clkouts [list]
				for {set i 0} {$i != $stop} {incr i} {
					remove_clock      "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clk"
					remove_clock      "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout"
					
					create_generated_clock -multiply_by 1 \
						-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_4_txclk_reg" \
						-master_clock  "$get_clk_prefix|tx_bonding_clocks[0]" \
						-name          "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clk" \
											"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by4_1" ;# target
				
					create_generated_clock -multiply_by 1 \
						-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pld_clk_div_by_4_txclk_reg" \
						-master_clock  "$get_clk_prefix|tx_bonding_clocks[0]" \
						-name          "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout" \
											"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by4_1_out"
				
					set_clock_groups -exclusive \
						-group "$get_clk_prefix|tx_bonding_clocks[0]" \
						-group "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout"
					set_clock_groups -exclusive \
						-group "$get_clk_prefix|tx_bonding_clocks[0]" \
						-group "$get_clk_prefix|rx_pcs_clk_div_by_4[$i]"
				}
							
		    }
	   }
	}
	
	set subsequent_sdc_flag 1 								 												;#disables subsequent runs of this if-block in other SDCs
	
} elseif {[get_collection_size $pll_pcie_clock] == 1}  {									   	;#single parent clock

		#set prefix [parent_of_clock {tx_serial_clk}]
		#set prefix $prefix_checker 
		
		set phy_lane0_size 0 ;#Gen 3x1
		set phy_lane1_size 0 ;#Gen 3x2
		set phy_lane3_size 0 ;#Gen 3x4
		set phy_lane7_size 0 ;#Gen 3x8
		
		set phy_lane0 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[0]*}]
		set phy_lane1 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[1]*}]
		set phy_lane3 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[3]*}]
		set phy_lane7 [get_registers -nowarn {*phy_g3x*|g_xcvr_native_insts[7]*}]
		
		set phy_lane0_size [get_collection_size $phy_lane0]
		set phy_lane1_size [get_collection_size $phy_lane1]
		set phy_lane3_size [get_collection_size $phy_lane3]
		set phy_lane7_size [get_collection_size $phy_lane7]
		
		if {$phy_lane7_size > 0} {
			set stop 8
			} elseif {$phy_lane3_size > 0} {
			set stop 4
			} elseif {$phy_lane1_size > 0} {
			set stop 2
			} elseif {$phy_lane0_size > 0} {
			set stop 1
			} else {
			set stop 0
			}
		
		set get_clk_prefix $clk_prefix
		set get_pin_prefix $clk_pin_prefix	
		
		for {set i 0} {$i != $stop} {incr i} {
				create_generated_clock -divide_by 1 \
					-source     "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_2_txclk_reg" \
					-name       "$get_clk_prefix|rx_pcs_clk_div_by_4[$i]" \
									"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by2_1" ;# target
			
				create_generated_clock -multiply_by 1 -divide_by 1 \
					-source     "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|byte_serializer_pcs_clk_div_by_2_reg" \
					-name       "$get_clk_prefix|tx_pcs_clk_div_by_4[$i]" \
									"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs|sta_tx_clk2_by2_1" ;# target
			}
			
			remove_clock      "$get_clk_prefix|tx_bonding_clocks[0]"
			
			# Constraint for Gen 3x2 and up
			if {$phy_lane1_size > 0} {
				create_generated_clock -multiply_by 1 -divide_by 5 \
				-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|clk_fpll_*" \
				-master_clock  "$get_clk_prefix|tx_serial_clk" \
				-name          "$get_clk_prefix|tx_bonding_clocks[0]" \
								"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|cpulse_out_bus[0]"
																																
				set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_common_pld_pcs_interface.inst_twentynm_hssi_common_pld_pcs_interface~pld_rate_reg.reg}																													
				set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by2_1.reg}	
				set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_8g_tx_pcs.inst_twentynm_hssi_8g_tx_pcs~tx_clk2_by4_1.reg}	
				set_false_path -from {*|altpcie_a10_hip_pipen1b|wys~ch*_pcs_chnl_hip_clk_out[0].reg}  -to {*|altpcie_a10_hip_pipen1b|*altpcie_a10_hip_pllnphy|*g_xcvr_native_insts[*].twentynm_xcvr_native_inst|*twentynm_xcvr_native_inst|*gen_twentynm_hssi_common_pld_pcs_interface.inst_twentynm_hssi_common_pld_pcs_interface~pld_8g_eidleinfersel_reg.reg}	
			}
			# END Constraint for Gen 3x2 and up 
			
			#create_generated_clock -multiply_by 1 -divide_by 10 \
				-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|clk_fpll_b" \
				-master_clock  "$get_clk_prefix|tx_serial_clk" \
				-name          "$get_clk_prefix|tx_bonding_clocks[0]" \
									"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_pll.g_pll_g3n.lcpll_g3xn|lcpll_g3xn|a10_xcvr_atx_pll_inst|twentynm_hssi_pma_cgb_master_inst|cpulse_out_bus[0]"
			
			#set_multicycle_path -setup -through [get_pins -compatibility_mode {*pld_rx_data*}] 0
			
			foreach_in_collection mpin [get_pins -compatibility_mode {*pld_rx_data*}]  {
				set mpin_name [get_pin_info -name $mpin]
				if [string match "*altpcie_a10_hip_pipen1b*" $mpin_name] {
					set_multicycle_path -setup -through $mpin 0
				}
			}
			
			set rx_clkouts [list]
			for {set i 0} {$i != $stop} {incr i} {
				remove_clock      "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clk"
				remove_clock      "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout"
				
				create_generated_clock -multiply_by 1 \
					-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pcs_clk_div_by_4_txclk_reg" \
					-master_clock  "$get_clk_prefix|tx_bonding_clocks[0]" \
					-name          "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clk" \
										"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by4_1" ;# target
			
				create_generated_clock -multiply_by 1 \
					-source        "$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|byte_deserializer_pld_clk_div_by_4_txclk_reg" \
					-master_clock  "$get_clk_prefix|tx_bonding_clocks[0]" \
					-name          "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout" \
										"$get_pin_prefix|altpcie_a10_hip_pipen1b|g_xcvr.altpcie_a10_hip_pllnphy|g_xcvr.g_phy_g3x*.phy_g3x*|phy_g3x*|g_xcvr_native_insts[$i].twentynm_xcvr_native_inst|twentynm_xcvr_native_inst|inst_twentynm_pcs|gen_twentynm_hssi_8g_rx_pcs.inst_twentynm_hssi_8g_rx_pcs|sta_rx_clk2_by4_1_out"
			
				set_clock_groups -exclusive \
					-group "$get_clk_prefix|tx_bonding_clocks[0]" \
					-group "$get_clk_prefix|g_xcvr_native_insts[$i]|rx_clkout"
				set_clock_groups -exclusive \
					-group "$get_clk_prefix|tx_bonding_clocks[0]" \
					-group "$get_clk_prefix|rx_pcs_clk_div_by_4[$i]"
			}
} elseif {$clk_parent_list_length != $clk_pin_prefix_list_length} {
			puts "Prefix list from get_clocks does not match prefix list from get_pins"
			puts "No additional clock constraints were added"
} else {
			puts "No additional clock constraints were added"
}
