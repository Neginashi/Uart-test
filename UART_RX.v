`timescale 1ns / 1ps

module UART_RX(
	input	wire		CLK,	
	input	wire		RX_EN,
	input	wire		RX_IN,

	output	reg	[7:0]	RX_OUT,
	output	reg			DONE,
	output	reg			BUSY,
	output	reg			ERR
	);

	parameter CLK_F 	= 50000000;
	parameter UART_B 	= 115200;
	parameter B_CNT 	= CLK_F / UART_B;

	// STATEs of STATE machine
	reg [1:0]	RESET		= 2'b00;
	reg [1:0]	IDLE		= 2'b01;
	reg [1:0]	DATA_BITS	= 2'b10;
	reg [1:0]	STOP_BIT	= 2'b11;

	reg [2:0]	STATE;
	reg [2:0]	BIT_IDX		= 3'b0;
	reg [1:0]	INPUT_SW	= 2'b0;
	reg [3:0]	CLK_COUNT	= 9'b0;
	reg [7:0]	DATA_RX		= 8'b0;

	initial begin
		RX_OUT	<= 8'b0;
		ERR		<= 1'b0;
		DONE	<= 1'b0;
		BUSY	<= 1'b0;
	end

	always @(posedge CLK) begin
		INPUT_SW = { INPUT_SW[0], RX_IN };
		if (!RX_EN) begin
			STATE <= RESET;
		end

		case (STATE)
			RESET: begin
				RX_OUT		<= 8'b0;
				ERR			<= 1'b0;
				DONE		<= 1'b0;
				BUSY		<= 1'b0;
				BIT_IDX		<= 3'b0;
				CLK_COUNT	<= 9'b0;
				DATA_RX		<= 8'b0;
				if (RX_EN) begin
					STATE	<= IDLE;
				end
			end

			IDLE: begin
				DONE <= 1'b0;
				if (CLK_COUNT == B_CNT - 1) begin
					STATE		<= DATA_BITS;
					RX_OUT			<= 8'b0;
					BIT_IDX		<= 3'b0;
					CLK_COUNT	<= 9'b0;
					DATA_RX		<= 8'b0;
					BUSY		<= 1'b1;
					ERR			<= 1'b0;
				end
				else if (&INPUT_SW) begin
					ERR		<= 1'b1;
					STATE	<= RESET;
				end
				CLK_COUNT	<= CLK_COUNT + 1;
			end

			DATA_BITS: begin
				if (CLK_COUNT == B_CNT - 1) begin
					CLK_COUNT <= 9'b0;
				end
				else begin
					if (BIT_IDX <= 3'b111) begin
						DATA_RX[BIT_IDX]	<= INPUT_SW[0];
						BIT_IDX				<= BIT_IDX + 3'b1;
					end
					else if (&BIT_IDX) begin
						BIT_IDX		<= 3'b0;
						STATE		<= STOP_BIT;
					end
					CLK_COUNT	<= CLK_COUNT + 9'b1;
				end
			end

			STOP_BIT: begin
				if (CLK_COUNT <= B_CNT - 1) begin
					STATE		<= IDLE;
					DONE		<= 1'b1;
					BUSY		<= 1'b0;
					RX_OUT		<= DATA_RX;
					CLK_COUNT	<= 9'b0;
				end
				else begin
					CLK_COUNT	<= CLK_COUNT + 9'b1;
				end
			end

			default: STATE <= IDLE;
		endcase
	end

endmodule