module Uart(
	clk,
	rst_n,
		
	);

input	clk;
input	rst_n;

input	reg	[119:0]		pc_data;
input	reg	[63:0]		r_data;


output	reg	[63:0]		dsp_data;
output	reg	[31:0]		dsp;

reg []
reg	[15:0]	w_action;
reg	[15:0]	r_action;
reg	[31:0]	w_addr;
reg	[31:0]	r_addr;

wire	[63:0]	w_data;

w_action = pc_data [119:112];
r_action = pc_data [47:40]
w_addr = pc_data [103:88];
r_addr = pc_data [31:16];

dsp_data = r_data;

assign w_data = pc_data [79:16];

always @(posedge clk or posedge rst_n) begin
	if (!rst_n) begin
		// reset
		pc_data <= 0;
		r_data	<= 0;
	end
	else if (rst_n) begin
		
	end
end