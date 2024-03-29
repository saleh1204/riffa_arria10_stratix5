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


// Cascaded 32 Deep paramerizable single clock FIFOs
// Width parameterizable FIFO
// optimized for SV
// Depth 32 words blocks
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module altpcie_scfifo #(
      parameter WIDTH          = 20, // typical 20,40,60,80
      parameter NUM_FIFO32     = 1   // Number of 32 DEEP FIFO; Valid Range 1,2,3,4
                                     // When 0 only 16 deep
      )(
      input                    clk     ,  // input
      input                    sclr    ,  // input
      input [WIDTH-1:0]        wdata   ,  // input [WIDTH-1:0]
      input                    wreq    ,  // input
      output                   full    ,  // output
      output [WIDTH-1:0]       rdata   ,  // output [WIDTH-1:0]
      input                    rreq    ,  // input
      output                   empty   ,  // output
      output [4:0]             used       // output [4:0]
);

localparam ZEROS                   = 512'h0;
localparam TARGET_CHIP             = 2;                               // 1 S4, 2 S5,
localparam SIM_EMULATE             = 1'b0;                            // simulation equivalent, only for S5 right now
localparam PREVENT_OVERFLOW        = 1'b1;                            // ignore requests that would cause overflow
localparam PREVENT_UNDERFLOW       = 1'b1;                            // ignore requests that would cause underflow
localparam RAM_GROUPS              = (WIDTH < 20) ? 1 : (WIDTH / 20); // min 1, WIDTH must be divisible by RAM_GROUPS
localparam GROUP_RADDR             = (WIDTH < 20) ? 1'b0 : 1'b1;      // 1 to duplicate RADDR per group as well as WADDR
localparam FLAG_DUPES              = 1;                               // if > 1 replicate full / empty flags for fanout balancing
localparam ADDR_WIDTH              = (NUM_FIFO32==0)?4:5;                               // 4 or 5
localparam DISABLE_USED            = 1'b0;

wire [WIDTH-1:0]       wdata0   ;  // input [WIDTH-1:0]
wire                   wreq0    ;  // input
wire                   full0    ;  // output
wire [WIDTH-1:0]       rdata0   ;  // output [WIDTH-1:0]
wire                   rreq0    ;  // input
wire                   empty0   ;  // output
wire [4:0]             used0    ;  // output [4:0]

altpcie_sv_gbfifo #(
        .TARGET_CHIP           (TARGET_CHIP         ),
        .SIM_EMULATE           (SIM_EMULATE         ),
        .WIDTH                 (WIDTH               ),
        .PREVENT_OVERFLOW      (PREVENT_OVERFLOW    ),
        .PREVENT_UNDERFLOW     (PREVENT_UNDERFLOW   ),
        .RAM_GROUPS            (RAM_GROUPS          ),
        .GROUP_RADDR           (GROUP_RADDR         ),
        .FLAG_DUPES            (FLAG_DUPES          ),
        .ADDR_WIDTH            (ADDR_WIDTH          ),
        .DISABLE_USED          (DISABLE_USED        )
      ) gb0fifo (
        .clk                   (clk                 ),   // input
        .sclr                  (sclr                ),   // input
        .wdata                 (wdata0              ),   // input [WIDTH-1:0]
        .wreq                  (wreq0 & !full0      ),   // input
        .full                  (full0               ),   // output [FLAG_DUPES-1:0]
        .rdata                 (rdata0              ),   // output [WIDTH-1:0]
        .rreq                  (rreq0               ),   // input
        .empty                 (empty0              ),   // output [FLAG_DUPES-1:0]
        .used                  (used0[ADDR_WIDTH-1:0])   // output [ADDR_WIDTH-1:0]
      );

assign wdata0 = wdata;
assign full = full0;
assign wreq0  = wreq;
 
generate begin : g_scfifo
   if (NUM_FIFO32>1) begin

      wire [WIDTH-1:0]       wdata1   ;
      wire                   wreq1    ;
      wire                   full1    ;
      wire [WIDTH-1:0]       rdata1   ;
      wire                   rreq1    ;
      wire                   empty1   ;
      wire [4:0]             used1    ;
      reg                    wreq1_d  ;
      reg                    full1_d  ;
      reg                    rreq0_d  ;
      reg                    rreq0_l  ;

      altpcie_sv_gbfifo #(
              .TARGET_CHIP           (TARGET_CHIP         ),
              .SIM_EMULATE           (SIM_EMULATE         ),
              .WIDTH                 (WIDTH               ),
              .PREVENT_OVERFLOW      (PREVENT_OVERFLOW    ),
              .PREVENT_UNDERFLOW     (PREVENT_UNDERFLOW   ),
              .RAM_GROUPS            (RAM_GROUPS          ),
              .GROUP_RADDR           (GROUP_RADDR         ),
              .FLAG_DUPES            (FLAG_DUPES          ),
              .ADDR_WIDTH            (ADDR_WIDTH          ),
              .DISABLE_USED          (DISABLE_USED        )
            ) gb1fifo (
              .clk                   (clk                 ),
              .sclr                  (sclr                ),
              .wdata                 (wdata1              ),
              .wreq                  (wreq1 & !full1      ),
              .full                  (full1               ),
              .rdata                 (rdata1              ),
              .rreq                  (rreq1               ),
              .empty                 (empty1              ),
              .used                  (used1               )
            );
      assign wdata1 = rdata0;
      assign rreq0  = ((empty0==1'b0)&&(full1==1'b0))?1'b1:1'b0;
      assign wreq1  = wreq1_d || ((rreq0_l == 1'b1) && (full1 == 1'b0));	
      always @(posedge clk) begin : p_wreq1
      if (sclr == 1'b1 ) begin
            wreq1_d <= 1'b0;
            full1_d <= 1'b0;
            rreq0_d <= 1'b0;
         end
         else begin
            wreq1_d  <= ((empty0==1'b0)&&(full1==1'b0))?1'b1:1'b0;
            full1_d <= full1;
            rreq0_d <= rreq0;
         end
      end
      always @(posedge clk) begin : p_rreq0_l
         if (sclr == 1'b1 ) begin
            rreq0_l <= 1'b0;
         end
         else begin
            if (full1 == 1'b0)
               rreq0_l <= 1'b0;
            else if ((full1 == 1'b1) && (rreq0_d == 1'b1))
               rreq0_l <= 1'b1;
        end
      end
      if (NUM_FIFO32>2) begin
         wire [WIDTH-1:0]       wdata2   ;
         wire                   wreq2    ;
         wire                   full2    ;
         wire [WIDTH-1:0]       rdata2   ;
         wire                   rreq2    ;
         wire                   empty2   ;
         wire [4:0]             used2    ;
         reg                    wreq2_d  ;
         reg                    full2_d  ;
         reg                    rreq1_d  ;
         reg                    rreq1_l  ;
         altpcie_sv_gbfifo #(
                 .TARGET_CHIP           (TARGET_CHIP         ),
                 .SIM_EMULATE           (SIM_EMULATE         ),
                 .WIDTH                 (WIDTH               ),
                 .PREVENT_OVERFLOW      (PREVENT_OVERFLOW    ),
                 .PREVENT_UNDERFLOW     (PREVENT_UNDERFLOW   ),
                 .RAM_GROUPS            (RAM_GROUPS          ),
                 .GROUP_RADDR           (GROUP_RADDR         ),
                 .FLAG_DUPES            (FLAG_DUPES          ),
                 .ADDR_WIDTH            (ADDR_WIDTH          ),
                 .DISABLE_USED          (DISABLE_USED        )
               ) gb2fifo (
                 .clk                   (clk                 ),
                 .sclr                  (sclr                ),
                 .wdata                 (wdata2              ),
                 .wreq                  (wreq2 & !full2      ),
                 .full                  (full2               ),
                 .rdata                 (rdata2              ),
                 .rreq                  (rreq2               ),
                 .empty                 (empty2              ),
                 .used                  (used2               )
               );
         assign wdata2 = rdata1;
         assign rreq1  = ((empty1==1'b0)&&(full2==1'b0))?1'b1:1'b0;
         assign wreq2  = wreq2_d || ((rreq1_l == 1'b1) && (full2 == 1'b0));	
         always @(posedge clk) begin : p_wreq2
            if (sclr == 1'b1 ) begin
               wreq2_d <= 1'b0;
               full2_d <= 1'b0;
               rreq1_d <= 1'b0;
            end
            else begin
               wreq2_d  <= ((empty1==1'b0)&&(full2==1'b0))?1'b1:1'b0;
               full2_d <= full2;
               rreq1_d <= rreq1;
            end
         end
         always @(posedge clk) begin : p_rreq1_latch
            if (sclr == 1'b1 ) begin
               rreq1_l <= 1'b0;
            end
            else begin
               if (full2 == 1'b0)
                  rreq1_l <= 1'b0;
               else if ((full2 == 1'b1) && (rreq1_d == 1'b1))
                  rreq1_l <= 1'b1;
           end
         end
         if (NUM_FIFO32>3) begin
            wire [WIDTH-1:0]       wdata3   ;
            wire                   wreq3    ;
            wire                   full3    ;
            wire [WIDTH-1:0]       rdata3   ;
            wire                   rreq3    ;
            wire                   empty3   ;
            wire [4:0]             used3    ;
            reg                    wreq3_d  ;
            reg                    full3_d  ;
            reg                    rreq2_d  ;
            reg                    rreq2_l  ;
            altpcie_sv_gbfifo #(
                    .TARGET_CHIP           (TARGET_CHIP         ),
                    .SIM_EMULATE           (SIM_EMULATE         ),
                    .WIDTH                 (WIDTH               ),
                    .PREVENT_OVERFLOW      (PREVENT_OVERFLOW    ),
                    .PREVENT_UNDERFLOW     (PREVENT_UNDERFLOW   ),
                    .RAM_GROUPS            (RAM_GROUPS          ),
                    .GROUP_RADDR           (GROUP_RADDR         ),
                    .FLAG_DUPES            (FLAG_DUPES          ),
                    .ADDR_WIDTH            (ADDR_WIDTH          ),
                    .DISABLE_USED          (DISABLE_USED        )
                  ) gb3fifo (
                    .clk                   (clk                 ),
                    .sclr                  (sclr                ),
                    .wdata                 (wdata3              ),
                    .wreq                  (wreq3 & !full3      ),
                    .full                  (full3               ),
                    .rdata                 (rdata3              ),
                    .rreq                  (rreq3               ),
                    .empty                 (empty3              ),
                    .used                  (used3               )
                  );
            assign wdata3 = rdata2;
            assign rreq2  = ((empty2==1'b0)&&(full3==1'b0))?1'b1:1'b0;
            assign wreq3  = wreq3_d || ((rreq2_l == 1'b1) && (full3 == 1'b0));	
            always @(posedge clk) begin : p_wreq3
               if (sclr == 1'b1 ) begin
                  wreq3_d <= 1'b0;
                  full3_d <= 1'b0;
                  rreq2_d <= 1'b0;
               end
               else begin
                  wreq3_d  <= ((empty2==1'b0)&&(full3==1'b0))?1'b1:1'b0;
                  full3_d <= full3;
                  rreq2_d <= rreq2;
               end
            end
            always @(posedge clk) begin : p_rreq2_latch
               if (sclr == 1'b1 ) begin
                  rreq2_l <= 1'b0;
               end
               else begin
                  if (full3 == 1'b0)
                     rreq2_l <= 1'b0;
                  else if ((full3 == 1'b1) && (rreq2_d == 1'b1))
                     rreq2_l <= 1'b1;
              end
            end
            assign empty  = empty3               ;
            //assign full   = full2 & full1 & full0 & full3;
            assign rdata  = rdata3               ;
            assign used   = used3                ;
            assign rreq3  = rreq                 ;
         end
         else begin
            assign empty  = empty2           ;
            //assign full   = full2 & full1 & full0 ;
            assign rdata  = rdata2           ;
            assign used   = used2            ;
            assign rreq2  = rreq             ;
         end
      end
      else begin
         assign empty  = empty1         ;
         //assign full   = full1 & full0  ;
         assign rdata  = rdata1         ;
         assign used   = used1          ;
         assign rreq1  = rreq           ;
      end
   end
   else begin
      assign rreq0  = rreq           ;
      assign empty  = empty0         ;
      //assign full   = full0          ;
      assign rdata  = rdata0         ;
      assign used   = (NUM_FIFO32==0)?{1'b0,used0[3:0]}:used0[4:0]          ;
   end
end
endgenerate


endmodule
