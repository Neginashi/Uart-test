`timescale 1ns / 1ps

module UART_ENC(
	input wire			CLK,
	input wire			DATA_EN,
	input wire [79:0]	DATA_IN,
	input wire			FAIL,
	input wire			OK,
	input wire			STATE_R,

	output  reg         CLK,
    output  reg         TX_EN,
    output  reg         START,
    output  reg [7:0]   DATA_OUT

	);

	reg [2:0] 	STATE = {STATE_R, OK, FAIL};
	reg [3:0] 	CNT_R;
	reg [1:0] 	CNT_OK;
	reg [2:0] 	CNT_FAIL;
	reg 		DONE;
	
	initial begin
		DATA_IN 	<= 80'b0;
		DATA_OUT 	<= 8'b0;
		FAIL		<= 1'b0;
		OK 			<= 1'b0;
		STATE_R 	<= 1'b0;
		STATE 		<= 3'b0;
	end

	always @(posedge CLK) begin
		if (!DATA_EN) begin
			DATA_IN 	<= 80'b0;
			DATA_OUT 	<= 8'b0;
			FAIL		<= 1'b0;
			OK 			<= 1'b0;
			STATE_R 	<= 1'b0;
		end
		else begin
			case (STATE)
				3'b100: begin
					if (CNT_R <= 4'b1001) begin
						DATA_OUT 	<= DATA_IN[79:72];
						DATA_IN 	<= DATA_IN << 8;
						CNT_R 		<= 4'b1;
						if (CNT_R == 4'b1001) begin
							CNT_R 	<= 4'b0;
							DONE 	<= 2'b1;
						end
					end
				end
				3'b010: begin

				end
				3'b001: begin

				end