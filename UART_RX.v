`timescale 1ns / 1ps

module UART_RX(
	input	wire		CLK,	
	input	wire		RX_EN,
	input	wire		RX_IN,

	output	reg	[7:0]	RX_OUT,
	output	reg			DONE,
	output	reg			BUSY
	//output	reg			ERR
	);

	parameter CLK_F 	= 50000000;
	parameter UART_B 	= 115200;
	parameter B_CNT 	= CLK_F / UART_B; //433

	// STATEs of STATE machine
	parameter	RESET		= 2'b00;
	parameter	IDLE		= 2'b01;
	parameter	DATA_BITS	= 2'b10;
	parameter	STOP_BIT	= 2'b11;

	reg [1:0]	STATE		= 2'b0;
	reg [3:0]	BIT_IDX		= 4'b0;
	reg [1:0]	INPUT_SW	= 2'b0;
	reg [8:0]	CLK_COUNT	= 9'b0;
	reg [7:0]	DATA_RX		= 8'b0;

	initial begin
		RX_OUT	<= 8'b0;
		//ERR		<= 1'b0;
		DONE	<= 1'b0;
		BUSY	<= 1'b0;
	end

	always @(posedge CLK) begin
		INPUT_SW = { INPUT_SW[0], RX_IN };
		if (!RX_EN) begin
			STATE <= RESET;
		end
		else begin
			case (STATE)
				RESET: begin
					RX_OUT		<= 8'b0;
					//ERR			<= 1'b0;
					DONE		<= 1'b0;
					BUSY		<= 1'b0;
					BIT_IDX		<= 4'b0;
					CLK_COUNT	<= 9'b0;
					DATA_RX		<= 8'b0;
					if (RX_EN) begin
						STATE	<= IDLE;
					end
				end

				IDLE: begin
					DONE <= 1'b0;
					if (INPUT_SW == 2'b10) begin
						STATE		<= DATA_BITS;
						RX_OUT		<= 8'b0;
						BIT_IDX		<= 4'b0;
						CLK_COUNT	<= 9'b0;
						DATA_RX		<= 8'b0;
						BUSY		<= 1'b1;
						//ERR			<= 1'b0;
					end
					else begin
						//CLK_COUNT	<= CLK_COUNT + 1;
						STATE	<= IDLE;
					end
				end

				DATA_BITS: begin
					if (BIT_IDX <= 4'b1000) begin
						if (CLK_COUNT <= 9'b1_1011_0001) begin
							CLK_COUNT <= CLK_COUNT + 9'b1;
							if (CLK_COUNT == 9'b1_1011_0001) begin
								DATA_RX[4'b111 - BIT_IDX] 	<= RX_IN;
								CLK_COUNT 					<= 9'b0;
								BIT_IDX						<= BIT_IDX + 4'b1;
								if (BIT_IDX == 4'b1000) begin
									BIT_IDX	<= 4'b0;
									STATE	<= STOP_BIT;
								end
							end
						end
					end
				end

				STOP_BIT: begin
						STATE		<= IDLE;
						DONE		<= 1'b1;
						BUSY		<= 1'b0;
						RX_OUT		<= DATA_RX;
						CLK_COUNT	<= 9'b0;
				end

				default: STATE <= IDLE;
			endcase
		end	
	end

endmodule
