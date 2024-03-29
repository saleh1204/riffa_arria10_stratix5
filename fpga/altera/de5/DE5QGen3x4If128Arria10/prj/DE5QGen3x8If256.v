// ----------------------------------------------------------------------
// Copyright (c) 2016, The Regents of the University of California All
// rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
// 
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
// 
//     * Neither the name of The Regents of the University of California
//       nor the names of its contributors may be used to endorse or
//       promote products derived from this software without specific
//       prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL REGENTS OF THE
// UNIVERSITY OF CALIFORNIA BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
// OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.
// ----------------------------------------------------------------------
//----------------------------------------------------------------------------
// Filename:            DE5QGen3x4If128.v
// Version:             
// Verilog Standard:    Verilog-2001
// Description:         Top level module for RIFFA 2.2 reference design for the
//                      the Altera Stratix V Avalong Streaming Interface to PCI
//                      Express module and the Terasic DE5 Development Board.
// Author:              Dustin Richmond (@darichmond)
//-----------------------------------------------------------------------------
`include "functions.vh"
`include "riffa.vh"
`include "altera.vh"
`timescale 1ps / 1ps
module DE5QGen3x8If256
    #(// Number of RIFFA Channels
      parameter C_NUM_CHNL = 2,
      // Number of PCIe Lanes
      parameter C_NUM_LANES =  8,
      // Settings from Quartus IP Library
      parameter C_PCI_DATA_WIDTH = 256,
      parameter C_MAX_PAYLOAD_BYTES = 256,
      parameter C_LOG_NUM_TAGS = 5
      ) 
    (
     // ----------LEDs----------
     output [7:0]            LED,

     // ----------PCIE----------
     input                   PCIE_RESET_N,
     input                   PCIE_REFCLK,

     // ----------PCIE Serial RX----------
     input [C_NUM_LANES-1:0] PCIE_RX_IN,

     // ----------PCIE Serial TX----------
     output [C_NUM_LANES-1:0]  PCIE_TX_OUT,

     // ----------Oscillators----------
     input                   OSC_BANK3D_50MHZ
     );

    wire                     npor;
    wire                     pin_perst;

    // ----------TL Config interface----------
    wire [3:0]               tl_cfg_add;
    wire [31:0]              tl_cfg_ctl;
    wire [52:0]              tl_cfg_sts;

    // ----------Rx/TX Interfaces----------
    wire [0:0]               rx_st_sop;
    wire [0:0]               rx_st_eop;
    wire [0:0]               rx_st_err;
    wire [0:0]               rx_st_valid;
    wire [0:0]               rx_st_empty;
    wire                     rx_st_ready;
    wire [C_PCI_DATA_WIDTH-1:0]              rx_st_data;

    wire [0:0]               tx_st_sop;
    wire [0:0]               tx_st_eop;
    wire [0:0]               tx_st_err;
    wire [0:0]               tx_st_valid;
    wire                     tx_st_ready;
    wire [C_PCI_DATA_WIDTH-1:0]              tx_st_data;
    wire [0:0]               tx_st_empty;

    // ----------Clocks & Locks----------
    wire                     pld_clk;
    wire                     coreclkout_hip;
    wire                     refclk;
    wire                     pld_core_ready;
    wire                     reset_status;
    wire                     serdes_pll_locked;

    // ----------Interrupt Interfaces----------
    wire                     app_msi_req;
    wire                     app_msi_ack;
    
    // ----------Reconfiguration Controller signals----------
    wire                     mgmt_clk_clk;
    wire                     mgmt_rst_reset;

    // ----------Reconfiguration Driver Signals----------
    wire                     reconfig_xcvr_clk;
    wire                     reconfig_xcvr_rst;

    wire [7:0]               rx_in;
    wire [7:0]               tx_out;
    
    // ------------Status Interface------------
    wire                     derr_cor_ext_rcv;
    wire                     derr_cor_ext_rpl;
    wire                     derr_rpl;
    wire                     dlup;
    wire                     dlup_exit;
    wire                     ev128ns;
    wire                     ev1us;
    wire                     hotrst_exit;
    wire [3:0]               int_status;
    wire                     l2_exit;
    wire [3:0]               lane_act;
    wire [4:0]               ltssmstate;
    wire                     rx_par_err;
    wire [1:0]               tx_par_err;
    wire                     cfg_par_err;
    wire [7:0]               ko_cpl_spc_header;
    wire [11:0]              ko_cpl_spc_data;

    // ----------Clocks----------
    assign pld_clk = coreclkout_hip;
    assign mgmt_clk_clk = PCIE_REFCLK;
    assign reconfig_xcvr_clk = PCIE_REFCLK;
    assign refclk = PCIE_REFCLK;
    assign pld_core_ready = serdes_pll_locked;
    
    // ----------Resets----------
    assign reconfig_xcvr_rst = 1'b0;
    assign mgmt_rst_reset = 1'b0;
    assign pin_perst = PCIE_RESET_N;
    assign npor = PCIE_RESET_N;

    // ----------LED's----------
    assign LED[7:0] = cpl_error;

   // -------------------- BEGIN ALTERA IP INSTANTIATION  --------------------//
	wire [4:0] hpg_ctrler, app_msi_num;
	wire [2:0] app_msi_tc;
	wire [6:0] cpl_error;
	wire cpl_pending, rx_st_error, tx_st_error, pld_clk_inuse, testin_zero, app_int_sts, app_int_ack;
	
	
		QSysDE5QGen3x4If128 pcie_system_inst (
		.pcienpor_npor             (npor),             //    pcienpor.npor
		.pcienpor_pin_perst        (pin_perst),        //            .pin_perst
		.pciecfg_hpg_ctrler        (hpg_ctrler),        //     pciecfg.hpg_ctrler input [4:0]
		.pciecfg_tl_cfg_add        (tl_cfg_add[3:0]),        //            .tl_cfg_add
		.pciecfg_tl_cfg_ctl        (tl_cfg_ctl[31:0]),        //            .tl_cfg_ctl
		.pciecfg_tl_cfg_sts        (tl_cfg_sts[52:0]),        //            .tl_cfg_sts
		.pciecfg_cpl_err           (cpl_error),           //            .cpl_err input [6:0]
		.pciecfg_cpl_pending       (cpl_pending),       //            .cpl_pending input (1-bit)
		.rx_st_startofpacket       (rx_st_sop[0:0]),       //       rx_st.startofpacket
		.rx_st_endofpacket         (rx_st_eop[0:0]),         //            .endofpacket
		.rx_st_error               (rx_st_error),               //            .error output (1-bit)
		.rx_st_valid               (rx_st_valid[0:0]),               //            .valid
		.rx_st_ready               (rx_st_ready),               //            .ready
		.rx_st_data                (rx_st_data[C_PCI_DATA_WIDTH-1:0]),                //            .data
		.rx_st_empty               (rx_st_empty[0:0]),               //            .empty
		.tx_st_startofpacket       (tx_st_sop[0:0]),       //       tx_st.startofpacket
		.tx_st_endofpacket         (tx_st_eop[0:0]),         //            .endofpacket
		.tx_st_error               (tx_st_error),               //            .error input (1-bit)
		.tx_st_valid               (tx_st_valid[0:0]),               //            .valid
		.tx_st_ready               (tx_st_ready),               //            .ready
		.tx_st_data                (tx_st_data[C_PCI_DATA_WIDTH-1:0]),                //            .data
		.tx_st_empty               (tx_st_empty[0:0]),               //            .empty
		.pciepld_clk               (pld_clk),               //     pciepld.clk
		.pciecoreclk_clk           (coreclkout_hip),           // pciecoreclk.clk
		.pcierefclk_clk            (refclk),            //  pcierefclk.clk
		.pciehip_pld_core_ready    (pld_core_ready),    //     pciehip.pld_core_ready
		.pciehip_pld_clk_inuse     (pld_clk_inuse),     //            .pld_clk_inuse output (1-bit)
		.pciehip_serdes_pll_locked (serdes_pll_locked), //            .serdes_pll_locked
		.pciehip_reset_status      (reset_status),      //            .reset_status
		.pciehip_testin_zero       (testin_zero),       //            .testin_zero output (1-bit)
		.pcieserial_rx_in0         (PCIE_RX_IN[0]),         //  pcieserial.rx_in0
		.pcieserial_rx_in1         (PCIE_RX_IN[1]),         //            .rx_in1
		.pcieserial_rx_in2         (PCIE_RX_IN[2]),         //            .rx_in2
		.pcieserial_rx_in3         (PCIE_RX_IN[3]),         //            .rx_in3
		.pcieserial_rx_in4         (PCIE_RX_IN[4]),         //   input,    width = 1,            .rx_in4
		.pcieserial_rx_in5         (PCIE_RX_IN[5]),         //   input,    width = 1,            .rx_in5
		.pcieserial_rx_in6         (PCIE_RX_IN[6]),         //   input,    width = 1,            .rx_in6
		.pcieserial_rx_in7         (PCIE_RX_IN[7]),         //   input,    width = 1,            .rx_in7		
		.pcieserial_tx_out0        (PCIE_TX_OUT[0]),        //            .tx_out0
		.pcieserial_tx_out1        (PCIE_TX_OUT[1]),        //            .tx_out1
		.pcieserial_tx_out2        (PCIE_TX_OUT[2]),        //            .tx_out2
		.pcieserial_tx_out3        (PCIE_TX_OUT[3]),        //            .tx_out3
		.pcieserial_tx_out4        (PCIE_TX_OUT[4]),        //  output,    width = 1,            .tx_out4
		.pcieserial_tx_out5        (PCIE_TX_OUT[5]),        //  output,    width = 1,            .tx_out5
		.pcieserial_tx_out6        (PCIE_TX_OUT[6]),        //  output,    width = 1,            .tx_out6
		.pcieserial_tx_out7        (PCIE_TX_OUT[7]),        //  output,    width = 1,            .tx_out7		
		.pciemsi_app_int_sts       (app_int_sts),       //     pciemsi.app_int_sts input (1-bit)
		.pciemsi_app_int_ack       (app_int_ack),       //            .app_int_ack output (1-bit)
		.pciemsi_app_msi_num       (app_msi_num),       //            .app_msi_num input [4:0]
		.pciemsi_app_msi_req       (app_msi_req),       //            .app_msi_req
		.pciemsi_app_msi_tc        (app_msi_tc),        //            .app_msi_tc input [2:0]
		.pciemsi_app_msi_ack       (app_msi_ack),       //            .app_msi_ack
		.pciestat_derr_cor_ext_rcv  (derr_cor_ext_rcv),  //  output,    width = 1,    pciestat.derr_cor_ext_rcv
		.pciestat_derr_cor_ext_rpl  (derr_cor_ext_rpl),  //  output,    width = 1,            .derr_cor_ext_rpl
		.pciestat_derr_rpl          (derr_rpl),          //  output,    width = 1,            .derr_rpl
		.pciestat_dlup              (dlup),              //  output,    width = 1,            .dlup
		.pciestat_dlup_exit         (dlup_exit),         //  output,    width = 1,            .dlup_exit
		.pciestat_ev128ns           (ev128ns),           //  output,    width = 1,            .ev128ns
		.pciestat_ev1us             (ev1us),             //  output,    width = 1,            .ev1us
		.pciestat_hotrst_exit       (hotrst_exit),       //  output,    width = 1,            .hotrst_exit
		.pciestat_int_status        (int_status),        //  output,    width = 4,            .int_status
		.pciestat_l2_exit           (l2_exit),           //  output,    width = 1,            .l2_exit
		.pciestat_lane_act          (lane_act),          //  output,    width = 4,            .lane_act
		.pciestat_ltssmstate        (ltssmstate),        //  output,    width = 5,            .ltssmstate
		.pciestat_rx_par_err        (rx_par_err),        //  output,    width = 1,            .rx_par_err
		.pciestat_tx_par_err        (tx_par_err),        //  output,    width = 2,            .tx_par_err
		.pciestat_cfg_par_err       (cfg_par_err),       //  output,    width = 1,            .cfg_par_err
		.pciestat_ko_cpl_spc_header (ko_cpl_spc_header), //  output,    width = 8,            .ko_cpl_spc_header
		.pciestat_ko_cpl_spc_data   (ko_cpl_spc_data)   //  output,   width = 12,            .ko_cpl_spc_data
	);
	

    // -------------------- END ALTERA IP INSTANTIATION  --------------------
    // -------------------- BEGIN RIFFA INSTANTAION --------------------

    // RIFFA channel interface
    wire                     rst_out;
    wire [C_NUM_CHNL-1:0]    chnl_rx_clk;
    wire [C_NUM_CHNL-1:0]    chnl_rx;
    wire [C_NUM_CHNL-1:0]    chnl_rx_ack;
    wire [C_NUM_CHNL-1:0]    chnl_rx_last;
    wire [(C_NUM_CHNL*32)-1:0] chnl_rx_len;
    wire [(C_NUM_CHNL*31)-1:0] chnl_rx_off;
    wire [(C_NUM_CHNL*C_PCI_DATA_WIDTH)-1:0] chnl_rx_data;
    wire [C_NUM_CHNL-1:0]                    chnl_rx_data_valid;
    wire [C_NUM_CHNL-1:0]                    chnl_rx_data_ren;
    
    wire [C_NUM_CHNL-1:0]                    chnl_tx_clk;
    wire [C_NUM_CHNL-1:0]                    chnl_tx;
    wire [C_NUM_CHNL-1:0]                    chnl_tx_ack;
    wire [C_NUM_CHNL-1:0]                    chnl_tx_last;
    wire [(C_NUM_CHNL*32)-1:0]               chnl_tx_len;
    wire [(C_NUM_CHNL*31)-1:0]               chnl_tx_off;
    wire [(C_NUM_CHNL*C_PCI_DATA_WIDTH)-1:0] chnl_tx_data;
    wire [C_NUM_CHNL-1:0]                    chnl_tx_data_valid;
    wire [C_NUM_CHNL-1:0]                    chnl_tx_data_ren;

    wire                                     chnl_reset;
    wire                                     chnl_clk;
    wire                                     riffa_reset;
    wire                                     riffa_clk;
    assign riffa_reset = reset_status;
    assign riffa_clk = pld_clk;
    assign chnl_clk = pld_clk;
    assign chnl_reset = rst_out;
    
    riffa_wrapper_de5
        #(/*AUTOINSTPARAM*/
          // Parameters
          .C_LOG_NUM_TAGS               (C_LOG_NUM_TAGS),
          .C_NUM_CHNL                   (C_NUM_CHNL),
          .C_PCI_DATA_WIDTH             (C_PCI_DATA_WIDTH),
          .C_MAX_PAYLOAD_BYTES          (C_MAX_PAYLOAD_BYTES))
    riffa
        (/*AUTOINST*/
         // Outputs
         .RX_ST_READY                   (rx_st_ready),
         .TX_ST_DATA                    (tx_st_data[C_PCI_DATA_WIDTH-1:0]),
         .TX_ST_VALID                   (tx_st_valid[0:0]),
         .TX_ST_EOP                     (tx_st_eop[0:0]),
         .TX_ST_SOP                     (tx_st_sop[0:0]),
         .TX_ST_EMPTY                   (tx_st_empty[0:0]),
         .APP_MSI_REQ                   (app_msi_req),
         .RST_OUT                       (rst_out),
         .CHNL_RX                       (chnl_rx[C_NUM_CHNL-1:0]),
         .CHNL_RX_LAST                  (chnl_rx_last[C_NUM_CHNL-1:0]),
         .CHNL_RX_LEN                   (chnl_rx_len[(C_NUM_CHNL*`SIG_CHNL_LENGTH_W)-1:0]),
         .CHNL_RX_OFF                   (chnl_rx_off[(C_NUM_CHNL*`SIG_CHNL_OFFSET_W)-1:0]),
         .CHNL_RX_DATA                  (chnl_rx_data[(C_NUM_CHNL*C_PCI_DATA_WIDTH)-1:0]),
         .CHNL_RX_DATA_VALID            (chnl_rx_data_valid[C_NUM_CHNL-1:0]),
         .CHNL_TX_ACK                   (chnl_tx_ack[C_NUM_CHNL-1:0]),
         .CHNL_TX_DATA_REN              (chnl_tx_data_ren[C_NUM_CHNL-1:0]),
         // Inputs
         .RX_ST_DATA                    (rx_st_data[C_PCI_DATA_WIDTH-1:0]),
         .RX_ST_EOP                     (rx_st_eop[0:0]),
         .RX_ST_SOP                     (rx_st_sop[0:0]),
         .RX_ST_VALID                   (rx_st_valid[0:0]),
         .RX_ST_EMPTY                   (rx_st_empty[0:0]),
         .TX_ST_READY                   (tx_st_ready),
         .TL_CFG_CTL                    (tl_cfg_ctl[`SIG_CFG_CTL_W-1:0]),
         .TL_CFG_ADD                    (tl_cfg_add[`SIG_CFG_ADD_W-1:0]),
         .TL_CFG_STS                    (tl_cfg_sts[`SIG_CFG_STS_W-1:0]),
         .KO_CPL_SPC_HEADER             (ko_cpl_spc_header[`SIG_KO_CPLH_W-1:0]),
         .KO_CPL_SPC_DATA               (ko_cpl_spc_data[`SIG_KO_CPLD_W-1:0]),
         .APP_MSI_ACK                   (app_msi_ack),
         .PLD_CLK                       (pld_clk),
         .RESET_STATUS                  (reset_status),
         .CHNL_RX_CLK                   (chnl_rx_clk[C_NUM_CHNL-1:0]),
         .CHNL_RX_ACK                   (chnl_rx_ack[C_NUM_CHNL-1:0]),
         .CHNL_RX_DATA_REN              (chnl_rx_data_ren[C_NUM_CHNL-1:0]),
         .CHNL_TX_CLK                   (chnl_tx_clk[C_NUM_CHNL-1:0]),
         .CHNL_TX                       (chnl_tx[C_NUM_CHNL-1:0]),
         .CHNL_TX_LAST                  (chnl_tx_last[C_NUM_CHNL-1:0]),
         .CHNL_TX_LEN                   (chnl_tx_len[(C_NUM_CHNL*`SIG_CHNL_LENGTH_W)-1:0]),
         .CHNL_TX_OFF                   (chnl_tx_off[(C_NUM_CHNL*`SIG_CHNL_OFFSET_W)-1:0]),
         .CHNL_TX_DATA                  (chnl_tx_data[(C_NUM_CHNL*C_PCI_DATA_WIDTH)-1:0]),
         .CHNL_TX_DATA_VALID            (chnl_tx_data_valid[C_NUM_CHNL-1:0]));

    // --------------------  END RIFFA INSTANTAION --------------------
    // --------------------  BEGIN USER CODE  --------------------
            chnl_tester 
                 #(
                   .C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH)
                   )
            chnl_tester_i
                 (

                  .CLK(chnl_clk),
                  .RST(chnl_reset), // chnl_reset includes riffa_endpoint resets
                  // Rx interface
                  .CHNL_RX_CLK(chnl_rx_clk[0]), 
                  .CHNL_RX(chnl_rx[0]), 
                  .CHNL_RX_ACK(chnl_rx_ack[0]), 
                  .CHNL_RX_LAST(chnl_rx_last[0]), 
                  .CHNL_RX_LEN(chnl_rx_len[`SIG_CHNL_LENGTH_W*0 +:`SIG_CHNL_LENGTH_W]), 
                  .CHNL_RX_OFF(chnl_rx_off[`SIG_CHNL_OFFSET_W*0 +:`SIG_CHNL_OFFSET_W]), 
                  .CHNL_RX_DATA(chnl_rx_data[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]), 
                  .CHNL_RX_DATA_VALID(chnl_rx_data_valid[0]), 
                  .CHNL_RX_DATA_REN(chnl_rx_data_ren[0]),
                  // Tx interface
                  .CHNL_TX_CLK(chnl_tx_clk[0]), 
                  .CHNL_TX(chnl_tx[0]), 
                  .CHNL_TX_ACK(chnl_tx_ack[0]), 
                  .CHNL_TX_LAST(chnl_tx_last[0]), 
                  .CHNL_TX_LEN(chnl_tx_len[`SIG_CHNL_LENGTH_W*0 +:`SIG_CHNL_LENGTH_W]), 
                  .CHNL_TX_OFF(chnl_tx_off[`SIG_CHNL_OFFSET_W*0 +:`SIG_CHNL_OFFSET_W]), 
                  .CHNL_TX_DATA(chnl_tx_data[C_PCI_DATA_WIDTH*0 +:C_PCI_DATA_WIDTH]), 
                  .CHNL_TX_DATA_VALID(chnl_tx_data_valid[0]), 
                  .CHNL_TX_DATA_REN(chnl_tx_data_ren[0])
                  );    

	 
	 
				FIFO_BUFFER_CHANNEL2 
                 #(
                   .C_PCI_DATA_WIDTH(C_PCI_DATA_WIDTH)
                   )
				fifo_tester2
                 (

                  .CLK(chnl_clk),
                  .RST(chnl_reset), // chnl_reset includes riffa_endpoint resets
                  // Rx interface
                  .CHNL_RX_CLK(chnl_rx_clk[1]), 
                  .CHNL_RX(chnl_rx[1]), 
                  .CHNL_RX_ACK(chnl_rx_ack[1]), 
                  .CHNL_RX_LAST(chnl_rx_last[1]), 
                  .CHNL_RX_LEN(chnl_rx_len[`SIG_CHNL_LENGTH_W*1 +:`SIG_CHNL_LENGTH_W]), 
                  .CHNL_RX_OFF(chnl_rx_off[`SIG_CHNL_OFFSET_W*1 +:`SIG_CHNL_OFFSET_W]), 
                  .CHNL_RX_DATA(chnl_rx_data[(C_PCI_DATA_WIDTH*(2) - 1) : (C_PCI_DATA_WIDTH*(1))]), 
                  .CHNL_RX_DATA_VALID(chnl_rx_data_valid[1]), 
                  .CHNL_RX_DATA_REN(chnl_rx_data_ren[1]),
                  // Tx interface
                  .CHNL_TX_CLK(chnl_tx_clk[1]), 
                  .CHNL_TX(chnl_tx[1]), 
                  .CHNL_TX_ACK(chnl_tx_ack[1]), 
                  .CHNL_TX_LAST(chnl_tx_last[1]), 
                  .CHNL_TX_LEN(chnl_tx_len[`SIG_CHNL_LENGTH_W*1 +:`SIG_CHNL_LENGTH_W]), 
                  .CHNL_TX_OFF(chnl_tx_off[`SIG_CHNL_OFFSET_W*1 +:`SIG_CHNL_OFFSET_W]), 
                  .CHNL_TX_DATA(chnl_tx_data[(C_PCI_DATA_WIDTH*(2) - 1) : (C_PCI_DATA_WIDTH*(1))]), 
                  .CHNL_TX_DATA_VALID(chnl_tx_data_valid[1]), 
                  .CHNL_TX_DATA_REN(chnl_tx_data_ren[1])
                  ); 
    // --------------------  END USER CODE  --------------------
endmodule
