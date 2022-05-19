`timescale 1ns / 1ps

module UART_REG(
	input 				CLK,
	input 				STATE_R,
	input 				STATE_W,
	input		[7:0]	ADDR,
	input 	 	[31:0]	DATA_IN,
	input 				STATE_FAIL,

	output reg 	[31:0]	DATA_OUT,
	output reg			STATE_R_OUT,
	output reg 			FAIL_OUT,
	output reg 			OK
	);

	reg [7:0] 	REGISTER [31:0];

	initial begin
		STATE_R 	<= 1'b0;
		STATE_W 	<= 1'b0;
		ADDR 		<= 16'h0;
		DATA_IN 	<= 1'b0;
		STATE_FAIL 	<= 1'b0;
		FAIL_OUT	<= 1'b0;
		STATE_R_OUT <= 1'b0;
	end

	always @(posedge CLK) begin
		if (STATE_FAIL) begin
			FAIL_OUT 	<= 1'b1;
			OK 			<= 1'b0;
			STATE_R_OUT <= 1'b0;
		end
		else begin
			if (STATE_W) begin
				REGISTER[ADDR] 	<= DATA_IN;
				FAIL_OUT 		<= 1'b0;
				OK				<= 1'b1;
				STATE_R_OUT <= 1'b0;
			end
			else if (STATE_R) begin
				DATA_OUT 	<= REGISTER[ADDR];
				FAIL_OUT	<= 1'b0;
				OK			<= 1'b1;
				STATE_R_OUT <= 1'b1;
			end
		end
	end

endmodule
