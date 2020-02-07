// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



   /* Address Mapping
       10'h200: LTSSM FIFO Data
               [31:27]=Reserved; [25:19]=SignalDetect; [18:11]=LockedToData; [10:7]=Lane; [6:5]=Speed; [4:0]=LTSSM;
       10'h201: LTSSM FIFO Status
               [31:8]=Timer; [7:0]=FIFO usedw;
       10'h202: LMI Control
               [31:14]=Reserved; [13]=Completion; [12]=GO; [11:0]=LMI Address
       10'h203: LMI Data
               [31:0]=LMI Data
       10'h204:  Reserved
          .
          .
    */

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_inspector #(
      parameter PLD_CLK_IS_250MHZ = 0,
      parameter LANES             = 8
) (
output logic [31:0] addr_decode_o, // DEBUG
output logic [31:0] reg_mux_out_o, // DEBUG

      // AVMM slave
      input  logic               avmm_clk_i,
      input  logic               avmm_rstn_i,
      input  logic [9:0]         avmm_address_i,
      input  logic               avmm_write_i,
      input  logic [31:0]        avmm_writedata_i,
      input  logic               avmm_read_i,
      output logic [31:0]        avmm_readdata_o,
      output logic               avmm_readdatavalid_o,
      output logic               avmm_waitrequest_o,

      // AVMM master for accessing HIP AVMM space
      output logic               hip_clk_o,
      output logic               hip_rstn_o,
      output logic [9:0]         hip_address_o,
      output logic [1:0]         hip_byteen_o,
      output logic               hip_write_o,
      output logic [15:0]        hip_writedata_o,
      output logic               hip_read_o,
      input  logic [15:0]        hip_readdata_i,
      output logic               hip_sershiftload_o,
      output logic               hip_interfacesel_o,

      // HIP status signals
      input  logic               pld_clk_i,
      input  logic               pld_rstn_i,
      input  logic [4:0]         ltssmstate_i,
      input  logic [LANES-1:0]   signaldetect_i,
      input  logic [LANES-1:0]   is_lockedtodata_i,
      input  logic [1:0]         currentspeed_i,
      input  logic [3:0]         lane_act_i,
      input  logic [31:0]        lmi_dout_i,
      input  logic               lmi_ack_i,
      output logic [11:0]        lmi_addr_o,
      output logic               lmi_rden_o,

      // AST signals
      input  logic [31:0]        tlp_insp_data_i,
      output logic [31:0]        tlp_insp_addr_o,
      output logic [127:0]       tlp_insp_trigger_o
);

   // DPRIO INIT
   localparam IDLE  = 2'b00;
   localparam SER   = 2'b01;
   localparam SEL   = 2'b11;
   localparam DONE  = 2'b10;

   logic [1:0]                        is_250_clk;
   logic                              insp_addr_sel;
   logic [31:0]                       addr_decode;
   logic [31:0]                       reg_mux_out;
   logic [31:0]                       read_data_reg;
   logic                              avmm_read_r;
   logic                              avmm_read_rise;
   logic                              avmm_read_rise_r;
   logic                              avmm_read_rise_rr;
   logic                              avmm_read_rise_r3;
   logic                              avmm_read_rise_r4;

   // LTSSM FIFO
   logic [LANES-1:0]                  signaldetect_r;
   logic [LANES-1:0]                  signaldetect_sync;
   logic [LANES-1:0]                  is_lockedtodata_r;
   logic [LANES-1:0]                  is_lockedtodata_sync;
   logic [4:0]                        ltssm_r;
   logic                              ltssmfifo_wrreq;
   logic                              ltssmfifo_rdreq;
   logic [63:0]                       ltssmfifo_dataout;
   logic [63:0]                       ltssmfifo_datain;
   logic [31:0]                       ltssmfifo_datain_lo;
   logic [31:0]                       ltssmfifo_datain_hi;
   logic [6:0]                        ltssmfifo_wrusedw;
   logic [6:0]                        ltssmfifo_rdusedw;
   logic [24:0]                       ltssmfifo_timer;

   // LMI signals
   logic                              lmi_ack_r;
   logic                              lmi_ack_rise;
   logic                              lmi_ack_sync;
   logic                              lmi_ack_sync_r;
   logic                              lmi_ack_sync_rr;
   logic                              lmi_ack_sync_rise;
   logic                              lmi_ack_sync_rise_r;
   logic                              lmi_ack_sync_rise_rr;
   logic [31:0]                       lmi_dout_r;
   logic [31:0]                       lmi_dout_rr;
   logic                              lmi_rden_r;
   logic                              lmi_rden_rr;
   logic                              lmi_rden_rise;
   logic                              lmi_rden_rise_r;
   logic [11:0]                       lmi_addr_r;
   logic [11:0]                       lmi_addr_rr;
   logic [31:0]                       cfg_control_reg; // Store ACK, GO, and address for LMI (RW)
   logic [31:0]                       cfg_data_reg;    // Store data coming back from LMI (RO)

   // TLP inspector
   logic [127:0]                      tlp_insp_trigger_r;
   logic [31:0]                       tlp_insp_ctrl0_reg;
   logic [31:0]                       tlp_insp_ctrl1_reg;
   logic [31:0]                       tlp_insp_ctrl2_reg;
   logic [31:0]                       tlp_insp_ctrl3_reg;
   logic [31:0]                       tlp_insp_addr_reg;
   logic [31:0]                       tlp_insp_data_reg;
   logic [31:0]                       tlp_insp_addr_r;
   logic [31:0]                       tlp_insp_data_r;


   // DPRIO
   logic [1:0]                        init_state;
   logic [2:0]                        init_count;

   // DEBUG
   assign addr_decode_o = addr_decode;
   assign reg_mux_out_o = reg_mux_out;

   /* ================================================================================ */
   /*                                   Address decode                                 */
   /* ================================================================================ */

   assign insp_addr_sel = avmm_address_i[9];
   assign is_250_clk    = (PLD_CLK_IS_250MHZ == 1)? 2'b01:2'b00;

   always_comb begin
      case (avmm_address_i)
         10'h200: addr_decode[31:0] = 32'h0000_0001; // LTSSM data
         10'h201: addr_decode[31:0] = 32'h0000_0002; // LTSSM status
         10'h202: addr_decode[31:0] = 32'h0000_0004; // CFG control
         10'h203: addr_decode[31:0] = 32'h0000_0008; // CFG data
         10'h204: addr_decode[31:0] = 32'h0000_0010; // TLP trigger h0
         10'h205: addr_decode[31:0] = 32'h0000_0020; // TLP trigger h1
         10'h206: addr_decode[31:0] = 32'h0000_0040; // TLP trigger h2
         10'h207: addr_decode[31:0] = 32'h0000_0080; // TLP trigger h3
         10'h208: addr_decode[31:0] = 32'h0000_0100; // TLP addr
         10'h209: addr_decode[31:0] = 32'h0000_0200; // TLP data
         default: addr_decode[31:0] = 32'h0;
      endcase
   end
   always_comb begin
      case (addr_decode[9:0])
         10'h001: reg_mux_out = {is_250_clk, ltssmfifo_dataout[29:0]};
         10'h002: reg_mux_out = {ltssmfifo_dataout[56:32], ltssmfifo_rdusedw};
         10'h004: reg_mux_out = cfg_control_reg;
         10'h008: reg_mux_out = cfg_data_reg;
         10'h200: reg_mux_out = tlp_insp_data_reg;
         default: reg_mux_out = 8'h0;
      endcase
   end

   /* ================================================================================ */
   /*                                  LTSSM FIFO                                      */
   /* ================================================================================ */
   always_ff @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if(~pld_rstn_i)
         ltssm_r <= 5'h0;
      else
         ltssm_r <= ltssmstate_i;
   end
   // Synchronizer - unknown clock to pld_clk
   always_ff @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i) begin
         signaldetect_r         <= {LANES{1'h0}};
         signaldetect_sync      <= {LANES{1'h0}};
         is_lockedtodata_r      <= {LANES{1'h0}};
         is_lockedtodata_sync   <= {LANES{1'h0}};;
      end
      else begin
         signaldetect_r         <= signaldetect_i;
         signaldetect_sync      <= signaldetect_r;
         is_lockedtodata_r      <= is_lockedtodata_i;
         is_lockedtodata_sync   <= is_lockedtodata_r;
      end
   end
   always_ff @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if(~pld_rstn_i)
         ltssmfifo_timer <= 25'h0;
      else if (ltssmfifo_wrreq)
         ltssmfifo_timer <= 25'h1;
      else if (ltssmfifo_timer != 25'h1ffffff)
         ltssmfifo_timer <= ltssmfifo_timer + 25'h1;
   end
   /* Produce a single-cycle pulse if these registers been accessed (R/W)
    * Since read will asserted for 2 cycles, use avmm_read_rise instead*/
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if(~avmm_rstn_i)
         avmm_read_r <= 1'b0;
      else
         avmm_read_r <= avmm_read_i;
   end
   assign avmm_read_rise = ~avmm_read_r & avmm_read_i;

   assign ltssmfifo_wrreq      = (ltssm_r != ltssmstate_i);
   assign ltssmfifo_rdreq      = ((ltssmfifo_rdusedw != 0) & (addr_decode[0] & avmm_read_rise)) | (ltssmfifo_wrusedw>120);
   assign ltssmfifo_datain     = {ltssmfifo_datain_hi, ltssmfifo_datain_lo};
   assign ltssmfifo_datain_hi  = {7'h0, ltssmfifo_timer};
   assign ltssmfifo_datain_lo  = (LANES==8)? {5'h0, signaldetect_sync,     is_lockedtodata_sync,lane_act_i,currentspeed_i,ltssmstate_i}:
                                 (LANES==4)? {9'h0, signaldetect_sync,4'h0,is_lockedtodata_sync,lane_act_i,currentspeed_i,ltssmstate_i}:
                                 (LANES==2)? {11'h0,signaldetect_sync,6'h0,is_lockedtodata_sync,lane_act_i,currentspeed_i,ltssmstate_i}:
                                 (LANES==1)? {12'h0,signaldetect_sync,7'h0,is_lockedtodata_sync,lane_act_i,currentspeed_i,ltssmstate_i}:
                                 32'h0;
   insp_dcfifo ltssm_fifo (
      .aclr      (~pld_rstn_i),
      .data      (ltssmfifo_datain),
      .rdclk     (avmm_clk_i),
      .rdreq     (ltssmfifo_rdreq),
      .wrclk     (pld_clk_i),
      .wrreq     (ltssmfifo_wrreq),
      .q         (ltssmfifo_dataout),
      .rdusedw   (ltssmfifo_rdusedw),
      .wrusedw   (ltssmfifo_wrusedw)
   );

   /* ================================================================================ */
   /*                          Configuration Space Register                            */
   /* ================================================================================ */
   // Synchronizer to capture LMI_ACK signals from pld_clk(faster) to avmm_clk(slower)
   always @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i)
         lmi_ack_r <= 1'b0;
      else
         lmi_ack_r <= lmi_ack_i;
   end
   assign lmi_ack_rise = ~lmi_ack_r & lmi_ack_i;
   always @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i)
         lmi_ack_sync    <= 1'b0;
      else if (lmi_ack_rise)
         lmi_ack_sync    <= 1'b1;
      else if (lmi_ack_sync_rise_rr)
         lmi_ack_sync    <= 1'b0;
   end
   always @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i) begin
         lmi_ack_sync_r   <= 1'b0;
         lmi_ack_sync_rr  <= 1'b0;
         lmi_dout_rr      <= 32'h0;
      end
      else begin
         lmi_ack_sync_r   <= lmi_ack_sync;
         lmi_ack_sync_rr  <= lmi_ack_sync_r;
         lmi_dout_rr      <= lmi_dout_r;
      end
   end
   assign lmi_ack_sync_rise  = ~lmi_ack_sync_rr & lmi_ack_sync_r;
   always @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i) begin
         lmi_ack_sync_rise_r   <= 1'b0;
         lmi_ack_sync_rise_rr  <= 1'b0;
      end
      else begin
         lmi_ack_sync_rise_r   <= lmi_ack_sync_rise;
         lmi_ack_sync_rise_rr  <= lmi_ack_sync_rise_r;
      end
   end // End of synchronizer for LMI_ACK
   // Synchronizer for LMI_DOUT
   always @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i)
         lmi_dout_r <= 32'h0;
      else
         lmi_dout_r <= lmi_dout_i;
   end
   // Synchronizer for LMI_RDEN and LMI_ADDR derived from cfg_control_reg
   always_ff @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i) begin
         lmi_rden_r      <= 1'b0;
         lmi_rden_rr     <= 1'b0;
         lmi_rden_rise   <= 1'b0;
         lmi_rden_rise_r <= 1'b0;
         lmi_addr_r      <= 12'h0;
         lmi_addr_rr     <= 12'h0;
      end
      else begin
         lmi_rden_r      <= cfg_control_reg[12];
         lmi_rden_rr     <= lmi_rden_r;
         lmi_rden_rise   <= ~lmi_rden_rr & lmi_rden_r;
         lmi_rden_rise_r <= lmi_rden_rise;
         lmi_addr_r      <= cfg_control_reg[11:0];
         lmi_addr_rr     <= lmi_addr_r;
      end
   end
   assign lmi_rden_o = lmi_rden_rise_r;
   assign lmi_addr_o = lmi_addr_rr;

   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i)
         cfg_control_reg     <= 32'h0;
      else if (avmm_write_i & addr_decode[2])
         cfg_control_reg     <= {19'h0, avmm_writedata_i[12:0]};
      else if (lmi_ack_sync_rise) begin
         cfg_control_reg[13] <= 1'b1; // Completion bit
         cfg_control_reg[12] <= 1'b0; // Go bit
      end
   end
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i)
         cfg_data_reg <= 32'h0;
      else if (lmi_ack_sync_rr)
         cfg_data_reg <= lmi_dout_rr;
   end

   /* ================================================================================ */
   /*                                   TLP Inspector                                  */
   /* ================================================================================ */
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i) begin
         tlp_insp_ctrl0_reg <= 32'h0;
         tlp_insp_ctrl1_reg <= 32'h0;
         tlp_insp_ctrl2_reg <= 32'h0;
         tlp_insp_ctrl3_reg <= 32'h0;
         tlp_insp_addr_reg  <= 32'h0;
      end
      else if (avmm_write_i) begin
         if (addr_decode[4])
            tlp_insp_ctrl0_reg <= avmm_writedata_i;
         else if (addr_decode[5])
            tlp_insp_ctrl1_reg <= avmm_writedata_i;
         else if (addr_decode[6])
            tlp_insp_ctrl2_reg <= avmm_writedata_i;
         else if (addr_decode[7])
            tlp_insp_ctrl3_reg <= avmm_writedata_i;
         else if (addr_decode[8])
            tlp_insp_addr_reg  <= avmm_writedata_i;
      end
   end

   // TLP Monitor address and trigger signals. Synchronizer from avmm_clk to pld_clk.
   always_ff @(posedge pld_clk_i or negedge pld_rstn_i) begin
      if (~pld_rstn_i) begin
         tlp_insp_trigger_r <= 128'h0;
         tlp_insp_trigger_o <= 128'h0;
         tlp_insp_addr_r    <= 32'h0;
         tlp_insp_addr_o    <= 32'h0;
      end
      else begin
         tlp_insp_trigger_r <= {tlp_insp_ctrl3_reg, tlp_insp_ctrl2_reg, tlp_insp_ctrl1_reg, tlp_insp_ctrl0_reg};
         tlp_insp_trigger_o <= tlp_insp_trigger_r;
         tlp_insp_addr_r    <= tlp_insp_addr_reg;
         tlp_insp_addr_o    <= tlp_insp_addr_r;
      end
   end

   // TLP Monitor data
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i) begin
         tlp_insp_data_reg <= 32'h0;
         tlp_insp_data_r   <= 32'h0;
      end
      else begin
         tlp_insp_data_r   <= tlp_insp_data_i;
         tlp_insp_data_reg <= tlp_insp_data_r;
      end
   end

   assign tlp_insp_monitor_addr_o = tlp_insp_addr_reg;

   /* ================================================================================ */
   /*                                      DPRIO                                       */
   /* ================================================================================ */
   assign hip_clk_o       = avmm_clk_i;
   assign hip_rstn_o      = avmm_rstn_i;
   assign hip_address_o   = avmm_address_i;
   assign hip_byteen_o    = 2'b11;
   assign hip_write_o     = (~insp_addr_sel)? avmm_write_i : 1'b0;
   assign hip_writedata_o = avmm_writedata_i[15:0];
   assign hip_read_o      = (~insp_addr_sel)? avmm_read_i  : 1'b0;
   always @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if (~avmm_rstn_i) begin
         init_state         <= IDLE;
         init_count         <= 0;
         hip_sershiftload_o <= 1'b1;
         hip_interfacesel_o      <= 1'b1;
      end
      else begin
         init_count <= init_count + 1'b1;

         case (init_state)
         IDLE: begin
            if(&init_count) begin
               init_state <= SER;
               hip_sershiftload_o <= 1'b0;
               hip_interfacesel_o <= 1'b1;
            end
         end
         SER : begin
            if(&init_count) begin
               init_state <= SEL;
               hip_sershiftload_o <= 1'b1;
               hip_interfacesel_o <= 1'b1;
            end
         end
         SEL : begin
            if(&init_count) begin
               init_state <= DONE;
               hip_sershiftload_o <= 1'b1;
               hip_interfacesel_o <= 1'b0;
            end
         end
         DONE : begin
            init_state <= DONE;
            hip_sershiftload_o <= 1'b1;
            hip_interfacesel_o <= 1'b0;
         end
         default: init_state <= IDLE;
         endcase
      end
   end

   /* ================================================================================ */
   /*                                  AVMM Outputs                                    */
   /* ================================================================================ */
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if(~avmm_rstn_i)
         read_data_reg <= 32'h0;
      else
         read_data_reg <= reg_mux_out;
   end
   always_ff @(posedge avmm_clk_i or negedge avmm_rstn_i) begin
      if(~avmm_rstn_i) begin
         avmm_read_rise_r  <= 1'b0;
         avmm_read_rise_rr <= 1'b0;
         avmm_read_rise_r3 <= 1'b0;
         avmm_read_rise_r4 <= 1'b0;
      end
      else begin
         avmm_read_rise_r  <= avmm_read_rise;
         avmm_read_rise_rr <= avmm_read_rise_r;
         avmm_read_rise_r3 <= avmm_read_rise_rr;
         avmm_read_rise_r4 <= avmm_read_rise_r3;
      end
   end

   assign avmm_readdata_o      = (insp_addr_sel)? read_data_reg : {16'h0,hip_readdata_i};
   assign avmm_readdatavalid_o = (~insp_addr_sel)?  avmm_read_rise_r4:                      // 4 clocks latency for DPRIO read
                                 (addr_decode[0]|addr_decode[1])? avmm_read_rise_rr :       // 2 clocks latency for LTSSM FIFO
                                 (addr_decode[3])? cfg_control_reg[13] & avmm_read_rise_r : // 1 clock latency for LMI register
                                 (addr_decode[9])? avmm_read_rise_r :
                                 1'b1;
   assign avmm_waitrequest_o   = (avmm_read_i)? ~avmm_readdatavalid_o:
                                 (avmm_write_i)? 1'b0 : 1'b1;

endmodule

/**************************************************************
 * Used for arbitration between HIP reconfig and JTAG ADME
 **************************************************************/
module insp_arbiter (
      input  logic  clk_i,
      input  logic  rstn_i,
      input  logic  reconfig_req_i,
      input  logic  adme_req_i,

      output logic  reconfig_grant_o,
      output logic  adme_grant_o
);
   logic [1:0] arb_state;
   logic [1:0] arb_nxt_state;

   localparam ARB_IDLE           = 2'b00;
   localparam ARB_RECONFIG_GRANT = 2'b01;
   localparam ARB_ADME_GRANT     = 2'b10;

   always_ff @(posedge clk_i or negedge rstn_i) begin
      if (~rstn_i)
         arb_state <= ARB_IDLE;
      else
         arb_state <= arb_nxt_state;
   end

   always_comb begin
      case (arb_state)
      ARB_IDLE:
         if (reconfig_req_i)
            arb_nxt_state <= ARB_RECONFIG_GRANT;
         else if (adme_req_i)
            arb_nxt_state <= ARB_ADME_GRANT;
         else
            arb_nxt_state <= ARB_IDLE;

      ARB_RECONFIG_GRANT:
         if (adme_req_i & ~reconfig_req_i)
            arb_nxt_state <= ARB_ADME_GRANT;
         else if (reconfig_req_i)
            arb_nxt_state <= ARB_RECONFIG_GRANT;
         else
            arb_nxt_state <= ARB_IDLE;

      ARB_ADME_GRANT:
         if (reconfig_req_i & ~adme_req_i)
            arb_nxt_state <= ARB_RECONFIG_GRANT;
         else if (adme_req_i)
            arb_nxt_state <= ARB_ADME_GRANT;
         else
            arb_nxt_state <= ARB_IDLE;

      default: arb_nxt_state <= ARB_IDLE;
      endcase
   end

   assign reconfig_grant_o = (arb_state == ARB_RECONFIG_GRANT);
   assign adme_grant_o     = (arb_state == ARB_ADME_GRANT);

endmodule

/**************************************************************
 * Cross clock-domain FIFO. Generated by MegaWizard
 * Width = 64. Depth = 128.
 * Async reset synchronized to write clock
 **************************************************************/
module insp_dcfifo #(
        parameter WIDTH = 64
) (
        aclr,
        data,
        rdclk,
        rdreq,
        wrclk,
        wrreq,
        q,
        rdusedw,
        wrusedw);

        input     aclr;
        input   [WIDTH-1:0]  data;
        input     rdclk;
        input     rdreq;
        input     wrclk;
        input     wrreq;
        output  [WIDTH-1:0]  q;
        output  [6:0]  rdusedw;
        output  [6:0]  wrusedw;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
        tri0      aclr;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

        wire [WIDTH-1:0] sub_wire0;
        wire [6:0] sub_wire1;
        wire [6:0] sub_wire2;
        wire [WIDTH-1:0] q = sub_wire0[WIDTH-1:0];
        wire [6:0] rdusedw = sub_wire1[6:0];
        wire [6:0] wrusedw = sub_wire2[6:0];

        dcfifo  dcfifo_component (
                                .aclr (aclr),
                                .data (data),
                                .rdclk (rdclk),
                                .rdreq (rdreq),
                                .wrclk (wrclk),
                                .wrreq (wrreq),
                                .q (sub_wire0),
                                .rdusedw (sub_wire1),
                                .wrusedw (sub_wire2),
                                .rdempty (),
                                .rdfull (),
                                .wrempty (),
                                .wrfull ());
        defparam
                dcfifo_component.intended_device_family = "Stratix V",
                dcfifo_component.lpm_numwords = 128,
                dcfifo_component.lpm_showahead = "OFF",
                dcfifo_component.lpm_type = "dcfifo",
                dcfifo_component.lpm_width = WIDTH,
                dcfifo_component.lpm_widthu = 7,
                dcfifo_component.overflow_checking = "OFF",
                dcfifo_component.rdsync_delaypipe = 4,
                dcfifo_component.read_aclr_synch = "OFF",
                dcfifo_component.underflow_checking = "OFF",
                dcfifo_component.use_eab = "ON",
                dcfifo_component.write_aclr_synch = "ON",
                dcfifo_component.wrsync_delaypipe = 4;
endmodule
