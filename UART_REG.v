module UART_REG(
	input 				CLK,
	input 				STATE_R,
	input 				STATE_W,
	input		[7:0]	ADDR,
	input 	 	[31:0]	DATA_IN,
	input 				STATE_FAIL,

	output 	 	[7:0]	OUT
	);

	reg [31:0]	FAIL 		= 32'h4641_494C;
	reg [15:0] 	OK			= 16'h4F4B;
	reg [2:0] 	COUNT_DATA 	= 3'b0;
	reg [1:0] 	COUNT_FAIL 	= 2'b0;
	reg 	 	COUNT_OK 	= 1'b0;

	reg [7:0] 	REGISTER [31:0];


	always @(posedge CLK) begin
		if (!STATE_FAIL) begin
			if (STATE_W) begin
				REGISTER[ADDR] <= DATA_IN;
				if (COUNT_OK <= 1'd1) begin
					OUT 		<= OK[7:0];
					OK 			<= OK >> 8;
					COUNT_OK 	<= COUNT_OK + 1'b1;
				end
				else begin
					OK 			<= 16'h4F4B;
					COUNT_OK 	<= 1'b0;
				end
			end
			else if (STATE_R) begin
				if (COUNT_DATA <= 3'd7) begin
					
				end
				OUT <= REGISTER[ADDR];
			end
		end
		else if (STATE_FAIL) begin
			if (COUNT_FAIL <= 2'd3) begin
				OUT 		<= FAIL[7:0];
				FAIL 		<= FAIL >> 8;
				COUNT_FAIL 	<= COUNT_FAIL + 2'b1;
			end
			else begin
				FAIL 		<= 32'h4641_494C;
				COUNT_FAIL 	<= 2'b0;
			end
		end
	end

endmodule