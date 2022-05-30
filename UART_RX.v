`timescale 1ns / 1ps

module UART_RX(
	input	wire		CLK,
	input	wire		RST,	
	input	wire		RX_IN,

	output	reg	[7:0]	RX_OUT,
	output	reg			DONE,
	output	reg			BUSY
	);

	// CLK_F 	= 50000000;
	// UART_B 	= 115200;
	// B_CNT 	= CLK_F / UART_B; //433

	// STATEs of STATE machine
	parameter	IDLE		= 2'b01;
	parameter	DATA_BITS	= 2'b10;
	parameter	STOP_BIT	= 2'b11;

	reg [1:0]	STATE		= 2'b0;
	reg [3:0]	BIT_IDX		= 4'b0;
	reg [3:0]	INPUT_SW	= 4'b0;
	reg [8:0]	CLK_COUNT	= 9'b0;
	reg [7:0]	DATA_RX		= 8'b0;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			RX_OUT		<= 8'b0;
			DONE		<= 1'b0;
			BUSY		<= 1'b0;
			BIT_IDX		<= 4'b0;
			CLK_COUNT	<= 9'b0;
			DATA_RX		<= 8'b0;
			STATE		<= IDLE;
		end
		else begin
			INPUT_SW = { INPUT_SW[3:0], RX_IN };
			begin
				case (STATE)
					IDLE: begin
						DONE <= 1'b0;
						if (INPUT_SW[3:2] == 2'b10) begin
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
							if (CLK_COUNT <= 9'b1_1011_0101) begin
								CLK_COUNT <= CLK_COUNT + 9'b1;
								if (CLK_COUNT == 9'b1_1011_0101) begin
									DATA_RX[BIT_IDX] 	<= INPUT_SW[2];
									CLK_COUNT 			<= 9'b0;
									BIT_IDX				<= BIT_IDX + 4'b1;
									if (BIT_IDX == 4'b1000) begin
										BIT_IDX	<= 4'b0;
										RX_OUT	<= DATA_RX;
										STATE	<= STOP_BIT;
									end
								end
							end
						end
					end

					STOP_BIT: begin
							STATE		<= IDLE;
							BUSY		<= 1'b0;
							CLK_COUNT	<= 9'b0;
							DONE		<= 1'b1;
					end

					default: STATE <= IDLE;
				endcase
			end
		end
	end

endmodule
