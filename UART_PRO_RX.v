`timescale 1ns / 1ps

module UART_PRO_RX (
	input 				CLK,
	input 				DATA_EN,
	input [7:0]			DATA_IN,
	input 				START,

	output reg			STATE_R,
	output reg			STATE_W,
	output reg [15:0]	ADDR,
	output reg [63:0]	DATA,
	output reg			FAIL,
	output reg 			OUTPUT_DONE
	);

	reg [119:0]	FULL_DATA;
	reg 		FAIL_ADDR;
	reg 		FAIL_DATA;
	reg 		DONE;
	reg [3:0] 	DATA_CNT;
	reg [2:0] 	STATE;

	wire [15:0]	STATE_DATA_W;
	wire [15:0]	STATE_DATA_R;
	wire [23:0]	ADDR_DATA;
	wire [63:0]	DATA_DATA;
	wire [15:0]	ENTER;

	assign STATE_DATA_W = FULL_DATA[119:104];
	assign STATE_DATA_R = FULL_DATA[47:32];
	assign ADDR_DATA 	= FULL_DATA[103:80];
	assign DATA_DATA 	= FULL_DATA[79:16];
	assign ENTER 		= FULL_DATA[15:0];

	initial begin
		STATE_R 	<= 1'b0;
		STATE_W 	<= 1'b0;
		ADDR 		<= 16'h0;
		DATA 		<= 64'h0;
		FAIL		<= 1'b0;
		FAIL_ADDR 	<= 1'b0;
		FAIL_DATA 	<= 1'b0;
		FULL_DATA	<= 120'h0;
		DONE 		<= 1'b0;
		DATA_CNT 	<= 4'b0;
		STATE 		<= 2'b001;
		OUTPUT_DONE <= 1'b0;
	end

	parameter IDLE 			= 3'b001;
	parameter BEGIN 		= 3'b010;
	parameter WRITE 		= 3'b011;
	parameter READ 			= 3'b100;
	parameter STATE_FAIL 	= 3'b101;
	parameter STOP 			= 3'b110;

	always @(posedge CLK) begin
		if (DATA_EN && START) begin
			FULL_DATA 	<= { FULL_DATA[111:0], DATA_IN };
			DATA_CNT 	<= DATA_CNT + 4'b1;
			if (DATA_CNT == 4'b1110) begin
				DONE 		<= 1'b1;
				DATA_CNT 	<= 4'b0; 
			end
		end
		case (STATE)
			IDLE: begin
				if (DONE) begin
					STATE 		<= BEGIN;
				end
				else begin
					STATE_R 	<= 1'b0;
					STATE_W 	<= 1'b0;
					ADDR 		<= 16'h0;
					DATA 		<= 64'h0;
					FAIL		<= 1'b0;
					FAIL_ADDR 	<= 1'b0;
					FAIL_DATA 	<= 1'b0;
					OUTPUT_DONE <= 1'b0;
					STATE 		<= IDLE;
				end
			end

			BEGIN: begin
				if ((STATE_DATA_W == 16'h5720) && (ADDR_DATA[7:0] == 16'h20) && (ENTER == 16'h0D0A)) begin
					STATE <= WRITE;
				end
				else if ((STATE_DATA_R == 16'h5220) && (ENTER == 16'h0D0A)) begin
					STATE <= READ;
				end
				else begin
					STATE 	<= STATE_FAIL;
				end	
			end

			WRITE: begin
				FAIL_ADDR 	<= 	!((((ADDR_DATA[23:16] >= 8'h30) && (ADDR_DATA[23:16] <= 8'h39))  ||
								   ((ADDR_DATA[23:16] >= 8'h41) && (ADDR_DATA[23:16] <= 8'h46))) &&
								  (((ADDR_DATA[15:8]  >= 8'h30) && (ADDR_DATA[15:8]	 <= 8'h39))  ||
								   ((ADDR_DATA[15:8]  >= 8'h41) && (ADDR_DATA[15:8]	 <= 8'h46))));
				FAIL_DATA 	<= 	!((((DATA_DATA[63:56] >= 8'h30) && (DATA_DATA[63:56] <= 8'h39))  ||
								   ((DATA_DATA[63:56] >= 8'h41) && (DATA_DATA[63:56] <= 8'h46))) &&
								  (((DATA_DATA[55:48] >= 8'h30) && (DATA_DATA[55:48] <= 8'h39))  ||
								   ((DATA_DATA[55:48] >= 8'h41) && (DATA_DATA[55:48] <= 8'h46))) &&
								  (((DATA_DATA[47:40] >= 8'h30) && (DATA_DATA[47:40] <= 8'h39))  ||
								   ((DATA_DATA[47:40] >= 8'h41) && (DATA_DATA[47:40] <= 8'h46))) &&
								  (((DATA_DATA[39:32] >= 8'h30) && (DATA_DATA[39:32] <= 8'h39))  ||
								   ((DATA_DATA[39:32] >= 8'h41) && (DATA_DATA[39:32] <= 8'h46))) &&
								  (((DATA_DATA[31:24] >= 8'h30) && (DATA_DATA[31:24] <= 8'h39))  ||
								   ((DATA_DATA[31:24] >= 8'h41) && (DATA_DATA[31:24] <= 8'h46))) &&
								  (((DATA_DATA[23:16] >= 8'h30) && (DATA_DATA[23:16] <= 8'h39))  ||
								   ((DATA_DATA[23:16] >= 8'h41) && (DATA_DATA[23:16] <= 8'h46))) &&
								  (((DATA_DATA[15:8]  >= 8'h30) && (DATA_DATA[15:8]  <= 8'h39))  ||
								   ((DATA_DATA[15:8]  >= 8'h41) && (DATA_DATA[15:8]  <= 8'h46))) &&
								  (((DATA_DATA[7:0]   >= 8'h30) && (DATA_DATA[7:0]   <= 8'h39))  ||
								   ((DATA_DATA[7:0]   >= 8'h41) && (DATA_DATA[7:0]   <= 8'h46))));
				FAIL 		<= 	FAIL_DATA || FAIL_ADDR;
				if (!FAIL) begin
					STATE_W 	<= 1'b1;
					STATE_R 	<= 1'b0;
					FAIL 		<= 1'b0;
					ADDR 		<= ADDR_DATA[23:8];
					DATA 		<= DATA_DATA;
					OUTPUT_DONE <= 1'b1;
					STATE 		<= STOP;
				end
				else begin
					STATE 		<= STATE_FAIL;
				end
			end

			READ: begin
				FAIL <= 	!((((ADDR_DATA[23:16] >= 8'h30) && (ADDR_DATA[23:16] <= 8'h39))  ||
							   ((ADDR_DATA[23:16] >= 8'h41) && (ADDR_DATA[23:16] <= 8'h46))) &&
							  (((ADDR_DATA[15:8]  >= 8'h30) && (ADDR_DATA[15:8]  <= 8'h39))  ||
							   ((ADDR_DATA[15:8]  >= 8'h41) && (ADDR_DATA[15:8]  <= 8'h46))));
				if (!FAIL) begin
					STATE_W 	<= 1'b0;
					STATE_R 	<= 1'b1;
					FAIL 		<= 1'b0;
					ADDR 		<= ADDR_DATA[23:8];
					OUTPUT_DONE <= 1'b1;
					STATE 		<= STOP;
				end
				else begin
					STATE <= STATE_FAIL;
				end
			end

			STATE_FAIL: begin
				STATE_W 	<= 1'b0;
				STATE_R 	<= 1'b0;
				OUTPUT_DONE <= 1'b1;
				STATE 		<= STOP;
				FAIL 		<= 1'b1;
			end

			STOP: begin
				STATE_R 	<= 1'b0;
				STATE_W 	<= 1'b0;
				ADDR 		<= 16'h0;
				DATA 		<= 64'h0;
				FAIL		<= 1'b0;
				FAIL_ADDR 	<= 1'b0;
				FAIL_DATA 	<= 1'b0;
				DONE 		<= 1'b0;
				OUTPUT_DONE <= 1'b0;
				STATE 		<= IDLE;
			end

			default: begin
				STATE <= IDLE;
			end
		endcase
	end

endmodule
