`timescale 1ns / 1ps

module UART_TX (
	input  wire			CLK,
	input  wire			TX_EN,
	input  wire			START,
	input  wire [7:0]	TX_IN,
	
	output reg			OUT,
	output reg			DONE,
	output reg			BUSY
	);

	reg [2:0]	STATE   = 3'b010;
	reg [7:0]	DATA_TX = 8'b0;
	reg [2:0]	BIT_IDX = 3'b0;
	reg [8:0]	CLK_CNT = 9'b0;

	// STATEs of STATE machine
	parameter	IDLE 		= 3'b010;
	parameter	START_BIT 	= 3'b011;
	parameter	DATA_BITS 	= 3'b100;
	parameter	STOP_BIT 	= 3'b101;

	assign IDX = BIT_IDX;

	always @(posedge CLK) begin
		case (STATE)
			default: begin
				STATE 	<= IDLE;
			end

			IDLE: begin
				OUT 	<= 1'b1;
				DONE 	<= 1'b0;
				BUSY 	<= 1'b0;
				BIT_IDX <= 3'b0;
				DATA_TX <= 8'b0;
				if (START & TX_EN) begin
					DATA_TX <= TX_IN;
					STATE 	<= START_BIT;
				end
			end

			START_BIT: begin
				if (CLK_CNT == 9'b1_1011_0001) begin
					CLK_CNT <= 9'b0;
					OUT 	<= 1'b0;
					BUSY 	<= 1'b1;
					STATE 	<= DATA_BITS;
				end
				else begin
					CLK_CNT <= CLK_CNT + 9'b1;
				end
			end

			DATA_BITS: begin
				if (CLK_CNT == 9'b1_1011_0001) begin
					CLK_CNT <= 9'b0;
					OUT <= DATA_TX[3'b111 - BIT_IDX];
					if (&BIT_IDX) begin
						BIT_IDX <= 3'b0;
						STATE 	<= STOP_BIT;
					end
					else begin
						BIT_IDX <= BIT_IDX + 1'b1;
					end
				end
				else begin
					CLK_CNT <= CLK_CNT + 9'b1;
				end
			end

			STOP_BIT: begin
				if (CLK_CNT == 9'b1_1011_0001) begin
					CLK_CNT <= 9'b0;
					DONE 	<= 1'b1;
					DATA_TX <= 8'b0;
					STATE 	<= IDLE;
				end
				else begin
					CLK_CNT <= CLK_CNT + 9'b1;
				end
			end
		endcase
	end

endmodule
