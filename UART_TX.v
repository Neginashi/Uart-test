`timescale 1ns / 1ps

module UART_TX (
	input  wire			CLK,
	input  wire			RST,
	input  wire			START,
	input  wire [7:0]	TX_IN,
	
	output reg			OUT,
	output reg			DONE,
	output reg			BUSY
	);

	reg [2:0]	STATE;
	reg [7:0]	DATA_TX;
	reg [2:0]	BIT_IDX;
	reg [8:0]	CLK_CNT;
	reg [9:0]	STOP_CNT;

	// STATEs of STATE machine
	reg [2:0]	IDLE 		= 3'b010;
	reg [2:0]	START_BIT 	= 3'b011;
	reg [2:0]	DATA_BITS 	= 3'b100;
	reg [2:0]	STOP_BIT 	= 3'b101;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			STATE 	<= IDLE;
			OUT 	<= 1'b1;
			DONE 	<= 1'b0;
			BUSY 	<= 1'b0;
			BIT_IDX <= 3'b0;
			DATA_TX <= 8'b0;
			CLK_CNT <= 9'b0;
			STOP_CNT<= 10'b0;
		end
		else begin
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
					CLK_CNT <= 9'b0;
					STOP_CNT<= 10'b0;
					if (START) begin
						DATA_TX <= TX_IN;
						STATE 	<= START_BIT;
						OUT 	<= 1'b1;
						DONE 	<= 1'b0;
						BUSY 	<= 1'b0;
						BIT_IDX <= 3'b0;
						CLK_CNT <= 9'b0;
						STOP_CNT<= 10'b0;
					end
				end

				START_BIT: begin
					OUT 	<= 1'b0;
					BUSY 	<= 1'b1;
					STATE 	<= DATA_BITS;
				end

				DATA_BITS: begin
					if (CLK_CNT == 9'b1_1011_0001) begin
						CLK_CNT <= 9'b0;
						OUT 	<= DATA_TX[BIT_IDX];
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
						DONE 	<= 1'b1;
						DATA_TX <= 8'b0;
						OUT 	<= 1'b1;
						if (STOP_CNT == 10'b11_0110_0010) begin
							CLK_CNT 	<= 9'b0;
							STOP_CNT 	<= 10'b0;
							STATE 		<= IDLE;
						end
						else begin
							STOP_CNT 	<= STOP_CNT + 10'b1;
						end
					end
					else begin
						CLK_CNT <= CLK_CNT + 9'b1;
					end
				end
			endcase
		end
	end

endmodule
