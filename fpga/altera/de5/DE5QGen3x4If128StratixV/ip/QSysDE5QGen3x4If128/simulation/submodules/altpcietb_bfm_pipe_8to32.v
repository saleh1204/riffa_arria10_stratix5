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




////////////////////////////////////////////////////////////
//
// 32 to 8 bit pipe simulation conversion
//
// synthesis translate_off
`timescale 1ns / 1ps

module altpcietb_bfm_rxpipe_8bit_to_32_bit (
      // Input PIPE simulation _ext for simulation only
      input                 sim_pipe8_pclk,
      input                 aclr,

      input                 phystatus0_ext,
      input                 phystatus1_ext,
      input                 phystatus2_ext,
      input                 phystatus3_ext,
      input                 phystatus4_ext,
      input                 phystatus5_ext,
      input                 phystatus6_ext,
      input                 phystatus7_ext,
      input  [7 : 0]        rxdata0_ext,
      input  [7 : 0]        rxdata1_ext,
      input  [7 : 0]        rxdata2_ext,
      input  [7 : 0]        rxdata3_ext,
      input  [7 : 0]        rxdata4_ext,
      input  [7 : 0]        rxdata5_ext,
      input  [7 : 0]        rxdata6_ext,
      input  [7 : 0]        rxdata7_ext,
      input                 rxdatak0_ext,
      input                 rxdatak1_ext,
      input                 rxdatak2_ext,
      input                 rxdatak3_ext,
      input                 rxdatak4_ext,
      input                 rxdatak5_ext,
      input                 rxdatak6_ext,
      input                 rxdatak7_ext,
      input                 rxelecidle0_ext,
      input                 rxelecidle1_ext,
      input                 rxelecidle2_ext,
      input                 rxelecidle3_ext,
      input                 rxelecidle4_ext,
      input                 rxelecidle5_ext,
      input                 rxelecidle6_ext,
      input                 rxelecidle7_ext,
      input                 rxfreqlocked0_ext,
      input                 rxfreqlocked1_ext,
      input                 rxfreqlocked2_ext,
      input                 rxfreqlocked3_ext,
      input                 rxfreqlocked4_ext,
      input                 rxfreqlocked5_ext,
      input                 rxfreqlocked6_ext,
      input                 rxfreqlocked7_ext,
      input  [2 : 0]        rxstatus0_ext,
      input  [2 : 0]        rxstatus1_ext,
      input  [2 : 0]        rxstatus2_ext,
      input  [2 : 0]        rxstatus3_ext,
      input  [2 : 0]        rxstatus4_ext,
      input  [2 : 0]        rxstatus5_ext,
      input  [2 : 0]        rxstatus6_ext,
      input  [2 : 0]        rxstatus7_ext,
      input                 rxdataskip0_ext,
      input                 rxdataskip1_ext,
      input                 rxdataskip2_ext,
      input                 rxdataskip3_ext,
      input                 rxdataskip4_ext,
      input                 rxdataskip5_ext,
      input                 rxdataskip6_ext,
      input                 rxdataskip7_ext,
      input                 rxblkst0_ext,
      input                 rxblkst1_ext,
      input                 rxblkst2_ext,
      input                 rxblkst3_ext,
      input                 rxblkst4_ext,
      input                 rxblkst5_ext,
      input                 rxblkst6_ext,
      input                 rxblkst7_ext,
      input  [1 : 0]        rxsynchd0_ext,
      input  [1 : 0]        rxsynchd1_ext,
      input  [1 : 0]        rxsynchd2_ext,
      input  [1 : 0]        rxsynchd3_ext,
      input  [1 : 0]        rxsynchd4_ext,
      input  [1 : 0]        rxsynchd5_ext,
      input  [1 : 0]        rxsynchd6_ext,
      input  [1 : 0]        rxsynchd7_ext,
      input                 rxvalid0_ext,
      input                 rxvalid1_ext,
      input                 rxvalid2_ext,
      input                 rxvalid3_ext,
      input                 rxvalid4_ext,
      input                 rxvalid5_ext,
      input                 rxvalid6_ext,
      input                 rxvalid7_ext,

      output                    sim_pipe32_pclk,
      output reg                phystatus0_ext32b,
      output reg                phystatus1_ext32b,
      output reg                phystatus2_ext32b,
      output reg                phystatus3_ext32b,
      output reg                phystatus4_ext32b,
      output reg                phystatus5_ext32b,
      output reg                phystatus6_ext32b,
      output reg                phystatus7_ext32b,
      output reg [31 : 0]       rxdata0_ext32b,
      output reg [31 : 0]       rxdata1_ext32b,
      output reg [31 : 0]       rxdata2_ext32b,
      output reg [31 : 0]       rxdata3_ext32b,
      output reg [31 : 0]       rxdata4_ext32b,
      output reg [31 : 0]       rxdata5_ext32b,
      output reg [31 : 0]       rxdata6_ext32b,
      output reg [31 : 0]       rxdata7_ext32b,
      output reg [3  : 0]       rxdatak0_ext32b,
      output reg [3  : 0]       rxdatak1_ext32b,
      output reg [3  : 0]       rxdatak2_ext32b,
      output reg [3  : 0]       rxdatak3_ext32b,
      output reg [3  : 0]       rxdatak4_ext32b,
      output reg [3  : 0]       rxdatak5_ext32b,
      output reg [3  : 0]       rxdatak6_ext32b,
      output reg [3  : 0]       rxdatak7_ext32b,
      output reg                rxelecidle0_ext32b,
      output reg                rxelecidle1_ext32b,
      output reg                rxelecidle2_ext32b,
      output reg                rxelecidle3_ext32b,
      output reg                rxelecidle4_ext32b,
      output reg                rxelecidle5_ext32b,
      output reg                rxelecidle6_ext32b,
      output reg                rxelecidle7_ext32b,
      output reg                rxfreqlocked0_ext32b,
      output reg                rxfreqlocked1_ext32b,
      output reg                rxfreqlocked2_ext32b,
      output reg                rxfreqlocked3_ext32b,
      output reg                rxfreqlocked4_ext32b,
      output reg                rxfreqlocked5_ext32b,
      output reg                rxfreqlocked6_ext32b,
      output reg                rxfreqlocked7_ext32b,
      output reg [2 : 0]        rxstatus0_ext32b,
      output reg [2 : 0]        rxstatus1_ext32b,
      output reg [2 : 0]        rxstatus2_ext32b,
      output reg [2 : 0]        rxstatus3_ext32b,
      output reg [2 : 0]        rxstatus4_ext32b,
      output reg [2 : 0]        rxstatus5_ext32b,
      output reg [2 : 0]        rxstatus6_ext32b,
      output reg [2 : 0]        rxstatus7_ext32b,
      output reg                rxdataskip0_ext32b,
      output reg                rxdataskip1_ext32b,
      output reg                rxdataskip2_ext32b,
      output reg                rxdataskip3_ext32b,
      output reg                rxdataskip4_ext32b,
      output reg                rxdataskip5_ext32b,
      output reg                rxdataskip6_ext32b,
      output reg                rxdataskip7_ext32b,
      output reg                rxblkst0_ext32b,
      output reg                rxblkst1_ext32b,
      output reg                rxblkst2_ext32b,
      output reg                rxblkst3_ext32b,
      output reg                rxblkst4_ext32b,
      output reg                rxblkst5_ext32b,
      output reg                rxblkst6_ext32b,
      output reg                rxblkst7_ext32b,
      output reg [1 : 0]        rxsynchd0_ext32b,
      output reg [1 : 0]        rxsynchd1_ext32b,
      output reg [1 : 0]        rxsynchd2_ext32b,
      output reg [1 : 0]        rxsynchd3_ext32b,
      output reg [1 : 0]        rxsynchd4_ext32b,
      output reg [1 : 0]        rxsynchd5_ext32b,
      output reg [1 : 0]        rxsynchd6_ext32b,
      output reg [1 : 0]        rxsynchd7_ext32b,
      output reg                rxvalid0_ext32b,
      output reg                rxvalid1_ext32b,
      output reg                rxvalid2_ext32b,
      output reg                rxvalid3_ext32b,
      output reg                rxvalid4_ext32b,
      output reg                rxvalid5_ext32b,
      output reg                rxvalid6_ext32b,
      output reg                rxvalid7_ext32b
      );

   reg [1:0] cnt;
   reg [1:0] cnt_rx;
   genvar i;

   reg [23 : 0]       rxdata0_ext_i_32b;
   reg [23 : 0]       rxdata1_ext_i_32b;
   reg [23 : 0]       rxdata2_ext_i_32b;
   reg [23 : 0]       rxdata3_ext_i_32b;
   reg [23 : 0]       rxdata4_ext_i_32b;
   reg [23 : 0]       rxdata5_ext_i_32b;
   reg [23 : 0]       rxdata6_ext_i_32b;
   reg [23 : 0]       rxdata7_ext_i_32b;
   reg [2  : 0]       rxdatak0_ext_i_32b;
   reg [2  : 0]       rxdatak1_ext_i_32b;
   reg [2  : 0]       rxdatak2_ext_i_32b;
   reg [2  : 0]       rxdatak3_ext_i_32b;
   reg [2  : 0]       rxdatak4_ext_i_32b;
   reg [2  : 0]       rxdatak5_ext_i_32b;
   reg [2  : 0]       rxdatak6_ext_i_32b;
   reg [2  : 0]       rxdatak7_ext_i_32b;

   reg                phystatus0_ext_r_32b;
   reg                phystatus1_ext_r_32b;
   reg                phystatus2_ext_r_32b;
   reg                phystatus3_ext_r_32b;
   reg                phystatus4_ext_r_32b;
   reg                phystatus5_ext_r_32b;
   reg                phystatus6_ext_r_32b;
   reg                phystatus7_ext_r_32b;
   reg [31 : 0]       rxdata0_ext_r_32b;
   reg [31 : 0]       rxdata1_ext_r_32b;
   reg [31 : 0]       rxdata2_ext_r_32b;
   reg [31 : 0]       rxdata3_ext_r_32b;
   reg [31 : 0]       rxdata4_ext_r_32b;
   reg [31 : 0]       rxdata5_ext_r_32b;
   reg [31 : 0]       rxdata6_ext_r_32b;
   reg [31 : 0]       rxdata7_ext_r_32b;
   reg [3  : 0]       rxdatak0_ext_r_32b;
   reg [3  : 0]       rxdatak1_ext_r_32b;
   reg [3  : 0]       rxdatak2_ext_r_32b;
   reg [3  : 0]       rxdatak3_ext_r_32b;
   reg [3  : 0]       rxdatak4_ext_r_32b;
   reg [3  : 0]       rxdatak5_ext_r_32b;
   reg [3  : 0]       rxdatak6_ext_r_32b;
   reg [3  : 0]       rxdatak7_ext_r_32b;
   reg                rxelecidle0_ext_r_32b;
   reg                rxelecidle1_ext_r_32b;
   reg                rxelecidle2_ext_r_32b;
   reg                rxelecidle3_ext_r_32b;
   reg                rxelecidle4_ext_r_32b;
   reg                rxelecidle5_ext_r_32b;
   reg                rxelecidle6_ext_r_32b;
   reg                rxelecidle7_ext_r_32b;
   reg                rxfreqlocked0_ext_r_32b;
   reg                rxfreqlocked1_ext_r_32b;
   reg                rxfreqlocked2_ext_r_32b;
   reg                rxfreqlocked3_ext_r_32b;
   reg                rxfreqlocked4_ext_r_32b;
   reg                rxfreqlocked5_ext_r_32b;
   reg                rxfreqlocked6_ext_r_32b;
   reg                rxfreqlocked7_ext_r_32b;
   reg [2 : 0]        rxstatus0_ext_r_32b;
   reg [2 : 0]        rxstatus1_ext_r_32b;
   reg [2 : 0]        rxstatus2_ext_r_32b;
   reg [2 : 0]        rxstatus3_ext_r_32b;
   reg [2 : 0]        rxstatus4_ext_r_32b;
   reg [2 : 0]        rxstatus5_ext_r_32b;
   reg [2 : 0]        rxstatus6_ext_r_32b;
   reg [2 : 0]        rxstatus7_ext_r_32b;
   reg                rxdataskip0_ext_r_32b;
   reg                rxdataskip1_ext_r_32b;
   reg                rxdataskip2_ext_r_32b;
   reg                rxdataskip3_ext_r_32b;
   reg                rxdataskip4_ext_r_32b;
   reg                rxdataskip5_ext_r_32b;
   reg                rxdataskip6_ext_r_32b;
   reg                rxdataskip7_ext_r_32b;
   reg                rxblkst0_ext_r_32b;
   reg                rxblkst1_ext_r_32b;
   reg                rxblkst2_ext_r_32b;
   reg                rxblkst3_ext_r_32b;
   reg                rxblkst4_ext_r_32b;
   reg                rxblkst5_ext_r_32b;
   reg                rxblkst6_ext_r_32b;
   reg                rxblkst7_ext_r_32b;
   reg [1 : 0]        rxsynchd0_ext_r_32b;
   reg [1 : 0]        rxsynchd1_ext_r_32b;
   reg [1 : 0]        rxsynchd2_ext_r_32b;
   reg [1 : 0]        rxsynchd3_ext_r_32b;
   reg [1 : 0]        rxsynchd4_ext_r_32b;
   reg [1 : 0]        rxsynchd5_ext_r_32b;
   reg [1 : 0]        rxsynchd6_ext_r_32b;
   reg [1 : 0]        rxsynchd7_ext_r_32b;
   reg                rxvalid0_ext_r_32b;
   reg                rxvalid1_ext_r_32b;
   reg                rxvalid2_ext_r_32b;
   reg                rxvalid3_ext_r_32b;
   reg                rxvalid4_ext_r_32b;
   reg                rxvalid5_ext_r_32b;
   reg                rxvalid6_ext_r_32b;
   reg                rxvalid7_ext_r_32b;

   assign sim_pipe32_pclk = cnt[1];

   assign rxvalid_ext =  |{rxvalid7_ext,rxvalid6_ext,rxvalid5_ext,rxvalid4_ext,
                           rxvalid3_ext,rxvalid2_ext,rxvalid1_ext,rxvalid0_ext};

   always @(posedge sim_pipe32_pclk or negedge aclr) begin
      if (aclr == 1'b0) begin
        phystatus0_ext32b<=          1'b0;
        phystatus1_ext32b<=          1'b0;
        phystatus2_ext32b<=          1'b0;
        phystatus3_ext32b<=          1'b0;
        phystatus4_ext32b<=          1'b0;
        phystatus5_ext32b<=          1'b0;
        phystatus6_ext32b<=          1'b0;
        phystatus7_ext32b<=          1'b0;
        rxdata0_ext32b<=             0;
        rxdata1_ext32b<=             0;
        rxdata2_ext32b<=             0;
        rxdata3_ext32b<=             0;
        rxdata4_ext32b<=             0;
        rxdata5_ext32b<=             0;
        rxdata6_ext32b<=             0;
        rxdata7_ext32b<=             0;
        rxdatak0_ext32b<=            0;
        rxdatak1_ext32b<=            0;
        rxdatak2_ext32b<=            0;
        rxdatak3_ext32b<=            0;
        rxdatak4_ext32b<=            0;
        rxdatak5_ext32b<=            0;
        rxdatak6_ext32b<=            0;
        rxdatak7_ext32b<=            0;
        rxelecidle0_ext32b<=         0;
        rxelecidle1_ext32b<=         0;
        rxelecidle2_ext32b<=         0;
        rxelecidle3_ext32b<=         0;
        rxelecidle4_ext32b<=         0;
        rxelecidle5_ext32b<=         0;
        rxelecidle6_ext32b<=         0;
        rxelecidle7_ext32b<=         0;
        rxfreqlocked0_ext32b<=       0;
        rxfreqlocked1_ext32b<=       0;
        rxfreqlocked2_ext32b<=       0;
        rxfreqlocked3_ext32b<=       0;
        rxfreqlocked4_ext32b<=       0;
        rxfreqlocked5_ext32b<=       0;
        rxfreqlocked6_ext32b<=       0;
        rxfreqlocked7_ext32b<=       0;
        rxstatus0_ext32b<=           0;
        rxstatus1_ext32b<=           0;
        rxstatus2_ext32b<=           0;
        rxstatus3_ext32b<=           0;
        rxstatus4_ext32b<=           0;
        rxstatus5_ext32b<=           0;
        rxstatus6_ext32b<=           0;
        rxstatus7_ext32b<=           0;
        rxdataskip0_ext32b<=         0;
        rxdataskip1_ext32b<=         0;
        rxdataskip2_ext32b<=         0;
        rxdataskip3_ext32b<=         0;
        rxdataskip4_ext32b<=         0;
        rxdataskip5_ext32b<=         0;
        rxdataskip6_ext32b<=         0;
        rxdataskip7_ext32b<=         0;
        rxblkst0_ext32b<=            0;
        rxblkst1_ext32b<=            0;
        rxblkst2_ext32b<=            0;
        rxblkst3_ext32b<=            0;
        rxblkst4_ext32b<=            0;
        rxblkst5_ext32b<=            0;
        rxblkst6_ext32b<=            0;
        rxblkst7_ext32b<=            0;
        rxsynchd0_ext32b<=           0;
        rxsynchd1_ext32b<=           0;
        rxsynchd2_ext32b<=           0;
        rxsynchd3_ext32b<=           0;
        rxsynchd4_ext32b<=           0;
        rxsynchd5_ext32b<=           0;
        rxsynchd6_ext32b<=           0;
        rxsynchd7_ext32b<=           0;
        rxvalid0_ext32b<=            0;
        rxvalid1_ext32b<=            0;
        rxvalid2_ext32b<=            0;
        rxvalid3_ext32b<=            0;
        rxvalid4_ext32b<=            0;
        rxvalid5_ext32b<=            0;
        rxvalid6_ext32b<=            0;
        rxvalid7_ext32b<=            0;
      end
      else begin
        phystatus0_ext32b<=          phystatus0_ext_r_32b;
        phystatus1_ext32b<=          phystatus1_ext_r_32b;
        phystatus2_ext32b<=          phystatus2_ext_r_32b;
        phystatus3_ext32b<=          phystatus3_ext_r_32b;
        phystatus4_ext32b<=          phystatus4_ext_r_32b;
        phystatus5_ext32b<=          phystatus5_ext_r_32b;
        phystatus6_ext32b<=          phystatus6_ext_r_32b;
        phystatus7_ext32b<=          phystatus7_ext_r_32b;
        rxdata0_ext32b<=             rxdata0_ext_r_32b;
        rxdata1_ext32b<=             rxdata1_ext_r_32b;
        rxdata2_ext32b<=             rxdata2_ext_r_32b;
        rxdata3_ext32b<=             rxdata3_ext_r_32b;
        rxdata4_ext32b<=             rxdata4_ext_r_32b;
        rxdata5_ext32b<=             rxdata5_ext_r_32b;
        rxdata6_ext32b<=             rxdata6_ext_r_32b;
        rxdata7_ext32b<=             rxdata7_ext_r_32b;
        rxdatak0_ext32b<=            rxdatak0_ext_r_32b;
        rxdatak1_ext32b<=            rxdatak1_ext_r_32b;
        rxdatak2_ext32b<=            rxdatak2_ext_r_32b;
        rxdatak3_ext32b<=            rxdatak3_ext_r_32b;
        rxdatak4_ext32b<=            rxdatak4_ext_r_32b;
        rxdatak5_ext32b<=            rxdatak5_ext_r_32b;
        rxdatak6_ext32b<=            rxdatak6_ext_r_32b;
        rxdatak7_ext32b<=            rxdatak7_ext_r_32b;
        rxelecidle0_ext32b<=         rxelecidle0_ext_r_32b;
        rxelecidle1_ext32b<=         rxelecidle1_ext_r_32b;
        rxelecidle2_ext32b<=         rxelecidle2_ext_r_32b;
        rxelecidle3_ext32b<=         rxelecidle3_ext_r_32b;
        rxelecidle4_ext32b<=         rxelecidle4_ext_r_32b;
        rxelecidle5_ext32b<=         rxelecidle5_ext_r_32b;
        rxelecidle6_ext32b<=         rxelecidle6_ext_r_32b;
        rxelecidle7_ext32b<=         rxelecidle7_ext_r_32b;
        rxfreqlocked0_ext32b<=       rxfreqlocked0_ext_r_32b;
        rxfreqlocked1_ext32b<=       rxfreqlocked1_ext_r_32b;
        rxfreqlocked2_ext32b<=       rxfreqlocked2_ext_r_32b;
        rxfreqlocked3_ext32b<=       rxfreqlocked3_ext_r_32b;
        rxfreqlocked4_ext32b<=       rxfreqlocked4_ext_r_32b;
        rxfreqlocked5_ext32b<=       rxfreqlocked5_ext_r_32b;
        rxfreqlocked6_ext32b<=       rxfreqlocked6_ext_r_32b;
        rxfreqlocked7_ext32b<=       rxfreqlocked7_ext_r_32b;
        rxstatus0_ext32b<=           rxstatus0_ext_r_32b;
        rxstatus1_ext32b<=           rxstatus1_ext_r_32b;
        rxstatus2_ext32b<=           rxstatus2_ext_r_32b;
        rxstatus3_ext32b<=           rxstatus3_ext_r_32b;
        rxstatus4_ext32b<=           rxstatus4_ext_r_32b;
        rxstatus5_ext32b<=           rxstatus5_ext_r_32b;
        rxstatus6_ext32b<=           rxstatus6_ext_r_32b;
        rxstatus7_ext32b<=           rxstatus7_ext_r_32b;
        rxdataskip0_ext32b<=         rxdataskip0_ext_r_32b;
        rxdataskip1_ext32b<=         rxdataskip1_ext_r_32b;
        rxdataskip2_ext32b<=         rxdataskip2_ext_r_32b;
        rxdataskip3_ext32b<=         rxdataskip3_ext_r_32b;
        rxdataskip4_ext32b<=         rxdataskip4_ext_r_32b;
        rxdataskip5_ext32b<=         rxdataskip5_ext_r_32b;
        rxdataskip6_ext32b<=         rxdataskip6_ext_r_32b;
        rxdataskip7_ext32b<=         rxdataskip7_ext_r_32b;
        rxblkst0_ext32b<=            rxblkst0_ext_r_32b;
        rxblkst1_ext32b<=            rxblkst1_ext_r_32b;
        rxblkst2_ext32b<=            rxblkst2_ext_r_32b;
        rxblkst3_ext32b<=            rxblkst3_ext_r_32b;
        rxblkst4_ext32b<=            rxblkst4_ext_r_32b;
        rxblkst5_ext32b<=            rxblkst5_ext_r_32b;
        rxblkst6_ext32b<=            rxblkst6_ext_r_32b;
        rxblkst7_ext32b<=            rxblkst7_ext_r_32b;
        rxsynchd0_ext32b<=           rxsynchd0_ext_r_32b;
        rxsynchd1_ext32b<=           rxsynchd1_ext_r_32b;
        rxsynchd2_ext32b<=           rxsynchd2_ext_r_32b;
        rxsynchd3_ext32b<=           rxsynchd3_ext_r_32b;
        rxsynchd4_ext32b<=           rxsynchd4_ext_r_32b;
        rxsynchd5_ext32b<=           rxsynchd5_ext_r_32b;
        rxsynchd6_ext32b<=           rxsynchd6_ext_r_32b;
        rxsynchd7_ext32b<=           rxsynchd7_ext_r_32b;
        rxvalid0_ext32b<=            rxvalid0_ext_r_32b;
        rxvalid1_ext32b<=            rxvalid1_ext_r_32b;
        rxvalid2_ext32b<=            rxvalid2_ext_r_32b;
        rxvalid3_ext32b<=            rxvalid3_ext_r_32b;
        rxvalid4_ext32b<=            rxvalid4_ext_r_32b;
        rxvalid5_ext32b<=            rxvalid5_ext_r_32b;
        rxvalid6_ext32b<=            rxvalid6_ext_r_32b;
        rxvalid7_ext32b<=            rxvalid7_ext_r_32b;
      end
   end

   always @(posedge sim_pipe8_pclk or negedge aclr) begin
      if (aclr == 1'b0) begin
         cnt <=4'h0;
         phystatus0_ext_r_32b       <= 0;
         phystatus1_ext_r_32b       <= 0;
         phystatus2_ext_r_32b       <= 0;
         phystatus3_ext_r_32b       <= 0;
         phystatus4_ext_r_32b       <= 0;
         phystatus5_ext_r_32b       <= 0;
         phystatus6_ext_r_32b       <= 0;
         phystatus7_ext_r_32b       <= 0;
         rxelecidle0_ext_r_32b      <= 0;
         rxelecidle1_ext_r_32b      <= 0;
         rxelecidle2_ext_r_32b      <= 0;
         rxelecidle3_ext_r_32b      <= 0;
         rxelecidle4_ext_r_32b      <= 0;
         rxelecidle5_ext_r_32b      <= 0;
         rxelecidle6_ext_r_32b      <= 0;
         rxelecidle7_ext_r_32b      <= 0;
         rxfreqlocked0_ext_r_32b    <= 0;
         rxfreqlocked1_ext_r_32b    <= 0;
         rxfreqlocked2_ext_r_32b    <= 0;
         rxfreqlocked3_ext_r_32b    <= 0;
         rxfreqlocked4_ext_r_32b    <= 0;
         rxfreqlocked5_ext_r_32b    <= 0;
         rxfreqlocked6_ext_r_32b    <= 0;
         rxfreqlocked7_ext_r_32b    <= 0;
         rxstatus0_ext_r_32b        <= 0;
         rxstatus1_ext_r_32b        <= 0;
         rxstatus2_ext_r_32b        <= 0;
         rxstatus3_ext_r_32b        <= 0;
         rxstatus4_ext_r_32b        <= 0;
         rxstatus5_ext_r_32b        <= 0;
         rxstatus6_ext_r_32b        <= 0;
         rxstatus7_ext_r_32b        <= 0;
         rxdataskip0_ext_r_32b      <= 0;
         rxdataskip1_ext_r_32b      <= 0;
         rxdataskip2_ext_r_32b      <= 0;
         rxdataskip3_ext_r_32b      <= 0;
         rxdataskip4_ext_r_32b      <= 0;
         rxdataskip5_ext_r_32b      <= 0;
         rxdataskip6_ext_r_32b      <= 0;
         rxdataskip7_ext_r_32b      <= 0;
         rxblkst0_ext_r_32b         <= 0;
         rxblkst1_ext_r_32b         <= 0;
         rxblkst2_ext_r_32b         <= 0;
         rxblkst3_ext_r_32b         <= 0;
         rxblkst4_ext_r_32b         <= 0;
         rxblkst5_ext_r_32b         <= 0;
         rxblkst6_ext_r_32b         <= 0;
         rxblkst7_ext_r_32b         <= 0;
         rxsynchd0_ext_r_32b        <= 0;
         rxsynchd1_ext_r_32b        <= 0;
         rxsynchd2_ext_r_32b        <= 0;
         rxsynchd3_ext_r_32b        <= 0;
         rxsynchd4_ext_r_32b        <= 0;
         rxsynchd5_ext_r_32b        <= 0;
         rxsynchd6_ext_r_32b        <= 0;
         rxsynchd7_ext_r_32b        <= 0;
         rxvalid0_ext_r_32b         <= 0;
         rxvalid1_ext_r_32b         <= 0;
         rxvalid2_ext_r_32b         <= 0;
         rxvalid3_ext_r_32b         <= 0;
         rxvalid4_ext_r_32b         <= 0;
         rxvalid5_ext_r_32b         <= 0;
         rxvalid6_ext_r_32b         <= 0;
         rxvalid7_ext_r_32b         <= 0;
         {rxdata0_ext_r_32b, rxdatak0_ext_r_32b}<=36'h0;
         {rxdata1_ext_r_32b, rxdatak1_ext_r_32b}<=36'h0;
         {rxdata2_ext_r_32b, rxdatak2_ext_r_32b}<=36'h0;
         {rxdata3_ext_r_32b, rxdatak3_ext_r_32b}<=36'h0;
         {rxdata4_ext_r_32b, rxdatak4_ext_r_32b}<=36'h0;
         {rxdata5_ext_r_32b, rxdatak5_ext_r_32b}<=36'h0;
         {rxdata6_ext_r_32b, rxdatak6_ext_r_32b}<=36'h0;
         {rxdata7_ext_r_32b, rxdatak7_ext_r_32b}<=36'h0;
      end
      else begin
         if (rxvalid_ext==1'b1) begin
               cnt_rx <=cnt_rx+2'h1;
         end
         else begin
               cnt_rx <=2'h0;
         end

         if (cnt_rx==2'b11) begin
            {rxdata0_ext_r_32b, rxdatak0_ext_r_32b}<= (rxvalid0_ext==1'b0)?36'h0:{rxdata0_ext,rxdata0_ext_i_32b[23:0], rxdatak0_ext, rxdatak0_ext_i_32b[2:0]};
            {rxdata1_ext_r_32b, rxdatak1_ext_r_32b}<= (rxvalid1_ext==1'b0)?36'h0:{rxdata1_ext,rxdata1_ext_i_32b[23:0], rxdatak1_ext, rxdatak1_ext_i_32b[2:0]};
            {rxdata2_ext_r_32b, rxdatak2_ext_r_32b}<= (rxvalid2_ext==1'b0)?36'h0:{rxdata2_ext,rxdata2_ext_i_32b[23:0], rxdatak2_ext, rxdatak2_ext_i_32b[2:0]};
            {rxdata3_ext_r_32b, rxdatak3_ext_r_32b}<= (rxvalid3_ext==1'b0)?36'h0:{rxdata3_ext,rxdata3_ext_i_32b[23:0], rxdatak3_ext, rxdatak3_ext_i_32b[2:0]};
            {rxdata4_ext_r_32b, rxdatak4_ext_r_32b}<= (rxvalid4_ext==1'b0)?36'h0:{rxdata4_ext,rxdata4_ext_i_32b[23:0], rxdatak4_ext, rxdatak4_ext_i_32b[2:0]};
            {rxdata5_ext_r_32b, rxdatak5_ext_r_32b}<= (rxvalid5_ext==1'b0)?36'h0:{rxdata5_ext,rxdata5_ext_i_32b[23:0], rxdatak5_ext, rxdatak5_ext_i_32b[2:0]};
            {rxdata6_ext_r_32b, rxdatak6_ext_r_32b}<= (rxvalid6_ext==1'b0)?36'h0:{rxdata6_ext,rxdata6_ext_i_32b[23:0], rxdatak6_ext, rxdatak6_ext_i_32b[2:0]};
            {rxdata7_ext_r_32b, rxdatak7_ext_r_32b}<= (rxvalid7_ext==1'b0)?36'h0:{rxdata7_ext,rxdata7_ext_i_32b[23:0], rxdatak7_ext, rxdatak7_ext_i_32b[2:0]};
         end

         if (1==1) begin
            cnt <=cnt+2'h1;
            phystatus0_ext_r_32b       <= ((phystatus0_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus0_ext:1'b1;
            phystatus1_ext_r_32b       <= ((phystatus1_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus1_ext:1'b1;
            phystatus2_ext_r_32b       <= ((phystatus2_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus2_ext:1'b1;
            phystatus3_ext_r_32b       <= ((phystatus3_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus3_ext:1'b1;
            phystatus4_ext_r_32b       <= ((phystatus4_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus4_ext:1'b1;
            phystatus5_ext_r_32b       <= ((phystatus5_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus5_ext:1'b1;
            phystatus6_ext_r_32b       <= ((phystatus6_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus6_ext:1'b1;
            phystatus7_ext_r_32b       <= ((phystatus7_ext_r_32b==1'b0)||(cnt==2'b10))?phystatus7_ext:1'b1;
            rxelecidle0_ext_r_32b      <= rxelecidle0_ext;
            rxelecidle1_ext_r_32b      <= rxelecidle1_ext;
            rxelecidle2_ext_r_32b      <= rxelecidle2_ext;
            rxelecidle3_ext_r_32b      <= rxelecidle3_ext;
            rxelecidle4_ext_r_32b      <= rxelecidle4_ext;
            rxelecidle5_ext_r_32b      <= rxelecidle5_ext;
            rxelecidle6_ext_r_32b      <= rxelecidle6_ext;
            rxelecidle7_ext_r_32b      <= rxelecidle7_ext;
            rxfreqlocked0_ext_r_32b    <= rxfreqlocked0_ext;
            rxfreqlocked1_ext_r_32b    <= rxfreqlocked1_ext;
            rxfreqlocked2_ext_r_32b    <= rxfreqlocked2_ext;
            rxfreqlocked3_ext_r_32b    <= rxfreqlocked3_ext;
            rxfreqlocked4_ext_r_32b    <= rxfreqlocked4_ext;
            rxfreqlocked5_ext_r_32b    <= rxfreqlocked5_ext;
            rxfreqlocked6_ext_r_32b    <= rxfreqlocked6_ext;
            rxfreqlocked7_ext_r_32b    <= rxfreqlocked7_ext;
            rxstatus0_ext_r_32b        <= ((rxstatus0_ext_r_32b==3'h4)||(rxstatus0_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus0_ext:3'h3;
            rxstatus1_ext_r_32b        <= ((rxstatus1_ext_r_32b==3'h4)||(rxstatus1_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus1_ext:3'h3;
            rxstatus2_ext_r_32b        <= ((rxstatus2_ext_r_32b==3'h4)||(rxstatus2_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus2_ext:3'h3;
            rxstatus3_ext_r_32b        <= ((rxstatus3_ext_r_32b==3'h4)||(rxstatus3_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus3_ext:3'h3;
            rxstatus4_ext_r_32b        <= ((rxstatus4_ext_r_32b==3'h4)||(rxstatus4_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus4_ext:3'h3;
            rxstatus5_ext_r_32b        <= ((rxstatus5_ext_r_32b==3'h4)||(rxstatus5_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus5_ext:3'h3;
            rxstatus6_ext_r_32b        <= ((rxstatus6_ext_r_32b==3'h4)||(rxstatus6_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus6_ext:3'h3;
            rxstatus7_ext_r_32b        <= ((rxstatus7_ext_r_32b==3'h4)||(rxstatus7_ext_r_32b==3'h0)||(cnt==2'b11))?rxstatus7_ext:3'h3;
            rxdataskip0_ext_r_32b      <= rxdataskip0_ext;
            rxdataskip1_ext_r_32b      <= rxdataskip1_ext;
            rxdataskip2_ext_r_32b      <= rxdataskip2_ext;
            rxdataskip3_ext_r_32b      <= rxdataskip3_ext;
            rxdataskip4_ext_r_32b      <= rxdataskip4_ext;
            rxdataskip5_ext_r_32b      <= rxdataskip5_ext;
            rxdataskip6_ext_r_32b      <= rxdataskip6_ext;
            rxdataskip7_ext_r_32b      <= rxdataskip7_ext;
            rxblkst0_ext_r_32b         <= rxblkst0_ext;
            rxblkst1_ext_r_32b         <= rxblkst1_ext;
            rxblkst2_ext_r_32b         <= rxblkst2_ext;
            rxblkst3_ext_r_32b         <= rxblkst3_ext;
            rxblkst4_ext_r_32b         <= rxblkst4_ext;
            rxblkst5_ext_r_32b         <= rxblkst5_ext;
            rxblkst6_ext_r_32b         <= rxblkst6_ext;
            rxblkst7_ext_r_32b         <= rxblkst7_ext;
            rxsynchd0_ext_r_32b        <= rxsynchd0_ext;
            rxsynchd1_ext_r_32b        <= rxsynchd1_ext;
            rxsynchd2_ext_r_32b        <= rxsynchd2_ext;
            rxsynchd3_ext_r_32b        <= rxsynchd3_ext;
            rxsynchd4_ext_r_32b        <= rxsynchd4_ext;
            rxsynchd5_ext_r_32b        <= rxsynchd5_ext;
            rxsynchd6_ext_r_32b        <= rxsynchd6_ext;
            rxsynchd7_ext_r_32b        <= rxsynchd7_ext;
            rxvalid0_ext_r_32b         <= rxvalid0_ext;
            rxvalid1_ext_r_32b         <= rxvalid1_ext;
            rxvalid2_ext_r_32b         <= rxvalid2_ext;
            rxvalid3_ext_r_32b         <= rxvalid3_ext;
            rxvalid4_ext_r_32b         <= rxvalid4_ext;
            rxvalid5_ext_r_32b         <= rxvalid5_ext;
            rxvalid6_ext_r_32b         <= rxvalid6_ext;
            rxvalid7_ext_r_32b         <= rxvalid7_ext;
         end
      end
   end

   generate
      for (i=0;i<3;i=i+1) begin : g_pipe
         always @(posedge sim_pipe8_pclk or negedge aclr) begin
            if (aclr == 1'b0) begin
               rxdata0_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata1_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata2_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata3_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata4_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata5_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata6_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
               rxdata7_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;

               rxdatak0_ext_i_32b[i] <= 1'h0;
               rxdatak1_ext_i_32b[i] <= 1'h0;
               rxdatak2_ext_i_32b[i] <= 1'h0;
               rxdatak3_ext_i_32b[i] <= 1'h0;
               rxdatak4_ext_i_32b[i] <= 1'h0;
               rxdatak5_ext_i_32b[i] <= 1'h0;
               rxdatak6_ext_i_32b[i] <= 1'h0;
               rxdatak7_ext_i_32b[i] <= 1'h0;
            end
            else begin
               if (cnt_rx==i) begin
                  rxdata0_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata0_ext[7:0];
                  rxdata1_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata1_ext[7:0];
                  rxdata2_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata2_ext[7:0];
                  rxdata3_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata3_ext[7:0];
                  rxdata4_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata4_ext[7:0];
                  rxdata5_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata5_ext[7:0];
                  rxdata6_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata6_ext[7:0];
                  rxdata7_ext_i_32b[((i+1)*8)-1:i*8] <= rxdata7_ext[7:0];

                  rxdatak0_ext_i_32b[i] <= rxdatak0_ext;
                  rxdatak1_ext_i_32b[i] <= rxdatak1_ext;
                  rxdatak2_ext_i_32b[i] <= rxdatak2_ext;
                  rxdatak3_ext_i_32b[i] <= rxdatak3_ext;
                  rxdatak4_ext_i_32b[i] <= rxdatak4_ext;
                  rxdatak5_ext_i_32b[i] <= rxdatak5_ext;
                  rxdatak6_ext_i_32b[i] <= rxdatak6_ext;
                  rxdatak7_ext_i_32b[i] <= rxdatak7_ext;
               end
               else if (((cnt_rx==0) && (i>0)) || (cnt_rx==i-1)) begin
                  rxdata0_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata1_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata2_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata3_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata4_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata5_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata6_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;
                  rxdata7_ext_i_32b[((i+1)*8)-1:i*8] <= 8'h0;

                  rxdatak0_ext_i_32b[i] <= 1'h0;
                  rxdatak1_ext_i_32b[i] <= 1'h0;
                  rxdatak2_ext_i_32b[i] <= 1'h0;
                  rxdatak3_ext_i_32b[i] <= 1'h0;
                  rxdatak4_ext_i_32b[i] <= 1'h0;
                  rxdatak5_ext_i_32b[i] <= 1'h0;
                  rxdatak6_ext_i_32b[i] <= 1'h0;
                  rxdatak7_ext_i_32b[i] <= 1'h0;
               end
            end
         end
      end
   endgenerate

endmodule

`timescale 1ns / 1ps
module altpcietb_bfm_txpipe_8bit_to_32_bit (
      input                 sim_pipe8_pclk,
      input                 sim_pipe32_pclk,
      input                 aclr,
      input                 pipe_mode_simu_only,

      input [2 : 0]        eidleinfersel0,
      input [2 : 0]        eidleinfersel1,
      input [2 : 0]        eidleinfersel2,
      input [2 : 0]        eidleinfersel3,
      input [2 : 0]        eidleinfersel4,
      input [2 : 0]        eidleinfersel5,
      input [2 : 0]        eidleinfersel6,
      input [2 : 0]        eidleinfersel7,
      input [1 : 0]        powerdown0,
      input [1 : 0]        powerdown1,
      input [1 : 0]        powerdown2,
      input [1 : 0]        powerdown3,
      input [1 : 0]        powerdown4,
      input [1 : 0]        powerdown5,
      input [1 : 0]        powerdown6,
      input [1 : 0]        powerdown7,
      input                rxpolarity0,
      input                rxpolarity1,
      input                rxpolarity2,
      input                rxpolarity3,
      input                rxpolarity4,
      input                rxpolarity5,
      input                rxpolarity6,
      input                rxpolarity7,
      input                txcompl0,
      input                txcompl1,
      input                txcompl2,
      input                txcompl3,
      input                txcompl4,
      input                txcompl5,
      input                txcompl6,
      input                txcompl7,
      input [31 : 0]       txdata0,
      input [31 : 0]       txdata1,
      input [31 : 0]       txdata2,
      input [31 : 0]       txdata3,
      input [31 : 0]       txdata4,
      input [31 : 0]       txdata5,
      input [31 : 0]       txdata6,
      input [31 : 0]       txdata7,
      input [3 : 0]        txdatak0,
      input [3 : 0]        txdatak1,
      input [3 : 0]        txdatak2,
      input [3 : 0]        txdatak3,
      input [3 : 0]        txdatak4,
      input [3 : 0]        txdatak5,
      input [3 : 0]        txdatak6,
      input [3 : 0]        txdatak7,
      //input                txdatavalid0,
      //input                txdatavalid1,
      //input                txdatavalid2,
      //input                txdatavalid3,
      //input                txdatavalid4,
      //input                txdatavalid5,
      //input                txdatavalid6,
      //input                txdatavalid7,
      input                txdetectrx0,
      input                txdetectrx1,
      input                txdetectrx2,
      input                txdetectrx3,
      input                txdetectrx4,
      input                txdetectrx5,
      input                txdetectrx6,
      input                txdetectrx7,
      input                txelecidle0,
      input                txelecidle1,
      input                txelecidle2,
      input                txelecidle3,
      input                txelecidle4,
      input                txelecidle5,
      input                txelecidle6,
      input                txelecidle7,
      input [2 : 0]        txmargin0,
      input [2 : 0]        txmargin1,
      input [2 : 0]        txmargin2,
      input [2 : 0]        txmargin3,
      input [2 : 0]        txmargin4,
      input [2 : 0]        txmargin5,
      input [2 : 0]        txmargin6,
      input [2 : 0]        txmargin7,
      input                txdeemph0,
      input                txdeemph1,
      input                txdeemph2,
      input                txdeemph3,
      input                txdeemph4,
      input                txdeemph5,
      input                txdeemph6,
      input                txdeemph7,
      input                txswing0,
      input                txswing1,
      input                txswing2,
      input                txswing3,
      input                txswing4,
      input                txswing5,
      input                txswing6,
      input                txswing7,
      input                txblkst0,
      input                txblkst1,
      input                txblkst2,
      input                txblkst3,
      input                txblkst4,
      input                txblkst5,
      input                txblkst6,
      input                txblkst7,
      input [1 : 0]        txsynchd0,
      input [1 : 0]        txsynchd1,
      input [1 : 0]        txsynchd2,
      input [1 : 0]        txsynchd3,
      input [1 : 0]        txsynchd4,
      input [1 : 0]        txsynchd5,
      input [1 : 0]        txsynchd6,
      input [1 : 0]        txsynchd7,
      input [17 : 0]       currentcoeff0,
      input [17 : 0]       currentcoeff1,
      input [17 : 0]       currentcoeff2,
      input [17 : 0]       currentcoeff3,
      input [17 : 0]       currentcoeff4,
      input [17 : 0]       currentcoeff5,
      input [17 : 0]       currentcoeff6,
      input [17 : 0]       currentcoeff7,
      input [2 : 0]        currentrxpreset0,
      input [2 : 0]        currentrxpreset1,
      input [2 : 0]        currentrxpreset2,
      input [2 : 0]        currentrxpreset3,
      input [2 : 0]        currentrxpreset4,
      input [2 : 0]        currentrxpreset5,
      input [2 : 0]        currentrxpreset6,
      input [2 : 0]        currentrxpreset7,

      output [2 : 0]   eidleinfersel0_ext,
      output [2 : 0]   eidleinfersel1_ext,
      output [2 : 0]   eidleinfersel2_ext,
      output [2 : 0]   eidleinfersel3_ext,
      output [2 : 0]   eidleinfersel4_ext,
      output [2 : 0]   eidleinfersel5_ext,
      output [2 : 0]   eidleinfersel6_ext,
      output [2 : 0]   eidleinfersel7_ext,
      output [1 : 0]   powerdown0_ext,
      output [1 : 0]   powerdown1_ext,
      output [1 : 0]   powerdown2_ext,
      output [1 : 0]   powerdown3_ext,
      output [1 : 0]   powerdown4_ext,
      output [1 : 0]   powerdown5_ext,
      output [1 : 0]   powerdown6_ext,
      output [1 : 0]   powerdown7_ext,
      output           rxpolarity0_ext,
      output           rxpolarity1_ext,
      output           rxpolarity2_ext,
      output           rxpolarity3_ext,
      output           rxpolarity4_ext,
      output           rxpolarity5_ext,
      output           rxpolarity6_ext,
      output           rxpolarity7_ext,
      output           txcompl0_ext,
      output           txcompl1_ext,
      output           txcompl2_ext,
      output           txcompl3_ext,
      output           txcompl4_ext,
      output           txcompl5_ext,
      output           txcompl6_ext,
      output           txcompl7_ext,
      output [7 : 0]   txdata0_ext,
      output [7 : 0]   txdata1_ext,
      output [7 : 0]   txdata2_ext,
      output [7 : 0]   txdata3_ext,
      output [7 : 0]   txdata4_ext,
      output [7 : 0]   txdata5_ext,
      output [7 : 0]   txdata6_ext,
      output [7 : 0]   txdata7_ext,
      output           txdatak0_ext,
      output           txdatak1_ext,
      output           txdatak2_ext,
      output           txdatak3_ext,
      output           txdatak4_ext,
      output           txdatak5_ext,
      output           txdatak6_ext,
      output           txdatak7_ext,
      output           txdetectrx0_ext,
      output           txdetectrx1_ext,
      output           txdetectrx2_ext,
      output           txdetectrx3_ext,
      output           txdetectrx4_ext,
      output           txdetectrx5_ext,
      output           txdetectrx6_ext,
      output           txdetectrx7_ext,
      output           txelecidle0_ext,
      output           txelecidle1_ext,
      output           txelecidle2_ext,
      output           txelecidle3_ext,
      output           txelecidle4_ext,
      output           txelecidle5_ext,
      output           txelecidle6_ext,
      output           txelecidle7_ext,
      output [2 : 0]   txmargin0_ext,
      output [2 : 0]   txmargin1_ext,
      output [2 : 0]   txmargin2_ext,
      output [2 : 0]   txmargin3_ext,
      output [2 : 0]   txmargin4_ext,
      output [2 : 0]   txmargin5_ext,
      output [2 : 0]   txmargin6_ext,
      output [2 : 0]   txmargin7_ext,
      output           txdeemph0_ext,
      output           txdeemph1_ext,
      output           txdeemph2_ext,
      output           txdeemph3_ext,
      output           txdeemph4_ext,
      output           txdeemph5_ext,
      output           txdeemph6_ext,
      output           txdeemph7_ext,
      output           txswing0_ext,
      output           txswing1_ext,
      output           txswing2_ext,
      output           txswing3_ext,
      output           txswing4_ext,
      output           txswing5_ext,
      output           txswing6_ext,
      output           txswing7_ext,
      output           txblkst0_ext,
      output           txblkst1_ext,
      output           txblkst2_ext,
      output           txblkst3_ext,
      output           txblkst4_ext,
      output           txblkst5_ext,
      output           txblkst6_ext,
      output           txblkst7_ext,
      output [1 : 0]   txsynchd0_ext,
      output [1 : 0]   txsynchd1_ext,
      output [1 : 0]   txsynchd2_ext,
      output [1 : 0]   txsynchd3_ext,
      output [1 : 0]   txsynchd4_ext,
      output [1 : 0]   txsynchd5_ext,
      output [1 : 0]   txsynchd6_ext,
      output [1 : 0]   txsynchd7_ext,
      output [17 : 0]  currentcoeff0_ext,
      output [17 : 0]  currentcoeff1_ext,
      output [17 : 0]  currentcoeff2_ext,
      output [17 : 0]  currentcoeff3_ext,
      output [17 : 0]  currentcoeff4_ext,
      output [17 : 0]  currentcoeff5_ext,
      output [17 : 0]  currentcoeff6_ext,
      output [17 : 0]  currentcoeff7_ext,
      output [2 : 0]   currentrxpreset0_ext,
      output [2 : 0]   currentrxpreset1_ext,
      output [2 : 0]   currentrxpreset2_ext,
      output [2 : 0]   currentrxpreset3_ext,
      output [2 : 0]   currentrxpreset4_ext,
      output [2 : 0]   currentrxpreset5_ext,
      output [2 : 0]   currentrxpreset6_ext,
      output [2 : 0]   currentrxpreset7_ext

      );

   reg [1:0] cnt_tx;
   wire txelecidle;

   assign txelecidle = txelecidle0&
                       txelecidle1&
                       txelecidle2&
                       txelecidle3&
                       txelecidle4&
                       txelecidle5&
                       txelecidle6&
                       txelecidle7;

   always @(posedge sim_pipe8_pclk or negedge aclr) begin
      if (aclr == 1'b0) begin
         cnt_tx <=2'h0;
      end
      else begin
         if (txelecidle==1'b0) begin
            cnt_tx <=cnt_tx+2'h1;
         end
         else begin
            cnt_tx <=2'h0;
         end
      end
   end

   assign txdata0_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata0[7:0]: (cnt_tx==2'b01)?txdata0[15:8] : (cnt_tx==2'b10)?txdata0[23:16] : txdata0[31:24];
   assign txdata1_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata1[7:0]: (cnt_tx==2'b01)?txdata1[15:8] : (cnt_tx==2'b10)?txdata1[23:16] : txdata1[31:24];
   assign txdata2_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata2[7:0]: (cnt_tx==2'b01)?txdata2[15:8] : (cnt_tx==2'b10)?txdata2[23:16] : txdata2[31:24];
   assign txdata3_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata3[7:0]: (cnt_tx==2'b01)?txdata3[15:8] : (cnt_tx==2'b10)?txdata3[23:16] : txdata3[31:24];
   assign txdata4_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata4[7:0]: (cnt_tx==2'b01)?txdata4[15:8] : (cnt_tx==2'b10)?txdata4[23:16] : txdata4[31:24];
   assign txdata5_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata5[7:0]: (cnt_tx==2'b01)?txdata5[15:8] : (cnt_tx==2'b10)?txdata5[23:16] : txdata5[31:24];
   assign txdata6_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata6[7:0]: (cnt_tx==2'b01)?txdata6[15:8] : (cnt_tx==2'b10)?txdata6[23:16] : txdata6[31:24];
   assign txdata7_ext                    = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdata7[7:0]: (cnt_tx==2'b01)?txdata7[15:8] : (cnt_tx==2'b10)?txdata7[23:16] : txdata7[31:24];
   assign txdatak0_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak0[ 0]: (cnt_tx==2'b01)?txdatak0[  1] : (cnt_tx==2'b10)?txdatak0[   2] : txdatak0[   3];
   assign txdatak1_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak1[ 0]: (cnt_tx==2'b01)?txdatak1[  1] : (cnt_tx==2'b10)?txdatak1[   2] : txdatak1[   3];
   assign txdatak2_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak2[ 0]: (cnt_tx==2'b01)?txdatak2[  1] : (cnt_tx==2'b10)?txdatak2[   2] : txdatak2[   3];
   assign txdatak3_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak3[ 0]: (cnt_tx==2'b01)?txdatak3[  1] : (cnt_tx==2'b10)?txdatak3[   2] : txdatak3[   3];
   assign txdatak4_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak4[ 0]: (cnt_tx==2'b01)?txdatak4[  1] : (cnt_tx==2'b10)?txdatak4[   2] : txdatak4[   3];
   assign txdatak5_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak5[ 0]: (cnt_tx==2'b01)?txdatak5[  1] : (cnt_tx==2'b10)?txdatak5[   2] : txdatak5[   3];
   assign txdatak6_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak6[ 0]: (cnt_tx==2'b01)?txdatak6[  1] : (cnt_tx==2'b10)?txdatak6[   2] : txdatak6[   3];
   assign txdatak7_ext                   = (pipe_mode_simu_only==1'b0)?0:(cnt_tx==2'b00)?txdatak7[ 0]: (cnt_tx==2'b01)?txdatak7[  1] : (cnt_tx==2'b10)?txdatak7[   2] : txdatak7[   3];

   assign eidleinfersel0_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel0                ;
   assign eidleinfersel1_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel1                ;
   assign eidleinfersel2_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel2                ;
   assign eidleinfersel3_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel3                ;
   assign eidleinfersel4_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel4                ;
   assign eidleinfersel5_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel5                ;
   assign eidleinfersel6_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel6                ;
   assign eidleinfersel7_ext             = (pipe_mode_simu_only==1'b0)?0:eidleinfersel7                ;
   assign powerdown0_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown0                    ;
   assign powerdown1_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown1                    ;
   assign powerdown2_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown2                    ;
   assign powerdown3_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown3                    ;
   assign powerdown4_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown4                    ;
   assign powerdown5_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown5                    ;
   assign powerdown6_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown6                    ;
   assign powerdown7_ext                 = (pipe_mode_simu_only==1'b0)?0:powerdown7                    ;
   assign rxpolarity0_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity0                   ;
   assign rxpolarity1_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity1                   ;
   assign rxpolarity2_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity2                   ;
   assign rxpolarity3_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity3                   ;
   assign rxpolarity4_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity4                   ;
   assign rxpolarity5_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity5                   ;
   assign rxpolarity6_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity6                   ;
   assign rxpolarity7_ext                = (pipe_mode_simu_only==1'b0)?0:rxpolarity7                   ;
   assign txcompl0_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl0                      ;
   assign txcompl1_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl1                      ;
   assign txcompl2_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl2                      ;
   assign txcompl3_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl3                      ;
   assign txcompl4_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl4                      ;
   assign txcompl5_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl5                      ;
   assign txcompl6_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl6                      ;
   assign txcompl7_ext                   = (pipe_mode_simu_only==1'b0)?0:txcompl7                      ;

   assign txdetectrx0_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx0                   ;
   assign txdetectrx1_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx1                   ;
   assign txdetectrx2_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx2                   ;
   assign txdetectrx3_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx3                   ;
   assign txdetectrx4_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx4                   ;
   assign txdetectrx5_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx5                   ;
   assign txdetectrx6_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx6                   ;
   assign txdetectrx7_ext                = (pipe_mode_simu_only==1'b0)?0:txdetectrx7                   ;
   assign txelecidle0_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle0                   ;
   assign txelecidle1_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle1                   ;
   assign txelecidle2_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle2                   ;
   assign txelecidle3_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle3                   ;
   assign txelecidle4_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle4                   ;
   assign txelecidle5_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle5                   ;
   assign txelecidle6_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle6                   ;
   assign txelecidle7_ext                = (pipe_mode_simu_only==1'b0)?0:txelecidle7                   ;
   assign txmargin0_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin0                     ;
   assign txmargin1_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin1                     ;
   assign txmargin2_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin2                     ;
   assign txmargin3_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin3                     ;
   assign txmargin4_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin4                     ;
   assign txmargin5_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin5                     ;
   assign txmargin6_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin6                     ;
   assign txmargin7_ext                  = (pipe_mode_simu_only==1'b0)?0:txmargin7                     ;
   assign txdeemph0_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph0                     ;
   assign txdeemph1_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph1                     ;
   assign txdeemph2_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph2                     ;
   assign txdeemph3_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph3                     ;
   assign txdeemph4_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph4                     ;
   assign txdeemph5_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph5                     ;
   assign txdeemph6_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph6                     ;
   assign txdeemph7_ext                  = (pipe_mode_simu_only==1'b0)?0:txdeemph7                     ;
   assign txswing0_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing0                      ;
   assign txswing1_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing1                      ;
   assign txswing2_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing2                      ;
   assign txswing3_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing3                      ;
   assign txswing4_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing4                      ;
   assign txswing5_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing5                      ;
   assign txswing6_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing6                      ;
   assign txswing7_ext                   = (pipe_mode_simu_only==1'b0)?0:txswing7                      ;
   assign txblkst0_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst0                      ;
   assign txblkst1_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst1                      ;
   assign txblkst2_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst2                      ;
   assign txblkst3_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst3                      ;
   assign txblkst4_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst4                      ;
   assign txblkst5_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst5                      ;
   assign txblkst6_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst6                      ;
   assign txblkst7_ext                   = (pipe_mode_simu_only==1'b0)?0:txblkst7                      ;
   assign txsynchd0_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd0                     ;
   assign txsynchd1_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd1                     ;
   assign txsynchd2_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd2                     ;
   assign txsynchd3_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd3                     ;
   assign txsynchd4_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd4                     ;
   assign txsynchd5_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd5                     ;
   assign txsynchd6_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd6                     ;
   assign txsynchd7_ext                  = (pipe_mode_simu_only==1'b0)?0:txsynchd7                     ;
   assign currentcoeff0_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff0                 ;
   assign currentcoeff1_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff1                 ;
   assign currentcoeff2_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff2                 ;
   assign currentcoeff3_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff3                 ;
   assign currentcoeff4_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff4                 ;
   assign currentcoeff5_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff5                 ;
   assign currentcoeff6_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff6                 ;
   assign currentcoeff7_ext              = (pipe_mode_simu_only==1'b0)?0:currentcoeff7                 ;
   assign currentrxpreset0_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset0              ;
   assign currentrxpreset1_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset1              ;
   assign currentrxpreset2_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset2              ;
   assign currentrxpreset3_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset3              ;
   assign currentrxpreset4_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset4              ;
   assign currentrxpreset5_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset5              ;
   assign currentrxpreset6_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset6              ;
   assign currentrxpreset7_ext           = (pipe_mode_simu_only==1'b0)?0:currentrxpreset7              ;

endmodule

// synthesis translate_on
// For Mentor cosim
`ifdef ALTPCIETB_COSIM_MENTOR

module global (in, out);
    input in;
    output out;

    assign out = in;
endmodule

`endif
