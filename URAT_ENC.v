`timescale 1ns / 1ps

module UART_ENC(
	input 			CLK,
	input 			DATA_EN,
	input 	[31:0]	DATA_IN,
	input 			FAIL,
	input 			OK,
	input			STATE_R,

	output reg [79:0]	DATA_OUT,
	output reg			FAIL_OUT,
	output reg			OK_OUT,
	output reg			STATE_R_OUT
	);

	reg [2:0] STATE = {STATE_R, OK, FAIL};

	initial begin
		DATA_IN 	<= 32'b0;
		DATA_OUT 	<= 80'b0;
		FAIL		<= 1'b0;
		OK 			<= 1'b0;
		STATE_R 	<= 1'b0;
		STATE 		<= 3'b0;
	end

	reg [2:0] STATE = {STATE_R, OK, FAIL};

	always @(posedge CLK) begin
		if (!DATA_EN) begin
			// reset
			DATA_IN 	<= 32'b0;
			DATA_OUT 	<= 80'b0;
			FAIL		<= 1'b0;
			OK 			<= 1'b0;
			STATE_R 	<= 1'b0;
		end
		else begin
			case (STATE)
				3'b100: begin
					case (DATA_IN[3:0])
						4'h0: DATA_OUT[23:16] <= 8'h30;
						4'h1: DATA_OUT[23:16] <= 8'h31;
						4'h2: DATA_OUT[23:16] <= 8'h32;
						4'h3: DATA_OUT[23:16] <= 8'h33;
						4'h4: DATA_OUT[23:16] <= 8'h34;
						4'h5: DATA_OUT[23:16] <= 8'h35;
						4'h6: DATA_OUT[23:16] <= 8'h36;
						4'h7: DATA_OUT[23:16] <= 8'h37;
						4'h8: DATA_OUT[23:16] <= 8'h38;
						4'h9: DATA_OUT[23:16] <= 8'h39;
						4'hA: DATA_OUT[23:16] <= 8'h41;
						4'hB: DATA_OUT[23:16] <= 8'h42;
						4'hC: DATA_OUT[23:16] <= 8'h43;
						4'hD: DATA_OUT[23:16] <= 8'h44;
						4'hE: DATA_OUT[23:16] <= 8'h45;
						4'hF: DATA_OUT[23:16] <= 8'h46;
					endcase
					case (DATA_IN[7:4])
						4'h0: DATA_OUT[31:24] <= 8'h30;
						4'h1: DATA_OUT[31:24] <= 8'h31;
						4'h2: DATA_OUT[31:24] <= 8'h32;
						4'h3: DATA_OUT[31:24] <= 8'h33;
						4'h4: DATA_OUT[31:24] <= 8'h34;
						4'h5: DATA_OUT[31:24] <= 8'h35;
						4'h6: DATA_OUT[31:24] <= 8'h36;
						4'h7: DATA_OUT[31:24] <= 8'h37;
						4'h8: DATA_OUT[31:24] <= 8'h38;
						4'h9: DATA_OUT[31:24] <= 8'h39;
						4'hA: DATA_OUT[31:24] <= 8'h41;
						4'hB: DATA_OUT[31:24] <= 8'h42;
						4'hC: DATA_OUT[31:24] <= 8'h43;
						4'hD: DATA_OUT[31:24] <= 8'h44;
						4'hE: DATA_OUT[31:24] <= 8'h45;
						4'hF: DATA_OUT[31:24] <= 8'h46;
					endcase
					case (DATA_IN[11:8])
						4'h0: DATA_OUT[39:32] <= 8'h30;
						4'h1: DATA_OUT[39:32] <= 8'h31;
						4'h2: DATA_OUT[39:32] <= 8'h32;
						4'h3: DATA_OUT[39:32] <= 8'h33;
						4'h4: DATA_OUT[39:32] <= 8'h34;
						4'h5: DATA_OUT[39:32] <= 8'h35;
						4'h6: DATA_OUT[39:32] <= 8'h36;
						4'h7: DATA_OUT[39:32] <= 8'h37;
						4'h8: DATA_OUT[39:32] <= 8'h38;
						4'h9: DATA_OUT[39:32] <= 8'h39;
						4'hA: DATA_OUT[39:32] <= 8'h41;
						4'hB: DATA_OUT[39:32] <= 8'h42;
						4'hC: DATA_OUT[39:32] <= 8'h43;
						4'hD: DATA_OUT[39:32] <= 8'h44;
						4'hE: DATA_OUT[39:32] <= 8'h45;
						4'hF: DATA_OUT[39:32] <= 8'h46;
					endcase
					case (DATA_IN[15:12])
						4'h0: DATA_OUT[47:40] <= 8'h30;
						4'h1: DATA_OUT[47:40] <= 8'h31;
						4'h2: DATA_OUT[47:40] <= 8'h32;
						4'h3: DATA_OUT[47:40] <= 8'h33;
						4'h4: DATA_OUT[47:40] <= 8'h34;
						4'h5: DATA_OUT[47:40] <= 8'h35;
						4'h6: DATA_OUT[47:40] <= 8'h36;
						4'h7: DATA_OUT[47:40] <= 8'h37;
						4'h8: DATA_OUT[47:40] <= 8'h38;
						4'h9: DATA_OUT[47:40] <= 8'h39;
						4'hA: DATA_OUT[47:40] <= 8'h41;
						4'hB: DATA_OUT[47:40] <= 8'h42;
						4'hC: DATA_OUT[47:40] <= 8'h43;
						4'hD: DATA_OUT[47:40] <= 8'h44;
						4'hE: DATA_OUT[47:40] <= 8'h45;
						4'hF: DATA_OUT[47:40] <= 8'h46;
					endcase
					case (DATA_IN[19:16])
						4'h0: DATA_OUT[55:48] <= 8'h30;
						4'h1: DATA_OUT[55:48] <= 8'h31;
						4'h2: DATA_OUT[55:48] <= 8'h32;
						4'h3: DATA_OUT[55:48] <= 8'h33;
						4'h4: DATA_OUT[55:48] <= 8'h34;
						4'h5: DATA_OUT[55:48] <= 8'h35;
						4'h6: DATA_OUT[55:48] <= 8'h36;
						4'h7: DATA_OUT[55:48] <= 8'h37;
						4'h8: DATA_OUT[55:48] <= 8'h38;
						4'h9: DATA_OUT[55:48] <= 8'h39;
						4'hA: DATA_OUT[55:48] <= 8'h41;
						4'hB: DATA_OUT[55:48] <= 8'h42;
						4'hC: DATA_OUT[55:48] <= 8'h43;
						4'hD: DATA_OUT[55:48] <= 8'h44;
						4'hE: DATA_OUT[55:48] <= 8'h45;
						4'hF: DATA_OUT[55:48] <= 8'h46;
					endcase
					case (DATA_IN[23:20])
						4'h0: DATA_OUT[63:56] <= 8'h30;
						4'h1: DATA_OUT[63:56] <= 8'h31;
						4'h2: DATA_OUT[63:56] <= 8'h32;
						4'h3: DATA_OUT[63:56] <= 8'h33;
						4'h4: DATA_OUT[63:56] <= 8'h34;
						4'h5: DATA_OUT[63:56] <= 8'h35;
						4'h6: DATA_OUT[63:56] <= 8'h36;
						4'h7: DATA_OUT[63:56] <= 8'h37;
						4'h8: DATA_OUT[63:56] <= 8'h38;
						4'h9: DATA_OUT[63:56] <= 8'h39;
						4'hA: DATA_OUT[63:56] <= 8'h41;
						4'hB: DATA_OUT[63:56] <= 8'h42;
						4'hC: DATA_OUT[63:56] <= 8'h43;
						4'hD: DATA_OUT[63:56] <= 8'h44;
						4'hE: DATA_OUT[63:56] <= 8'h45;
						4'hF: DATA_OUT[63:56] <= 8'h46;
					endcase
					case (DATA_IN[27:24])
						4'h0: DATA_OUT[71:64] <= 8'h30;
						4'h1: DATA_OUT[71:64] <= 8'h31;
						4'h2: DATA_OUT[71:64] <= 8'h32;
						4'h3: DATA_OUT[71:64] <= 8'h33;
						4'h4: DATA_OUT[71:64] <= 8'h34;
						4'h5: DATA_OUT[71:64] <= 8'h35;
						4'h6: DATA_OUT[71:64] <= 8'h36;
						4'h7: DATA_OUT[71:64] <= 8'h37;
						4'h8: DATA_OUT[71:64] <= 8'h38;
						4'h9: DATA_OUT[71:64] <= 8'h39;
						4'hA: DATA_OUT[71:64] <= 8'h41;
						4'hB: DATA_OUT[71:64] <= 8'h42;
						4'hC: DATA_OUT[71:64] <= 8'h43;
						4'hD: DATA_OUT[71:64] <= 8'h44;
						4'hE: DATA_OUT[71:64] <= 8'h45;
						4'hF: DATA_OUT[71:64] <= 8'h46;
					endcase
					case (DATA_IN[31:28])
						4'h0: DATA_OUT[79:72] <= 8'h30;
						4'h1: DATA_OUT[79:72] <= 8'h31;
						4'h2: DATA_OUT[79:72] <= 8'h32;
						4'h3: DATA_OUT[79:72] <= 8'h33;
						4'h4: DATA_OUT[79:72] <= 8'h34;
						4'h5: DATA_OUT[79:72] <= 8'h35;
						4'h6: DATA_OUT[79:72] <= 8'h36;
						4'h7: DATA_OUT[79:72] <= 8'h37;
						4'h8: DATA_OUT[79:72] <= 8'h38;
						4'h9: DATA_OUT[79:72] <= 8'h39;
						4'hA: DATA_OUT[79:72] <= 8'h41;
						4'hB: DATA_OUT[79:72] <= 8'h42;
						4'hC: DATA_OUT[79:72] <= 8'h43;
						4'hD: DATA_OUT[79:72] <= 8'h44;
						4'hE: DATA_OUT[79:72] <= 8'h45;
						4'hF: DATA_OUT[79:72] <= 8'h46;
					endcase
					DATA_OUT[15:0] <= 16'h0A3E;
				end
				3'b010: begin
					DATA_OUT[79:64] <= 16'h4F4B;
					DATA_OUT[63:48] <= 16'h0A3E;
				end
				3'b001: begin
					DATA_OUT[79:48] <= 32'h4641_494C;
					DATA_OUT[47:32] <= 16'h0A3E;
				end
			endcase
			STATE_R_OUT <= STATE_R;
			OK_OUT 		<= OK;
			FAIL_OUT 	<= FAIL;
		end
	end

endmodule