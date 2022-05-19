`timescale 1ns / 1ps

module UART_PRO_RX (
	input 				CLK,
	input 				DATA_EN,
	input [7:0]			DATA_IN,

	output reg			STATE_R,
	output reg			STATE_W,
	output reg [15:0]	ADDR,
	output reg [63:0]	DATA,
	output reg			FAIL
	);

	reg [119:0]	FULL_DATA;
	reg [1:0]	FAIL_ADDR;
	reg [7:0]	FAIL_DATA;
	reg			FAIL;

	wire [15:0]	STATE_DATA;
	wire [23:0]	ADDR_DATA;
	wire [63:0]	DATA_DATA;
	wire [15:0]	ENTER_W;
	wire [15:0]	ENTER_R;

	assign STATE_DATA 	= FULL_DATA[119:112];
	assign ADDR_DATA 	= FULL_DATA[103:80];
	assign DATA_DATA 	= FULL_DATA[79:16];
	assign ENTER_W 		= FULL_DATA[15:0];
	assign ENTER_R 		= FULL_DATA[87:72];

	initial begin
		FAIL		<= 1'b0;
		FAIL_ADDR 	<= 2'b0;
		FAIL_DATA 	<= 8'b0;
		FULL_DATA	<= 120'h0;
	end

	always @(posedge CLK) begin
		if (DATA_EN) begin
			FULL_DATA <= { DATA_IN, FULL_DATA[119:8] };
			if (STATE_DATA == 16'h5720) begin
				STATE_W <= 1'b1;
				STATE_R <= 1'b0;
				if ((ADDR_DATA[7:0] == 16'h20) && (ENTER_W == 16'h0D0A)) begin
					FAIL_ADDR 	<= 	!((ADDR_DATA[23:16]	>= 8'h30) &&
									(ADDR_DATA[23:16]	<= 8'h39) &&
									(ADDR_DATA[23:16]	>= 8'h41) &&
									(ADDR_DATA[23:16]	<= 8'h46) &&
									(ADDR_DATA[15:8]	>= 8'h30) &&
									(ADDR_DATA[15:8]	<= 8'h39) &&
									(ADDR_DATA[15:8]	>= 8'h41) &&
									(ADDR_DATA[15:8]	<= 8'h46));
					FAIL_DATA 	<= 	!((DATA_DATA[63:56] >= 8'h30) &&
									(DATA_DATA[63:56] 	<= 8'h39) &&
									(DATA_DATA[63:56] 	>= 8'h41) &&
									(DATA_DATA[63:56] 	<= 8'h46) &&
									(DATA_DATA[55:48] 	>= 8'h30) &&
									(DATA_DATA[55:48] 	<= 8'h39) &&
									(DATA_DATA[55:48] 	>= 8'h41) &&
									(DATA_DATA[55:48] 	<= 8'h46) &&
									(DATA_DATA[47:40] 	>= 8'h30) &&
									(DATA_DATA[47:40] 	<= 8'h39) &&
									(DATA_DATA[47:40] 	>= 8'h41) &&
									(DATA_DATA[47:40] 	<= 8'h46) &&
									(DATA_DATA[39:32] 	>= 8'h30) &&
									(DATA_DATA[39:32] 	<= 8'h39) &&
									(DATA_DATA[39:32] 	>= 8'h41) &&
									(DATA_DATA[39:32] 	<= 8'h46) &&
									(DATA_DATA[31:24] 	>= 8'h30) &&
									(DATA_DATA[31:24] 	<= 8'h39) &&
									(DATA_DATA[31:24] 	>= 8'h41) &&
									(DATA_DATA[31:24] 	<= 8'h46) &&
									(DATA_DATA[23:16] 	>= 8'h30) &&
									(DATA_DATA[23:16] 	<= 8'h39) &&
									(DATA_DATA[23:16] 	>= 8'h41) &&
									(DATA_DATA[23:16] 	<= 8'h46) &&
									(DATA_DATA[15:8] 	>= 8'h30) &&
									(DATA_DATA[15:8] 	<= 8'h39) &&
									(DATA_DATA[15:8] 	>= 8'h41) &&
									(DATA_DATA[15:8] 	<= 8'h46) &&
									(DATA_DATA[7:0]  	>= 8'h30) &&
									(DATA_DATA[7:0]  	<= 8'h39) &&
									(DATA_DATA[7:0]  	>= 8'h41) &&
									(DATA_DATA[7:0]  	<= 8'h46));
					FAIL 		<= 	FAIL_DATA || FAIL_ADDR;
					if (!FAIL) begin
						ADDR <= ADDR_DATA[23:16];
						DATA <= DATA_DATA;
					end
				end
				else begin
					FAIL <= 1'b1;
				end
			end
			else if ( STATE_DATA == 16'h5220 ) begin
				STATE_W <= 1'b0;
				STATE_R <= 1'b1;
				if (ENTER_R == 16'h0D0A) begin
					FAIL <= 	!((ADDR_DATA[23:16] >= 8'h30) &&
								(ADDR_DATA[23:16] 	<= 8'h39) &&
								(ADDR_DATA[23:16] 	>= 8'h41) &&
								(ADDR_DATA[23:16] 	<= 8'h46) &&
								(ADDR_DATA[15:8]  	>= 8'h30) &&
								(ADDR_DATA[15:8]  	<= 8'h39) &&
								(ADDR_DATA[15:8]  	>= 8'h41) &&
								(ADDR_DATA[15:8]  	<= 8'h46));
					if (!FAIL) begin
						ADDR <= ADDR_DATA[23:8];
					end
				end
				else begin
					FAIL <= 1'b1;
				end
			end
			else begin
				FAIL <= 1'b1;
			end
		end
	end

endmodule
