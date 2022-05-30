`timescale 1ns / 1ps

module UART_ENC(
	input wire			CLK,
	input wire			RST,
	input wire 	[31:0]	DATA_IN,
	input wire			FAIL,
	input wire			OK,
	input wire			STATE_R,
	input wire			START,


	output reg 	[79:0]	DATA_OUT,
	output reg			FAIL_OUT,
	output reg			OK_OUT,
	output reg			STATE_R_OUT,
	output reg 			DONE
	);
	
	reg [2:0] 	STATE;
	reg [31:0] 	DATA_BUF;
	//reg 		BEGIN;
	
	parameter IDLE 			= 3'b001;
	parameter STATE_DATA 	= 3'b010;
	parameter STATE_FAIL 	= 3'b011;
	parameter STATE_OK 		= 3'b100;
	parameter STOP 			= 3'b101;

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			DATA_BUF 	<= 32'b0;
			//BEGIN 		<= 1'b0;
		end
		else if (START) begin
			DATA_BUF 	<= DATA_IN;
			//BEGIN 		<= 1'b1;
		end
		else if (DONE) begin
			DATA_BUF 	<= 32'b0;
			//BEGIN 		<= 1'b0;
		end
		else begin
			DATA_BUF 	<= DATA_BUF;
		end
	end

	always @(posedge CLK or posedge RST) begin
		if (RST) begin
			// reset
			STATE 		<= IDLE;
			DATA_OUT 	<= 80'b0;
			FAIL_OUT	<= 1'b0;
			OK_OUT 		<= 1'b0;
			STATE_R_OUT <= 1'b0;
			STATE 		<= 3'b001;
			DONE 		<= 1'b0;
		end
		else begin
			case (STATE)
				IDLE: begin
					if (STATE_R) begin
						STATE <= STATE_DATA;
					end
					else if (OK) begin
						STATE <= STATE_OK;
					end
					else if (FAIL) begin
						STATE <= STATE_FAIL;
					end
					else begin
						STATE 		<= IDLE;
						DATA_OUT 	<= 80'b0;
						FAIL_OUT	<= 1'b0;
						OK_OUT 		<= 1'b0;
						STATE_R_OUT <= 1'b0;
						DONE 		<= 1'b0;
					end
				end

				STATE_DATA: begin
					case (DATA_BUF[3:0])
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
					case (DATA_BUF[7:4])
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
					case (DATA_BUF[11:8])
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
					case (DATA_BUF[15:12])
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
					case (DATA_BUF[19:16])
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
					case (DATA_BUF[23:20])
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
					case (DATA_BUF[27:24])
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
					case (DATA_BUF[31:28])
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
					DATA_OUT[15:0] 	<= 16'h0A3E;
					DONE 			<= 1'b1;
					STATE 			<= STOP;
					STATE_R_OUT 	<= 1'b1;
					OK_OUT 			<= 1'b0;
					FAIL_OUT 		<= 1'b0;
				end

				STATE_FAIL: begin
					DATA_OUT[79:48] <= 32'h4641_494C;
					DATA_OUT[47:32] <= 16'h0A3E;
					DONE 			<= 1'b1;
					STATE 			<= STOP;
					STATE_R_OUT 	<= 1'b0;
					OK_OUT 			<= 1'b0;
					FAIL_OUT 		<= 1'b1;
				end

				STATE_OK: begin
					DATA_OUT[79:64] <= 16'h4F4B;
					DATA_OUT[63:48] <= 16'h0A3E;
					DONE 			<= 1'b1;
					STATE 			<= STOP;
					STATE_R_OUT 	<= 1'b0;
					OK_OUT 			<= 1'b1;
					FAIL_OUT 		<= 1'b0;
				end

				STOP: begin
					STATE <= IDLE;
					DATA_OUT 	<= 80'b0;
					FAIL_OUT	<= 1'b0;
					OK_OUT 		<= 1'b0;
					STATE_R_OUT <= 1'b0;
					DONE 		<= 1'b0;
				end

				default: begin
					STATE <= IDLE;
				end
			endcase
		end
	end

endmodule
