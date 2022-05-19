`timescale 1ns / 1ps

module UART_DEC (
	input 			CLK,
	input 			DATA_EN,
	input 			STATE_R_IN,
	input 			STATE_W_IN,
	input  [15:0]	ADDR_IN,
	input  [63:0]	DATA_IN,
	input 			FAIL_IN,

	output 	reg			STATE_R_OUT,
	output 	reg			STATE_W_OUT,
	output  reg [7:0]	ADDR_OUT,
	output  reg [31:0]	DATA_OUT,
	output 	reg			FAIL_OUT
	);

	reg [9:0] FAIL;

	initial begin
		STATE_R_IN 	<= 1'b0;
		STATE_W_IN 	<= 1'b0;
		ADDR_IN 	<= 16'h0;
		DATA_IN 	<= 1'b0;
		FAIL_IN 	<= 1'b0;
		FAIL_OUT	<= 1'b0;
	end

	always @(posedge CLK) begin
		if (!DATA_EN) begin
			// reset
			STATE_R_IN 	<= 1'b0;
			STATE_W_IN 	<= 1'b0;
			ADDR_IN 	<= 1'b0;
			DATA_IN 	<= 1'b0;
			FAIL_IN 	<= 1'b0;
			FAIL_OUT	<= 1'b0;
		end
		else if (FAIL_IN) begin
			FAIL_OUT <= 1;
		end
		else begin
			case (ADDR_IN[7:0])
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
			case (ADDR_IN[15:8])
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
			case (DATA_IN[7:0])
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
			case (DATA_IN[15:8])
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
			case (DATA_IN[23:16])
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
			case (DATA_IN[31:24])
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
			case (DATA_IN[39:32])
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
			case (DATA_IN[47:40])
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
			case (DATA_IN[55:48])
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
			case (DATA_IN[63:56])
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
			STATE_R_OUT <= STATE_R_IN;
			STATE_W_OUT <= STATE_W_IN;
			FAIL_OUT 	<= 0;
		end
	end

endmodule