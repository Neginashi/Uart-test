`timescale 1ns / 1ps

module UART_REG(
	input wire			CLK,
	input wire			RST,
	input wire			STATE_R,
	input wire			STATE_W,
	input wire 	[7:0]	ADDR,
	input wire 	[31:0]	DATA_IN,
	input wire			STATE_FAIL,
	input wire			START,

	output reg 	[31:0]	DATA_OUT,
	output reg			STATE_R_OUT,
	output reg 			FAIL_OUT,
	output reg 			OK,
	output reg 			DONE
	);

	reg [31:0] 	REGISTER [255:0];
	reg [7:0] 	ADDR_BUF;
	reg [31:0] 	DATA_BUF;
	reg [2:0] 	STATE;

	parameter IDLE 	= 3'b001;
	parameter WRITE = 3'b010;
	parameter READ 	= 3'b011;
	parameter FAIL 	= 3'b100;
	parameter STOP 	= 3'b101;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			STATE 		<= IDLE;
			DATA_OUT 	<= 1'b0;
			OK 			<= 1'b0;
			FAIL_OUT	<= 1'b0;
			STATE_R_OUT <= 1'b0;
			DONE 		<= 1'b0;
			ADDR_BUF 	<= 8'b0;
		end
		else begin
			case (STATE)
				IDLE: begin
					if (START) begin
						ADDR_BUF <= ADDR;
						DATA_BUF <= DATA_IN;
						if (STATE_FAIL) begin
							STATE <= FAIL;
						end
						else if (STATE_R) begin
							STATE <= READ;
						end
						else if (STATE_W) begin
							STATE <= WRITE;
						end
						else begin
							STATE <= IDLE;
						end
					end
					else begin
						DATA_OUT 	<= 1'b0;
						OK 			<= 1'b0;
						FAIL_OUT	<= 1'b0;
						STATE_R_OUT <= 1'b0;
						DONE 		<= 1'b0;
						ADDR_BUF 	<= 8'b0;
					end
				end

				READ: begin
					DATA_OUT 	<= REGISTER[ADDR_BUF];
					FAIL_OUT	<= 1'b0;
					OK			<= 1'b0;
					STATE_R_OUT <= 1'b1;
					DONE 		<= 1'b1;
					STATE 		<= STOP;
				end

				WRITE: begin
					REGISTER[ADDR_BUF] 	<= DATA_BUF;
					FAIL_OUT 		<= 1'b0;
					OK				<= 1'b1;
					STATE_R_OUT 	<= 1'b0;
					DONE 			<= 1'b1;
					STATE 			<= STOP;
				end

				FAIL: begin
					FAIL_OUT 	<= 1'b1;
					OK 			<= 1'b0;
					STATE_R_OUT <= 1'b0;
					DONE 		<= 1'b1;
					STATE 		<= STOP;
				end

				STOP: begin
					DATA_OUT 	<= 1'b0;
					OK 			<= 1'b0;
					FAIL_OUT	<= 1'b0;
					STATE_R_OUT <= 1'b0;
					ADDR_BUF 	<= 8'b0;
					DONE 		<= 1'b0;
					STATE 		<= IDLE;
				end

				default: begin
					STATE 		<= IDLE;
					FAIL_OUT 	<= 1'b0;
					OK			<= 1'b0;
					DONE 		<= 1'b0;
					STATE_R_OUT <= 1'b0;
				end
			endcase
		end
	end

endmodule
