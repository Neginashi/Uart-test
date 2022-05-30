`timescale 1ns / 1ps

module UART_PRO_TX(
	input wire			CLK,
	input wire			RST,
	input wire [79:0]	DATA_IN,
	input wire			FAIL,
	input wire			OK,
	input wire			STATE_R,
	input wire			START,	

	output  reg			START_OUT,
	output  reg [7:0]	DATA_OUT
	);

	reg [79:0] 	DATA_BUF_1;
	reg [79:0] 	DATA_BUF_2;
	reg [3:0] 	CNT_R;
	reg [2:0] 	CNT_OK;
	reg [2:0] 	CNT_FAIL;
	reg [12:0] 	CNT_BIT;
	reg [2:0]	STATE;
	reg 		BEGIN;
	reg 		RESET;
	reg [2:0] 	STATE_BUF;
	
	// STATEs of STATE machine
	parameter 		IDLE 		= 3'b001;
	parameter 		STATE_READ 	= 3'b010;
	parameter 		STATE_OK 	= 3'b011;
	parameter 		STATE_FAIL 	= 3'b100;
	parameter 		STOP	 	= 3'b101;
	parameter 		STATE_RESET	= 3'b110;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			RESET <= 0;
		end
		else if (RESET == 0) begin
			RESET <= RESET + 1;
		end
	end

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			DATA_BUF_1 	<= 80'b0;
			STATE_BUF 	<= 3'b0;
			BEGIN 		<= 1'b0;
		end
		else if (START) begin
			DATA_BUF_1 	<= DATA_IN;
			STATE_BUF 	<= { STATE_R, OK, FAIL };
			BEGIN 		<= 1'b1;
		end
		else if (START_OUT) begin
			DATA_BUF_1 	<= 80'b0;
			STATE_BUF 	<= 3'b0;
			BEGIN 		<= 1'b0;
		end
		else begin
			DATA_BUF_1 	<= DATA_BUF_1;
		end
	end

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			DATA_OUT 	<= 8'b0;
			CNT_R	 	<= 4'b0;
			CNT_OK	 	<= 3'b0;
			CNT_FAIL	<= 3'b0;
			STATE 	 	<= IDLE;
			START_OUT 	<= 1'b0;
			CNT_BIT 	<= 13'b0;
			DATA_BUF_2 	<= 80'b0;
		end
		else begin
			case (STATE)
				default: begin
					STATE <= IDLE;
				end

				IDLE: begin
					if (!RESET) begin
						STATE <= STATE_RESET;
					end
					else begin
						if (BEGIN == 1'b1) begin
							DATA_BUF_2 <= DATA_BUF_1;
							if (STATE_BUF == 3'b100) begin
								STATE <= STATE_READ;
							end
							else if (STATE_BUF == 3'b010) begin
								STATE <= STATE_OK;
							end
							else if (STATE_BUF == 3'b001) begin
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
				end

				STATE_RESET: begin
					DATA_OUT 	<= 8'h3E;
					START_OUT 	<= 1'b1;
					STATE 		<= STOP;
				end
				
				STATE_READ: begin
					if (CNT_R <= 4'b1010) begin
						if (CNT_BIT 	<= 13'b1_0010_1001_1011) begin
							START_OUT 	<= 1'b1;
							CNT_BIT 	<= CNT_BIT + 13'b1;
						end
						else begin
							DATA_OUT 	<= DATA_BUF_2[79:72];
							DATA_BUF_2 	<= DATA_BUF_2 << 8;
							CNT_R 		<= CNT_R + 4'b1;
							CNT_BIT 	<= 13'b0;
						end
					end
					else begin
						CNT_R 	<= 4'b0;
						STATE 	<= STOP;
					end
				end

				STATE_FAIL: begin
					if (CNT_FAIL <= 3'b110) begin
						if (CNT_BIT 	<= 13'b1_0010_1001_1011) begin
							START_OUT 	<= 1'b1;
							CNT_BIT 	<= CNT_BIT + 13'b1;
						end
						else begin
							DATA_OUT 	<= DATA_BUF_2[79:72];
							DATA_BUF_2 	<= DATA_BUF_2 << 8;
							CNT_FAIL 	<= CNT_FAIL + 3'b1;
							CNT_BIT 	<= 13'b0;
						end
					end
					else begin
						CNT_FAIL 	<= 3'b0;
						STATE 		<= STOP;
					end
				end

				STATE_OK: begin
					if (CNT_OK <= 3'b100) begin
						if (CNT_BIT 	<= 13'b1_0010_1001_1011) begin
							START_OUT 	<= 1'b1;
							CNT_BIT 	<= CNT_BIT + 13'b1;
						end
						else begin
							DATA_OUT 	<= DATA_BUF_2[79:72];
							DATA_BUF_2 	<= DATA_BUF_2 << 8;
							CNT_OK 		<= CNT_OK + 3'b1;
							CNT_BIT 	<= 13'b0;
						end
					end
					else begin
						CNT_OK 	<= 3'b0;
						STATE 	<= STOP;
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
