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



// synthesis translate_off
`timescale 1 ps / 1 ps
////////////////////////////////////////////////////////////////////////////
//
//  For SIMULATION ONLY with the module stratixv_pcie_hip_atoms_ncrypt.v
//
/////////////////////////////////////////////////////////////////////////
//
//  Monitor PCIe TLP between Data Link Layer and Transaction Layer on
//
//          RX : From Data Link Layer to Transaction Layer
//          TX : From Transaction layer to Data Link Layer
//
//  Create a dump file with TLP log : ALTPCIE_MONITOR_SV_HIP_DL_TLP_FILE_LOG
//
/////////////////////////////////////////////////////////////////////////
//
//     Required `define ALTPCIE_MONITOR_SV_HIP_DL
//
/////////////////////////////////////////////////////////////////////////
//
//    example : vcs +define+ALTPCIE_MONITOR_SV_HIP_DL
//
/////////////////////////////////////////////////////////////////////////
//
//  `ifndef ALTPCIE_MONITOR_SV_HIP_DL_SKIP
//     altpcie_monitor_sv_dlhip_sim altpcie_monitor_sv_dlhip_sim (
//        .rx_st_data               (rxdl_st_data            ),
//        .rx_st_valid              (rxdl_st_valid           ),
//        .rx_st_sop                (rxdl_st_sop             ),
//        .rx_st_eop                (rxdl_st_eop             ),
//
//        .tx_st_data               (txdl_st_data            ),
//        .tx_st_parity             (txdl_st_par             ),
//        .tx_st_valid              (txdl_st_valid           ),
//        .tx_st_sop                (txdl_st_sop             ),
//        .tx_st_eop                (txdl_st_eop             ),
//        .tx_st_empty              (txdl_st_empty           ),
//        .tx_st_err                (txdl_st_err             ),
//        .tx_st_ready              (txdl_st_ready           ),
//
//        .clk                      (core_clk                ),
//        .rstn                     (core_rst_n              ),
//        .srst                     (core_srst               )
//     );
//  `endif

// +----------------+---------------+---------+--------------------------------------+
// |       Time     |      TLP Type | Payload |             TLP Header               |
// |       (ns)     |      (tag)    | (bytes) |                 (hex)                |
// +----------------+---------------+---------+--------------------------------------+
// |       19029 RX |   CfgRd0 (02) | 0004    | 04000001_0000020F_01080000           |
// |       19157 RX |   CfgRd0 (01) | 0004    | 04000001_0000010F_0108002C           |
// |       19157 RX |      MRd (00) | 0000    | 00000000_00000000_01080008           |
// |       19197 TX |     CplD (02) | 0004    | 4A000001_00000004_00000200           |
// |       19285 RX |   CfgRd0 (03) | 0004    | 04000001_0000030F_0108003C           |
// |       19325 TX |     CplD (00) | 0004    | 4A000001_00000004_00000000           |
// |       19333 TX |     CplD (00) | 0004    | 4A000001_00000004_00000000           |
// |       19397 TX |     CplD (01) | 0004    | 4A000001_00000004_00000100           |

`define ALTPCIE_MONITOR_SV_HIP_DL_TLP_FILE_LOG "altpcie_monitor_sv_dlhip_tlp_file_log.log"
`define ALTPCIE_MONITOR_SV_HIP_DL_DLP_FILE_LOG "altpcie_monitor_sv_dlhip_dlp_file_log.log"
`define ALTPCIE_MONITOR_SV_HIP_DL_EP_ONLY 1
`define ALTPCIE_MONITOR_SV_HIP_DL_DUMP_IN_PROMPT 0
`define ALTPCIE_MONITOR_SV_HIP_DL_DUMP_IN_LOG_FILE 1

module altpcie_monitor_sv_dlhip_sim (

    // TL TLP data Avalon
      input       [255:0]  tx_st_data,
      input       [3:0]    tx_st_valid,
      input       [3:0]    tx_st_sop,
      input       [3:0]    tx_st_eop,
      input                tx_st_ready,

      // RX Avalon-ST (AST) output to TL
      input  wire  [255:0]   rx_st_data,
      input  wire  [3:0]     rx_st_sop,
      input  wire  [3:0]     rx_st_eop,
      input  wire  [3:0]     rx_st_valid,

      // RX DllP for TL - DL RX
      input wire   [3:0]      rx_val_pm,
      input wire   [11:0]     rx_typ_pm,
      input wire   [3:0]      rx_val_fc,
      input wire   [15:0]     rx_typ_fc,
      input wire   [11:0]     rx_vcid_fc,
      input wire   [31:0]     rx_hdr_fc,
      input wire   [47:0]     rx_data_fc,
      input wire   [3:0]      rx_val_nak,
      input wire   [3:0]      rx_res_nak,
      input wire   [47:0]     rx_num_nak,

      // TL update FC - DL TX
      input wire              req_upfc,
      input wire              ack_snd_upfc,
      input wire              snd_upfc,
      input wire              ack_req_upfc,
      input wire              ack_upfc,
      input wire [1:0]        typ_upfc,
      input wire [2:0]        vcid_upfc,
      input wire [7:0]        hdr_upfc,
      input wire [11:0]       data_upfc,
      input wire              val_upfc,

      input wire              tx_ack_nak,
      input wire              tx_req_nak,
      input wire              tx_val_seqnum,
      input wire              tx_snd_nak,
      input wire              tx_res_nak,
      input wire  [11:0]      tx_num_nak,
      input wire              tx_req_pm,
      input wire              tx_ack_pm,
      input wire [2:0]        tx_typ_pm,

      input wire [63:0]       k_gbl, // k_bgl[15:12] = 0 --> EP
      input wire              clk   ,
      input wire              rstn  ,
      input wire              srst
      );

   time ctime ;
   integer itime ;
   wire srst_int;

`ifdef  ALTPCIE_MONITOR_SV_HIP_DLTL_PROMPT
   localparam PCIE_DUMP_PROMPT=1 `ALTPCIE_MONITOR_SV_HIP_DL_DUMP_IN_PROMPT;
`else
   localparam PCIE_DUMP_PROMPT=`ALTPCIE_MONITOR_SV_HIP_DL_DUMP_IN_PROMPT;
`endif
   localparam PCIE_DUMP_FILE  =`ALTPCIE_MONITOR_SV_HIP_DL_DUMP_IN_LOG_FILE;

   // purpose: produce 1-digit hexadecimal string from a vector
   function [8:1] himage1;
      input [3:0] vec;

      begin
         case (vec)
           4'h0 : himage1 = "0" ;
           4'h1 : himage1 = "1" ;
           4'h2 : himage1 = "2" ;
           4'h3 : himage1 = "3" ;
           4'h4 : himage1 = "4" ;
           4'h5 : himage1 = "5" ;
           4'h6 : himage1 = "6" ;
           4'h7 : himage1 = "7" ;
           4'h8 : himage1 = "8" ;
           4'h9 : himage1 = "9" ;
           4'hA : himage1 = "A" ;
           4'hB : himage1 = "B" ;
           4'hC : himage1 = "C" ;
           4'hD : himage1 = "D" ;
           4'hE : himage1 = "E" ;
           4'hF : himage1 = "F" ;
           4'bzzzz : himage1 = "Z" ;
           default : himage1 = "X" ;
         endcase
      end
   endfunction // himage1

   // purpose: produce 2-digit hexadecimal string from a vector
   function [16:1] himage2 ;
      input [7:0] vec;
      begin
         himage2 = {himage1(vec[7:4]),himage1(vec[3:0])} ;
      end
   endfunction // himage2

   // purpose: produce 4-digit hexadecimal string from a vector
   function [32:1] himage4 ;
      input [15:0] vec;
      begin
         himage4 = {himage2(vec[15:8]),himage2(vec[7:0])} ;
      end
   endfunction // himage4

   // purpose: produce 8-digit hexadecimal string from a vector
   function [64:1] himage8 ;
      input [31:0] vec;
      begin
         himage8 = {himage4(vec[31:16]),himage4(vec[15:0])} ;
      end
   endfunction // himage8

   // purpose: produce 16-digit hexadecimal string from a vector
   function [128:1] himage16 ;
      input [63:0] vec;
      begin
         himage16 = {himage8(vec[63:32]),himage8(vec[31:0])} ;
      end
   endfunction // himage16

   // purpose: produce 1-digit decimal string from an integer
   function [8:1] dimage1 ;
      input [31:0] num ;
      begin
         case (num)
           0 : dimage1 = "0" ;
           1 : dimage1 = "1" ;
           2 : dimage1 = "2" ;
           3 : dimage1 = "3" ;
           4 : dimage1 = "4" ;
           5 : dimage1 = "5" ;
           6 : dimage1 = "6" ;
           7 : dimage1 = "7" ;
           8 : dimage1 = "8" ;
           9 : dimage1 = "9" ;
           default : dimage1 = "U" ;
         endcase // case(num)
      end
   endfunction // dimage1

   // purpose: produce 2-digit decimal string from an integer
   function [16:1] dimage2 ;
      input [31:0] num ;
      begin
         dimage2 = {dimage1(num/10),dimage1(num % 10)} ;
      end
   endfunction // dimage2

   // purpose: produce 3-digit decimal string from an integer
   function [24:1] dimage3 ;
      input [31:0] num ;
      begin
         dimage3 = {dimage1(num/100),dimage2(num % 100)} ;
      end
   endfunction // dimage3

   // purpose: produce 4-digit decimal string from an integer
   function [32:1] dimage4 ;
      input [31:0] num ;
      begin
         dimage4 = {dimage1(num/1000),dimage3(num % 1000)} ;
      end
   endfunction // dimage4

   // purpose: produce 5-digit decimal string from an integer
   function [40:1] dimage5 ;
      input [31:0] num ;
      begin
         dimage5 = {dimage1(num/10000),dimage4(num % 10000)} ;
      end
   endfunction // dimage5

   // purpose: produce 6-digit decimal string from an integer
   function [48:1] dimage6 ;
      input [31:0] num ;
      begin
         dimage6 = {dimage1(num/100000),dimage5(num % 100000)} ;
      end
   endfunction // dimage6

   // purpose: produce 7-digit decimal string from an integer
   function [56:1] dimage7 ;
      input [31:0] num ;
      begin
         dimage7 = {dimage1(num/1000000),dimage6(num % 1000000)} ;
      end
   endfunction // dimage7

  // purpose: select the correct dimage call for ascii conversion
  function  [800:1] image ;
     input  [800:1] msg ;
     input  [32:1]  num ;
     begin
        if (num <= 10)
        begin
           image = {msg, dimage1(num)};
        end
        else if (num <= 100)
        begin
           image = {msg, dimage2(num)};
        end
        else if (num <= 1000)
        begin
           image = {msg, dimage3(num)};
        end
        else if (num <= 10000)
        begin
           image = {msg, dimage4(num)};
        end
        else if (num <= 100000)
        begin
           image = {msg, dimage5(num)};
        end
        else if (num <= 1000000)
        begin
           image = {msg, dimage6(num)};
        end
        else image = {msg, dimage7(num)};
     end
   endfunction

   function [64*8:1] PCieTlpDecode ;
      input  [31:0] h1 ;
      input  [31:0] h2 ;
      input  [31:0] h3 ;
      input  [31:0] h4 ;
      reg    [7*8:1] tlp_type;
      reg    [8*5:1] tag;
      begin
         casex (h1[31:24])
            8'b0000_0000 : begin
                              tlp_type = "MRd"   ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0010_0000 : begin
                              tlp_type = "MRd"   ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0000_0001 : begin
                              tlp_type = "MRdLk" ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0010_0001 : begin
                              tlp_type = "MRdLk" ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0100_0000 : begin
                              tlp_type = "MWr"   ;
                              tag      = "     ";
                           end
            8'b0110_0000 : begin
                              tlp_type = "MWr"   ;
                              tag      = "     ";
                           end
            8'b0000_0010 : begin
                              tlp_type = "IORd"  ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0100_0010 : begin
                              tlp_type = "IOWr"  ;
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0000_0100 : begin
                              tlp_type = "CfgRd0";
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0100_0100 : begin
                              tlp_type = "CfgWr0";
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0000_0101 : begin
                              tlp_type = "CfgRd1";
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0100_0101 : begin
                              tlp_type = "CfgWr1";
                              tag      = {" (",dimage2(h2[15:8]),")"};
                           end
            8'b0011_0XXX : begin
                              tlp_type = "Msg"   ; //TODO Complete all Msg Cases
                              tag      = "     ";
                           end
            8'b0111_0XXX : begin
                              tlp_type = "MsgD"  ;
                              tag      = "     "   ;
                           end
            8'b0000_1010 : begin
                              tlp_type = "Cpl"   ;
                              tag      = {" (",dimage2(h3[15:8]),")"};
                           end
            8'b0100_1010 : begin
                              tlp_type = "CplD"  ;
                              tag      = {" (",dimage2(h3[15:8]),")"};
                           end
            8'b0000_1011 : begin
                              tlp_type = "CplLk" ;
                              tag      = {" (",dimage2(h3[15:8]),")"};
                           end
            8'b0100_1011 : begin
                              tlp_type = "CplDLk";
                              tag      = {" (",dimage2(h3[15:8]),")"};
                           end
            default      : begin
                              tlp_type = "TDB"  ;
                              tag      = "     ";
                           end
         endcase
         if (h1[29]==1'b0) begin           // 3 DWORDs header
            PCieTlpDecode={tlp_type, tag, " | ", dimage4({h1[9:0],2'b00}) , "    | ", himage8(h1), "_", himage8(h2), "_",himage8(h3), "           |"};
         end
         else begin                       // 4 DWORDs header
            PCieTlpDecode={tlp_type, tag, " | ", dimage4({h1[9:0],2'b00}) , "    | ", himage8(h1), "_", himage8(h2), "_",himage8(h3), "_",himage8(h4), "  |"};
         end
      end
   endfunction

   reg         tx_sop_p;
   reg         rx_sop_p;
   reg [127:0] tx_tlp_header0;
   reg [127:0] tx_tlp_header1;
   reg [127:0] tx_tlp_header2;
   reg [127:0] tx_tlp_header3;

   reg [127:0] rx_tlp_header0;
   reg [127:0] rx_tlp_header1;
   reg [127:0] rx_tlp_header2;
   reg [127:0] rx_tlp_header3;


   reg [64*8:1] tlpstring;

   reg [255:0] tx_tlp_p;
   reg [255:0] rx_tlp_p;
   integer filedump;

   initial begin
      if (PCIE_DUMP_FILE==1) begin
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::---------------------------------------------------------------------------------------------");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::                                                               ");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim:: Generating TLP log dump file %s", `ALTPCIE_MONITOR_SV_HIP_DL_TLP_FILE_LOG);
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::                                                               ");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::                                                               ");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::  `define ALTPCIE_MONITOR_SV_HIP_DL_SKIP bypass simulation TLP log dump ");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::  `define ALTPCIE_MONITOR_SV_HIP_DLTL_PROMPT display TLP log dump in simulation message windows ");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::---------------------------------------------------------------------------------------------");
         filedump=$fopen(`ALTPCIE_MONITOR_SV_HIP_DL_TLP_FILE_LOG, "w");
         $fwrite(filedump, "+----------------+---------------+---------+--------------------------------------+\n");
         $fwrite(filedump, "|       Time     |     TLP Type  | Payload |             TLP Header               |\n");
         $fwrite(filedump, "|       (ns)     |       (tag)   | (bytes) |                 (hex)                |\n");
         $fwrite(filedump, "+----------------+---------------+---------+--------------------------------------+\n");
      end
   end
   final begin
      if (PCIE_DUMP_FILE==1) begin
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::---------------------------------------------------------------------------------------------");
         $display("INFO:         altpcie_monitor_sv_dlhip_sim:: Generated TLP log dump file %s", `ALTPCIE_MONITOR_SV_HIP_DL_TLP_FILE_LOG);
         $display("INFO:         altpcie_monitor_sv_dlhip_sim::---------------------------------------------------------------------------------------------");
         $fflush();
         $fflush(filedump) ;
      end
   end

   assign srst_int= (srst==1'b1)?1'b1:((`ALTPCIE_MONITOR_SV_HIP_DL_EP_ONLY==1)&&(k_gbl[15:12]>4'h0))?1'b1:1'b0;

   always @(negedge rstn or posedge clk) begin
      if (rstn == 1'b0) begin
         tx_sop_p       <= 1'b0;
         rx_sop_p       <= 1'b0;

         tx_tlp_p       <= 256'h0;
         rx_tlp_p       <= 256'h0;
      end
      else begin
         if (srst_int == 1'b1)  begin
            tx_sop_p       <= 1'b0;
            rx_sop_p       <= 1'b0;
            tx_tlp_p       <= 256'h0;
            rx_tlp_p       <= 256'h0;
         end
         else begin
            itime = ($time/1000) ;
            rx_tlp_p    <= 128'h0;
            if ((tx_st_valid>4'h0)&&(tx_st_ready==1'b1)) begin
               tx_tlp_p <= tx_st_data;
               tx_sop_p <= tx_st_sop[3];
               if (tx_st_sop[0]==1'b1) begin
                  tlpstring = PCieTlpDecode(tx_st_data[ 31:  0],
                                            tx_st_data[ 63: 32],
                                            tx_st_data[ 95: 64],
                                            tx_st_data[127: 96]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d TX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d TX | %s\n", itime, tlpstring );
               end
               if (tx_st_sop[1]==1'b1) begin
                  tlpstring = PCieTlpDecode(tx_st_data[ 95: 64],
                                            tx_st_data[127: 96],
                                            tx_st_data[159:128],
                                            tx_st_data[191:160]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d TX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d TX | %s\n", itime, tlpstring );
               end
               if (tx_st_sop[2]==1'b1) begin
                  tlpstring =PCieTlpDecode(tx_st_data[159:128],
                                           tx_st_data[191:160],
                                           tx_st_data[223:192],
                                           tx_st_data[255:224]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d TX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d TX | %s\n", itime, tlpstring );
               end
               if (tx_sop_p==1'b1) begin
                  tlpstring = PCieTlpDecode(tx_tlp_p  [223:192],
                                            tx_tlp_p  [255:224],
                                            tx_st_data[ 31:  0],
                                            tx_st_data[ 63: 32]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d TX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d TX | %s\n", itime, tlpstring );
               end
            end
            if (rx_st_valid[0] == 1'b1) begin          // Display EP only k_gbl[15:12]=4'h0
               rx_sop_p    <= rx_st_sop[0];
               rx_tlp_p    <= rx_st_data;
               if (rx_st_sop[3]==1'b1) begin
                  tlpstring =  PCieTlpDecode(rx_st_data[255:224],
                                             rx_st_data[223:192],
                                             rx_st_data[191:160],
                                             rx_st_data[159:128]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d RX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d RX | %s\n", itime, tlpstring );
               end
               if (rx_st_sop[2]==1'b1) begin
                  tlpstring =  PCieTlpDecode(rx_st_data[191:160],
                                             rx_st_data[159:128],
                                             rx_st_data[127: 96],
                                             rx_st_data[95 : 64]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d RX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d RX | %s\n", itime, tlpstring );
               end
               if (rx_st_sop[1]==1'b1) begin
                  tlpstring =  PCieTlpDecode(rx_st_data[127:96],
                                             rx_st_data[95 :64],
                                             rx_st_data[63 :32],
                                             rx_st_data[31 : 0]);
                  if (PCIE_DUMP_PROMPT==1) $display("%d RX | %s", itime, tlpstring );
                  if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d RX | %s\n", itime, tlpstring );
               end
            end // if (rx_st_valid>4'h0)
            if (rx_sop_p==1'b1) begin
               tlpstring =  PCieTlpDecode(rx_tlp_p  [63 : 32],
                                          rx_tlp_p  [31 :  0],
                                          rx_st_data[255:224],
                                          rx_st_data[223:192]);
               if (PCIE_DUMP_PROMPT==1) $display("%d RX | %s", itime, tlpstring );
               if (PCIE_DUMP_FILE==1) $fwrite(filedump, "| %d RX | %s\n", itime, tlpstring );
            end // if (rx_sop_p==1'b1)
         end // else: !if(srst_int == 1'b1)
      end
   end


endmodule
// synthesis translate_on


