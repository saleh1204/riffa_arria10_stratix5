// Filename:			fifo_packer_256.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Packs 32, 64, or 96 bit received data into a 256 bit wide  
// FIFO. Assumes the FIFO always has room to accommodate the data.
// Author:				Saleh AlSaleh
// History:				@mattj: Version 2.0
// Additional Comments: 
//-----------------------------------------------------------------------------

`timescale 1ns/1ns
module fifo_packer_256 (
	input CLK,
	input RST,
	input [255:0] DATA_IN,		// Incoming data
	input [3:0] DATA_IN_EN,		// Incoming data enable
	input DATA_IN_DONE,			// Incoming data packet end
	input DATA_IN_ERR,			// Incoming data error
	input DATA_IN_FLUSH,		// End of incoming data
	output [255:0] PACKED_DATA,	// Outgoing data
	output PACKED_WEN,			// Outgoing data write enable
	output PACKED_DATA_DONE,	// End of outgoing data packet
	output PACKED_DATA_ERR,		// Error in outgoing data
	output PACKED_DATA_FLUSHED	// End of outgoing data
);

reg		[3:0]		rPackedCount=0, _rPackedCount=0;
reg					rPackedDone=0, _rPackedDone=0;
reg					rPackedErr=0, _rPackedErr=0;
reg					rPackedFlush=0, _rPackedFlush=0;
reg					rPackedFlushed=0, _rPackedFlushed=0;
reg		[223:0]		rPackedData=224'd0, _rPackedData=224'd0;
reg		[255:0]		rDataIn=256'd0, _rDataIn=256'd0;
reg		[3:0]		rDataInEn=0, _rDataInEn=0;
reg		[255:0]		rDataMasked=256'd0, _rDataMasked=256'd0;
reg		[3:0]		rDataMaskedEn=0, _rDataMaskedEn=0;


assign PACKED_DATA = rPackedData[127:0];
assign PACKED_WEN = rPackedCount[3];
assign PACKED_DATA_DONE = rPackedDone;
assign PACKED_DATA_ERR = rPackedErr;
assign PACKED_DATA_FLUSHED = rPackedFlushed;


// Buffers input data until 8 words are available, then writes 8 words out.
wire [255:0] wMask = {256{1'b1}}<<(32*rDataInEn);
wire [255:0] wDataMasked = ~wMask & rDataIn;
always @ (posedge CLK) begin
	rPackedCount <= #1 (RST ? 4'd0 : _rPackedCount);
	rPackedDone <= #1 (RST ? 1'd0 : _rPackedDone);
	rPackedErr <= #1 (RST ? 1'd0 : _rPackedErr);
	rPackedFlush <= #1 (RST ? 1'd0 : _rPackedFlush);
	rPackedFlushed <= #1 (RST ? 1'd0 : _rPackedFlushed);
	rPackedData <= #1 (RST ? 224'd0 : _rPackedData);
	rDataIn <= #1 _rDataIn;
	rDataInEn <= #1 (RST ? 4'd0 : _rDataInEn);
	rDataMasked <= #1 _rDataMasked;
	rDataMaskedEn <= #1 (RST ? 4'd0 : _rDataMaskedEn);
end

always @ (*) begin
	// Buffer and mask the input data.
	_rDataIn = DATA_IN;
	_rDataInEn = DATA_IN_EN;
	_rDataMasked = wDataMasked;
	_rDataMaskedEn = rDataInEn;

	// Count what's in our buffer. When we reach 8 words,8 words will be written
	// out. If flush is requested, write out whatever remains.
	if (rPackedFlush && (rPackedCount[1] | rPackedCount[0]))
		_rPackedCount = 8;
	else
		_rPackedCount = rPackedCount + rDataMaskedEn - {rPackedCount[3], 3'd0};
	
	// Shift data into and out of our buffer as we receive and write out data.
	if (rDataMaskedEn != 4'd0)
		_rPackedData = ((rPackedData>>(32*{rPackedCount[3], 2'd0})) | (rDataMasked<<(32*rPackedCount[2:0])));
	else
		_rPackedData = (rPackedData>>(32*{rPackedCount[3], 2'd0}));

	// Track done/error/flush signals.
	_rPackedDone = DATA_IN_DONE;
	_rPackedErr = DATA_IN_ERR;
	_rPackedFlush = DATA_IN_FLUSH;
	_rPackedFlushed = rPackedFlush;
end



endmodule
