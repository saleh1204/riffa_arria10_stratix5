// This is a general channel with Receive FIFO and send FIFO; each with its own controller FSM
//
`timescale 1ns/1ns
module rx_do_nothing_tx_channel #(parameter C_PCI_DATA_WIDTH = 9'd128)  
(
	input CLK,
	input RST,
	output CHNL_RX_CLK, 
	input CHNL_RX, 
	output CHNL_RX_ACK, 
	input CHNL_RX_LAST, 
	input [31:0] CHNL_RX_LEN, 
	input [30:0] CHNL_RX_OFF, 
	input [C_PCI_DATA_WIDTH-1:0] CHNL_RX_DATA, 
	input CHNL_RX_DATA_VALID, 
	output CHNL_RX_DATA_REN,
	
	output CHNL_TX_CLK, 
	output CHNL_TX, 
	input CHNL_TX_ACK, 
	output CHNL_TX_LAST, 
	output [31:0] CHNL_TX_LEN, 
	output [30:0] CHNL_TX_OFF, 
	output [C_PCI_DATA_WIDTH-1:0] CHNL_TX_DATA, 
	output CHNL_TX_DATA_VALID, 
	input CHNL_TX_DATA_REN
);

	reg [31:0] rLen = 0; // register to hold the number of words received from the host side
	reg [31:0] rCount = 0, sCount = 0;// two counters for each part

	reg [1:0] sState = 0;	//Tx controller state machine
	reg rState = 0; // Rx controller state machine
	
	wire [C_PCI_DATA_WIDTH-1:0] rDout; // poped flit from rFiFO
	wire [C_PCI_DATA_WIDTH-1:0] sDin; // element to be pushed in tFIFO
	wire rFull,rEmpty,sFull,sEmpty; // signals to indicate the state of the rFIFO and tFIFO
	reg push_s = 0; // the sFIFO push is simply the registered rFIFO pop 
	wire push_r, pop_r, pop_s; // signals to control filling and poping the rFIFO and tFIFO
	reg pop_r_delayed = 0; // registered pop_r signal to be used for push_s
								  // when pop_r is 1, the rFIFO will pop a valid flit in the next cycle

	assign CHNL_RX_CLK = CLK;
	assign CHNL_RX_ACK = push_r;
	assign CHNL_RX_DATA_REN = push_r; //do not consume the data if rFIFO is full

	assign push_r = (rState==1'd1) && CHNL_RX_DATA_VALID && !rFull; 
	assign pop_r = !sFull && !rEmpty ; //pop rFIFO whenever it is not empty and the sFIFO is not full
	assign sDin = rDout;
	

	assign CHNL_TX_CLK = CLK;
	assign CHNL_TX = (sState != 2'd0); // maintain CHNL_TX high during sending ...
	assign CHNL_TX_LAST = 1'd1;
	assign CHNL_TX_LEN = rLen ;//SLen in words 
	assign CHNL_TX_OFF = 0;

	assign pop_s = (sState==2'd2) && !sEmpty ; //pop SFIFO 1st time when CHNL_TX_ACK is pulsed pr when Sdata is consumed
	assign CHNL_TX_DATA_VALID = (sState == 2'd3); 
	

	fifo1 #(10,C_PCI_DATA_WIDTH) fifo_in  (CLK,RST,push_r,pop_r,CHNL_RX_DATA,rDout,rFull,rEmpty);  //Rx FIFO

	fifo1 #(10,C_PCI_DATA_WIDTH) fifo_out (CLK,RST,push_s,pop_s,sDin,CHNL_TX_DATA,sFull,sEmpty);  //Tx FIFO, input is the result ...

	always @(posedge CLK or posedge RST) begin		
		if (RST) begin 
			rLen <=  0; 
			rCount <=  0;
			sCount <=  0; 
			rState <=  0; 
			sState <=  0; 
			push_s <=  0; 
		end
		else begin 		
			case (rState)	//Rx controller
				1'd0: 
					begin // Wait for start of RX, save length
						if (CHNL_RX && sEmpty) begin 
							rLen <=  CHNL_RX_LEN; 
							rCount <=  0; 
							rState <=  1'd1; 
						end
					end
				1'd1: 
					begin // receive data ...
						if (CHNL_RX_DATA_VALID && !rFull) begin
							rCount <=  rCount + (C_PCI_DATA_WIDTH/32);
						end
						if (rCount >= rLen) begin
							rState <=  1'd0;
						end
					end
			endcase	
			case (sState)	// Tx controller
			2'd0: 
				if (!sEmpty) begin // Wait for sFIFO data 
					sCount <=  0; 	
					sState <=  2'd1; 
				end		
			2'd1: 
				if (CHNL_TX_ACK) begin
					sState <=  2'd2; // Wait for Tx interface acknowledgment
				end
			2'd2: 
				begin	
					if (!sEmpty) begin 
						sCount <=  sCount + (C_PCI_DATA_WIDTH/32);
						sState <= 2'd3;
					end 
					if (sCount >= rLen) begin
						sState <=  2'd0;
					end					
				end
			
			2'd3: 
				if (CHNL_TX_DATA_REN) begin
					sState <=  2'd2; // Wait for Tx data acknowledgment
				end
								
			endcase
			push_s <=  pop_r;// the sFIFO push is simply the registered rFIFO pop.
		end
	end

endmodule
