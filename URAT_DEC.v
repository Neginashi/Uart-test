`timescale 1ns / 1ps

module UART_DEC (
	input 			CLK,
	input 			DATA_EN,
	input 			STATE_R_IN,
	input 			STATE_W_IN,
	input  [15:0]	ADDR_IN,
	input  [63:0]	DATA_IN,
	input 			FAIL_IN,
	input 			START,

	output 	reg			STATE_R_OUT,
	output 	reg			STATE_W_OUT,
	output  reg [7:0]	ADDR_OUT,
	output  reg [31:0]	DATA_OUT,
	output 	reg			FAIL_OUT,
	output	reg 		DONE
	);

	reg [2:0] 	STATE;
	reg [2:0] 	STATE_BUF;
	reg [63:0] 	DATA_BUF;
	reg [15:0] 	ADDR_BUF;

	parameter IDLE 			= 3'b001;
	parameter BEGIN 		= 3'b010;
	parameter WRITE_READ 	= 3'b011;
	parameter FAIL 			= 3'b100;
	parameter STOP 			= 3'b101;


	initial begin
		STATE_R_OUT 	<= 1'b0;
		STATE_W_OUT 	<= 1'b0;
		ADDR_OUT	 	<= 8'h0;
		DATA_OUT	 	<= 32'h0;
		FAIL_OUT 		<= 1'b0;
		STATE 			<= IDLE;
		DONE 			<= 1'b0;
		STATE_BUF 		<= 3'b0;
		DATA_BUF 		<= 64'b0;
		ADDR_BUF 		<= 16'b0;
	end


	always @(posedge CLK) begin
		if (!DATA_EN) begin
			STATE <= IDLE;
			STATE_R_OUT 	<= 1'b0;
			STATE_W_OUT 	<= 1'b0;
			ADDR_OUT	 	<= 8'h0;
			DATA_OUT	 	<= 32'h0;
			FAIL_OUT 		<= 1'b0;
			STATE_BUF 		<= 3'b0;
			DATA_BUF 		<= 64'b0;
			ADDR_BUF 		<= 16'b0;
		end
		else begin
			case (STATE)
				IDLE: begin
					if (START) begin
						STATE 		<= BEGIN;
						STATE_BUF 	<= { FAIL_IN, STATE_R_IN, STATE_W_IN };
						DATA_BUF 	<= DATA_IN;
						ADDR_BUF 	<= ADDR_IN;
					end
					else begin
						STATE_R_OUT 	<= 1'b0;
						STATE_W_OUT 	<= 1'b0;
						ADDR_OUT	 	<= 8'h0;
						DATA_OUT	 	<= 32'h0;
						FAIL_OUT 		<= 1'b0;
						STATE_BUF 		<= 3'b0;
						STATE 			<= IDLE;
						DATA_BUF 		<= 64'b0;
						ADDR_BUF 		<= 16'b0;
					end
				end

				BEGIN: begin
					if (STATE_BUF[2] == 1) begin
						STATE <= FAIL;
					end
					else if (STATE_BUF == 3'b001 || STATE_BUF == 3'b010) begin
						STATE <= WRITE_READ;
					end
					else begin
						STATE <= IDLE;
					end
				end

				WRITE_READ: begin
					case (ADDR_BUF[7:0])
						8'h30: ADDR_OUT[3:0] <= 4'h0;
						8'h31: ADDR_OUT[3:0] <= 4'h1;
						8'h32: ADDR_OUT[3:0] <= 4'h2;
						8'h33: ADDR_OUT[3:0] <= 4'h3;
						8'h34: ADDR_OUT[3:0] <= 4'h4;
						8'h35: ADDR_OUT[3:0] <= 4'h5;
						8'h36: ADDR_OUT[3:0] <= 4'h6;
						8'h37: ADDR_OUT[3:0] <= 4'h7;
						8'h38: ADDR_OUT[3:0] <= 4'h8;
						8'h39: ADDR_OUT[3:0] <= 4'h9;
						8'h41: ADDR_OUT[3:0] <= 4'hA;
						8'h42: ADDR_OUT[3:0] <= 4'hB;
						8'h43: ADDR_OUT[3:0] <= 4'hC;
						8'h44: ADDR_OUT[3:0] <= 4'hD;
						8'h45: ADDR_OUT[3:0] <= 4'hE;
						8'h46: ADDR_OUT[3:0] <= 4'hF;
					endcase
					case (ADDR_BUF[15:8])
						8'h30: ADDR_OUT[7:4] <= 4'h0;
						8'h31: ADDR_OUT[7:4] <= 4'h1;
						8'h32: ADDR_OUT[7:4] <= 4'h2;
						8'h33: ADDR_OUT[7:4] <= 4'h3;
						8'h34: ADDR_OUT[7:4] <= 4'h4;
						8'h35: ADDR_OUT[7:4] <= 4'h5;
						8'h36: ADDR_OUT[7:4] <= 4'h6;
						8'h37: ADDR_OUT[7:4] <= 4'h7;
						8'h38: ADDR_OUT[7:4] <= 4'h8;
						8'h39: ADDR_OUT[7:4] <= 4'h9;
						8'h41: ADDR_OUT[7:4] <= 4'hA;
						8'h42: ADDR_OUT[7:4] <= 4'hB;
						8'h43: ADDR_OUT[7:4] <= 4'hC;
						8'h44: ADDR_OUT[7:4] <= 4'hD;
						8'h45: ADDR_OUT[7:4] <= 4'hE;
						8'h46: ADDR_OUT[7:4] <= 4'hF;
					endcase
					case (DATA_BUF[7:0])
						8'h30: DATA_OUT[3:0] <= 4'h0;
						8'h31: DATA_OUT[3:0] <= 4'h1;
						8'h32: DATA_OUT[3:0] <= 4'h2;
						8'h33: DATA_OUT[3:0] <= 4'h3;
						8'h34: DATA_OUT[3:0] <= 4'h4;
						8'h35: DATA_OUT[3:0] <= 4'h5;
						8'h36: DATA_OUT[3:0] <= 4'h6;
						8'h37: DATA_OUT[3:0] <= 4'h7;
						8'h38: DATA_OUT[3:0] <= 4'h8;
						8'h39: DATA_OUT[3:0] <= 4'h9;
						8'h41: DATA_OUT[3:0] <= 4'hA;
						8'h42: DATA_OUT[3:0] <= 4'hB;
						8'h43: DATA_OUT[3:0] <= 4'hC;
						8'h44: DATA_OUT[3:0] <= 4'hD;
						8'h45: DATA_OUT[3:0] <= 4'hE;
						8'h46: DATA_OUT[3:0] <= 4'hF;
					endcase
					case (DATA_BUF[15:8])
						8'h30: DATA_OUT[7:4] <= 4'h0;
						8'h31: DATA_OUT[7:4] <= 4'h1;
						8'h32: DATA_OUT[7:4] <= 4'h2;
						8'h33: DATA_OUT[7:4] <= 4'h3;
						8'h34: DATA_OUT[7:4] <= 4'h4;
						8'h35: DATA_OUT[7:4] <= 4'h5;
						8'h36: DATA_OUT[7:4] <= 4'h6;
						8'h37: DATA_OUT[7:4] <= 4'h7;
						8'h38: DATA_OUT[7:4] <= 4'h8;
						8'h39: DATA_OUT[7:4] <= 4'h9;
						8'h41: DATA_OUT[7:4] <= 4'hA;
						8'h42: DATA_OUT[7:4] <= 4'hB;
						8'h43: DATA_OUT[7:4] <= 4'hC;
						8'h44: DATA_OUT[7:4] <= 4'hD;
						8'h45: DATA_OUT[7:4] <= 4'hE;
						8'h46: DATA_OUT[7:4] <= 4'hF;
					endcase
					case (DATA_BUF[23:16])
						8'h30: DATA_OUT[11:8] <= 4'h0;
						8'h31: DATA_OUT[11:8] <= 4'h1;
						8'h32: DATA_OUT[11:8] <= 4'h2;
						8'h33: DATA_OUT[11:8] <= 4'h3;
						8'h34: DATA_OUT[11:8] <= 4'h4;
						8'h35: DATA_OUT[11:8] <= 4'h5;
						8'h36: DATA_OUT[11:8] <= 4'h6;
						8'h37: DATA_OUT[11:8] <= 4'h7;
						8'h38: DATA_OUT[11:8] <= 4'h8;
						8'h39: DATA_OUT[11:8] <= 4'h9;
						8'h41: DATA_OUT[11:8] <= 4'hA;
						8'h42: DATA_OUT[11:8] <= 4'hB;
						8'h43: DATA_OUT[11:8] <= 4'hC;
						8'h44: DATA_OUT[11:8] <= 4'hD;
						8'h45: DATA_OUT[11:8] <= 4'hE;
						8'h46: DATA_OUT[11:8] <= 4'hF;
					endcase
					case (DATA_BUF[31:24])
						8'h30: DATA_OUT[15:12] <= 4'h0;
						8'h31: DATA_OUT[15:12] <= 4'h1;
						8'h32: DATA_OUT[15:12] <= 4'h2;
						8'h33: DATA_OUT[15:12] <= 4'h3;
						8'h34: DATA_OUT[15:12] <= 4'h4;
						8'h35: DATA_OUT[15:12] <= 4'h5;
						8'h36: DATA_OUT[15:12] <= 4'h6;
						8'h37: DATA_OUT[15:12] <= 4'h7;
						8'h38: DATA_OUT[15:12] <= 4'h8;
						8'h39: DATA_OUT[15:12] <= 4'h9;
						8'h41: DATA_OUT[15:12] <= 4'hA;
						8'h42: DATA_OUT[15:12] <= 4'hB;
						8'h43: DATA_OUT[15:12] <= 4'hC;
						8'h44: DATA_OUT[15:12] <= 4'hD;
						8'h45: DATA_OUT[15:12] <= 4'hE;
						8'h46: DATA_OUT[15:12] <= 4'hF;
					endcase
					case (DATA_BUF[39:32])
						8'h30: DATA_OUT[19:16] <= 4'h0;
						8'h31: DATA_OUT[19:16] <= 4'h1;
						8'h32: DATA_OUT[19:16] <= 4'h2;
						8'h33: DATA_OUT[19:16] <= 4'h3;
						8'h34: DATA_OUT[19:16] <= 4'h4;
						8'h35: DATA_OUT[19:16] <= 4'h5;
						8'h36: DATA_OUT[19:16] <= 4'h6;
						8'h37: DATA_OUT[19:16] <= 4'h7;
						8'h38: DATA_OUT[19:16] <= 4'h8;
						8'h39: DATA_OUT[19:16] <= 4'h9;
						8'h41: DATA_OUT[19:16] <= 4'hA;
						8'h42: DATA_OUT[19:16] <= 4'hB;
						8'h43: DATA_OUT[19:16] <= 4'hC;
						8'h44: DATA_OUT[19:16] <= 4'hD;
						8'h45: DATA_OUT[19:16] <= 4'hE;
						8'h46: DATA_OUT[19:16] <= 4'hF;
					endcase
					case (DATA_BUF[47:40])
						8'h30: DATA_OUT[23:20] <= 4'h0;
						8'h31: DATA_OUT[23:20] <= 4'h1;
						8'h32: DATA_OUT[23:20] <= 4'h2;
						8'h33: DATA_OUT[23:20] <= 4'h3;
						8'h34: DATA_OUT[23:20] <= 4'h4;
						8'h35: DATA_OUT[23:20] <= 4'h5;
						8'h36: DATA_OUT[23:20] <= 4'h6;
						8'h37: DATA_OUT[23:20] <= 4'h7;
						8'h38: DATA_OUT[23:20] <= 4'h8;
						8'h39: DATA_OUT[23:20] <= 4'h9;
						8'h41: DATA_OUT[23:20] <= 4'hA;
						8'h42: DATA_OUT[23:20] <= 4'hB;
						8'h43: DATA_OUT[23:20] <= 4'hC;
						8'h44: DATA_OUT[23:20] <= 4'hD;
						8'h45: DATA_OUT[23:20] <= 4'hE;
						8'h46: DATA_OUT[23:20] <= 4'hF;
					endcase
					case (DATA_BUF[55:48])
						8'h30: DATA_OUT[27:24] <= 4'h0;
						8'h31: DATA_OUT[27:24] <= 4'h1;
						8'h32: DATA_OUT[27:24] <= 4'h2;
						8'h33: DATA_OUT[27:24] <= 4'h3;
						8'h34: DATA_OUT[27:24] <= 4'h4;
						8'h35: DATA_OUT[27:24] <= 4'h5;
						8'h36: DATA_OUT[27:24] <= 4'h6;
						8'h37: DATA_OUT[27:24] <= 4'h7;
						8'h38: DATA_OUT[27:24] <= 4'h8;
						8'h39: DATA_OUT[27:24] <= 4'h9;
						8'h41: DATA_OUT[27:24] <= 4'hA;
						8'h42: DATA_OUT[27:24] <= 4'hB;
						8'h43: DATA_OUT[27:24] <= 4'hC;
						8'h44: DATA_OUT[27:24] <= 4'hD;
						8'h45: DATA_OUT[27:24] <= 4'hE;
						8'h46: DATA_OUT[27:24] <= 4'hF;
					endcase
					case (DATA_BUF[63:56])
						8'h30: DATA_OUT[31:28] <= 4'h0;
						8'h31: DATA_OUT[31:28] <= 4'h1;
						8'h32: DATA_OUT[31:28] <= 4'h2;
						8'h33: DATA_OUT[31:28] <= 4'h3;
						8'h34: DATA_OUT[31:28] <= 4'h4;
						8'h35: DATA_OUT[31:28] <= 4'h5;
						8'h36: DATA_OUT[31:28] <= 4'h6;
						8'h37: DATA_OUT[31:28] <= 4'h7;
						8'h38: DATA_OUT[31:28] <= 4'h8;
						8'h39: DATA_OUT[31:28] <= 4'h9;
						8'h41: DATA_OUT[31:28] <= 4'hA;
						8'h42: DATA_OUT[31:28] <= 4'hB;
						8'h43: DATA_OUT[31:28] <= 4'hC;
						8'h44: DATA_OUT[31:28] <= 4'hD;
						8'h45: DATA_OUT[31:28] <= 4'hE;
						8'h46: DATA_OUT[31:28] <= 4'hF;
					endcase
					STATE_R_OUT <= STATE_BUF[1];
					STATE_W_OUT <= STATE_BUF[0];
					FAIL_OUT 	<= STATE_BUF[2];
					DONE 		<= 1'b1;
					STATE 		<= STOP;
				end

				FAIL: begin
					STATE_R_OUT <= STATE_BUF[1];
					STATE_W_OUT <= STATE_BUF[0];
					FAIL_OUT 	<= STATE_BUF[2];
					DONE 		<= 1'b1;
					STATE 		<= STOP;
				end

				STOP: begin
					STATE_R_OUT 	<= 1'b0;
					STATE_W_OUT 	<= 1'b0;
					ADDR_OUT	 	<= 8'h0;
					DATA_OUT	 	<= 32'h0;
					FAIL_OUT 		<= 1'b0;
					DONE 			<= 1'b0;
					STATE_BUF 		<= 3'b0;
					DATA_BUF 		<= 64'b0;
					ADDR_BUF 		<= 16'b0;
					STATE 			<= IDLE;
				end

				default: begin
					STATE 			<= IDLE;
				end
			endcase
		end
	end

endmodule
