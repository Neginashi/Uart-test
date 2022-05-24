`timescale 1ns / 1ps

module UART_PRO_TX(
	input wire			CLK,
	input wire			DATA_EN,
	input wire [79:0]	DATA_IN,
	input wire			FAIL,
	input wire			OK,
	input wire			STATE_R,
	input wire			START,	

	output  reg			START_OUT,
	output  reg [7:0]	DATA_OUT
	);

	reg [79:0] 	DATA_BUF;
	reg [3:0] 	CNT_R;
	reg [2:0] 	CNT_OK;
	reg [2:0] 	CNT_FAIL;
	reg [12:0] 	CNT_BIT;
	reg [2:0]	STATE;
	
	// STATEs of STATE machine
	parameter 		IDLE 		= 3'b001;
	parameter 		STATE_READ 	= 3'b010;
	parameter 		STATE_OK 	= 3'b011;
	parameter 		STATE_FAIL 	= 3'b100;
	parameter 		STOP	 	= 3'b101;

	initial begin
		DATA_OUT 	<= 8'b0;
		CNT_R	 	<= 4'b0;
		CNT_OK	 	<= 3'b0;
		CNT_FAIL	<= 3'b0;
		STATE 		<= IDLE;
		START_OUT 	<= 1'b0;
		CNT_BIT 	<= 13'b0;
	end

	always @(posedge CLK) begin
		if (!DATA_EN) begin
			DATA_OUT 	<= 8'b0;
			CNT_R	 	<= 4'b0;
			CNT_OK	 	<= 3'b0;
			CNT_FAIL	<= 3'b0;
			STATE 	 	<= IDLE;
			START_OUT 	<= 1'b0;
			CNT_BIT 	<= 13'b0;
		end
		else begin
			case (STATE)
				default: begin
					STATE <= IDLE;
				end
				
				IDLE: begin
					if (START) begin
						DATA_BUF 	<= DATA_IN;
						if (STATE_R) begin
							STATE <= STATE_READ;
						end
						else if (OK) begin
							STATE <= STATE_OK;
						end
						else if (FAIL) begin
							STATE <= STATE_FAIL;
						end
						else begin
							STATE <= IDLE;
						end
					end
					else begin
						DATA_OUT 	<= 8'b0;
						CNT_R	 	<= 4'b0;
						CNT_OK	 	<= 3'b0;
						CNT_FAIL	<= 3'b0;
						STATE  		<= IDLE;
						START_OUT 	<= 1'b0;
						CNT_BIT 	<= 13'b0;
					end
				end

				STATE_READ: begin
					if (CNT_R <= 4'b1011) begin
						if (CNT_BIT == 13'b0) begin
							START_OUT 	<= 1'b1;
							DATA_OUT 	<= DATA_BUF[79:72];
							DATA_BUF 	<= DATA_BUF << 8;
							CNT_R 		<= CNT_R + 4'b1;
							CNT_BIT 	<= 13'b1_0000_1110_1010;
							if (CNT_R == 4'b1011) begin
								CNT_R 		<= 4'b0;
								STATE 		<= STOP;
							end
						end
						else begin
							CNT_BIT <= CNT_BIT - 13'b1;
						end
					end
					else begin
						STATE <= IDLE;
					end
				end

				STATE_OK: begin
					if (CNT_OK <= 3'b100) begin
						if (CNT_BIT == 13'b0) begin
							START_OUT 	<= 1'b1;
							DATA_OUT 	<= DATA_BUF[79:72];
							DATA_BUF 	<= DATA_BUF << 8;
							CNT_OK 		<= CNT_OK + 3'b1;
							CNT_BIT 	<= 13'b1_0000_1110_1010;
							if (CNT_OK == 3'b100) begin
								CNT_OK 		<= 2'b0;
								STATE 		<= STOP;
							end
						end
						else begin
							CNT_BIT <= CNT_BIT - 13'b1;
						end
					end
					else begin
						STATE <= IDLE;
					end
				end

				STATE_FAIL: begin
					if (CNT_FAIL <= 3'b111) begin
						if (CNT_BIT == 13'b0) begin
							START_OUT 	<= 1'b1;
							DATA_OUT 	<= DATA_BUF[79:72];
							DATA_BUF 	<= DATA_BUF << 8;
							CNT_FAIL 	<= CNT_FAIL + 3'b1;
							CNT_BIT 	<= 13'b1_0000_1110_1010;
							if (CNT_FAIL == 3'b111) begin
								CNT_FAIL 	<= 2'b0;
								STATE 		<= STOP;
							end
						end
						else begin
							CNT_BIT <= CNT_BIT - 13'b1;
						end
					end
					else begin
						STATE <= IDLE;
					end
				end

				STOP: begin
					DATA_OUT 	<= 8'b0;
					CNT_R	 	<= 4'b0;
					CNT_OK	 	<= 3'b0;
					CNT_FAIL	<= 3'b0;
					STATE  		<= IDLE;
					START_OUT 	<= 1'b0;
					CNT_BIT 	<= 13'b0;
				end
			endcase
		end
	end

endmodule
