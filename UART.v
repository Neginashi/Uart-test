module UART(
	CLK,
	RST
		
	);

input	CLK;
input	RST;

input	reg	[119:0]		PC_DATA;
input	reg	[63:0]		R_DATA;
	
output	reg	[63:0]		DSP_DATA;
output	reg	[39:0]		DSP;

wire	[103:0]	BEFORE_ENTER;
wire	[15:0]	ENTER;
wire	[23:0]	W_ACTION;
wire	[87:0]	BEFORE_R_ADDR;
wire	[23:0]	R_ACTION;
wire	[31:0]	W_ADDR;
wire	[63:0]	W_DATA;
wire	[7:0]	W_SPACE;
wire	[31:0]	R_ADDR;

assign W_ACTION        = PC_DATA [119:104];
assign BEFORE_R_ADDR   = PC_DATA [119:32];
assign R_ACTION        = PC_DATA [47:32];
assign W_ADDR          = PC_DATA [103:88];
assign R_ADDR          = PC_DATA [31:16];
assign W_DATA          = PC_DATA [79:16];
assign ENTER 	       = PC_DATA [15:0];
assign W_SPACE	       = PC_DATA [87:80];
assign DSP_DATA        = R_DATA;

parameter [31:0] FAIL = 40'h46_4149_4C3E
parameter [31:0] OK   = 40'h00_004F_4B3E

always @(posedge CLK or posedge RST) begin
	if (!RST) begin
		// reset
		PC_DATA <= 0;
		R_DATA	<= 0;
	end
	else if (BEFORE_ENTER = 0) begin
		DSP <= 40'h00_0000_003E;
	end
	else if (BEFORE_R_ADDR = 88'h00_0000_0000_0000_0000_525F) begin
		if (R_ADDR <= 16'h3038 && R_ADDR >= 16'h3030) begin
			EN_READ <= 1;
		end
		else begin
			DSP <= FAIL;
		end
	end

	end
end


endmodule
