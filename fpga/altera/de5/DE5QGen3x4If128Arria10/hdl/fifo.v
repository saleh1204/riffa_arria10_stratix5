`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KFUPM
// Engineer: Dr. M. Elrabaa
// 
// Create Date:    09:26:05 03/08/2019 
// Design Name: FIFO
// Module Name:    fifo 
// Project Name: 
// Description: 
// A simple FIFO ...
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Minimum pop/push logic will make this FIFO faster
//
//////////////////////////////////////////////////////////////////////////////////
module fifo1 #(parameter size=3 , width=8) (
    input clk,
    input reset,
    input push,
    input pop,
    input [width-1:0] Din,
    output reg [width-1:0] Dout,
    output reg full,
    output reg empty
    );
	 
	 reg [size-1:0] Radd, Wadd ;				// pop (read) and push (write) address pointers
	wire [size-1:0] nxt_Radd = Radd + 'd1 ;	// next state of the Read & Write address pointers
	wire [size-1:0] nxt_Wadd = Wadd + 'd1 ;	// since size is power of 2, the increment operation produces modulo count ...
	//(* lpm_ram_dq *)
	reg [width-1:0] mem [0:2**size-1] ;		// FIFO block RAM ... number of words restricted to powers of 2 ...
	
	
	always@ (posedge clk, posedge reset) begin
		if (reset) 	begin
			Radd <= 0;
			Wadd <= 0;
			full <= 0;
			empty <= 1 ;
			Dout <= 0;
		end
		else begin
			if (push && !full) 	begin	//pushing ... cannot do simultaneous popping and pushing if FIFO is full
				mem[Wadd] <= Din ;
				Wadd <= nxt_Wadd ;
				full <= (nxt_Wadd == Radd) && !pop;
				empty <= 0;	//after a push, the fifo cannot be empty
										end
										
			if (pop && !empty)	begin	//popping ... cannot do simultaneous popping and pushing if FIFO is empty
				Dout <= mem[Radd] ;
				Radd <= nxt_Radd ;
				empty <= (nxt_Radd == Wadd) && !push;
				full <= 0 ;	// after a pop, the fifo cannot be full
			end
		end
	end
endmodule
