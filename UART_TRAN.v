module UART_TRAN (
	input 				CLK,
	input 				DATA_EN,
	input [7:0]			DATA_IN,

	output reg			STATE_R,
	output reg			STATE_W,
	output reg [7:0]	ADDR,
	output reg [31:0]	DATA,
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
				STATE_W <= 1;
				STATE_R <= 0;
				if ((ADDR_DATA[7:0] == 16'h20) && (ENTER_W == 16'h0D0A)) begin
					//ADDR STATE MACHINE------------------------------------
					case (ADDR_DATA[23:16])
						8'h30: ADDR[7:4] <= 4'h0;
						8'h31: ADDR[7:4] <= 4'h1;
						8'h32: ADDR[7:4] <= 4'h2;
						8'h33: ADDR[7:4] <= 4'h3;
						8'h34: ADDR[7:4] <= 4'h4;
						8'h35: ADDR[7:4] <= 4'h5;
						8'h36: ADDR[7:4] <= 4'h6;
						8'h37: ADDR[7:4] <= 4'h7;
						8'h38: ADDR[7:4] <= 4'h8;
						8'h39: ADDR[7:4] <= 4'h9;
						8'h41: ADDR[7:4] <= 4'hA;
						8'h42: ADDR[7:4] <= 4'hB;
						8'h43: ADDR[7:4] <= 4'hC;
						8'h44: ADDR[7:4] <= 4'hD;
						8'h45: ADDR[7:4] <= 4'hE;
						8'h46: ADDR[7:4] <= 4'hF;
						default: FAIL_ADDR[1] <= 1'b1;
					endcase
					case (ADDR_DATA[15:7])
						8'h30: ADDR[3:0] <= 4'h0;
						8'h31: ADDR[3:0] <= 4'h1;
						8'h32: ADDR[3:0] <= 4'h2;
						8'h33: ADDR[3:0] <= 4'h3;
						8'h34: ADDR[3:0] <= 4'h4;
						8'h35: ADDR[3:0] <= 4'h5;
						8'h36: ADDR[3:0] <= 4'h6;
						8'h37: ADDR[3:0] <= 4'h7;
						8'h38: ADDR[3:0] <= 4'h8;
						8'h39: ADDR[3:0] <= 4'h9;
						8'h41: ADDR[3:0] <= 4'hA;
						8'h42: ADDR[3:0] <= 4'hB;
						8'h43: ADDR[3:0] <= 4'hC;
						8'h44: ADDR[3:0] <= 4'hD;
						8'h45: ADDR[3:0] <= 4'hE;
						8'h46: ADDR[3:0] <= 4'hF;
						default: FAIL_ADDR[0] <= 1'b1;
					endcase
					//DATA STATE MACHINE--------------------------------
					case (DATA_DATA[7:0])
						8'h30: DATA[3:0] <= 4'h0;
						8'h31: DATA[3:0] <= 4'h1;
						8'h32: DATA[3:0] <= 4'h2;
						8'h33: DATA[3:0] <= 4'h3;
						8'h34: DATA[3:0] <= 4'h4;
						8'h35: DATA[3:0] <= 4'h5;
						8'h36: DATA[3:0] <= 4'h6;
						8'h37: DATA[3:0] <= 4'h7;
						8'h38: DATA[3:0] <= 4'h8;
						8'h39: DATA[3:0] <= 4'h9;
						8'h41: DATA[3:0] <= 4'hA;
						8'h42: DATA[3:0] <= 4'hB;
						8'h43: DATA[3:0] <= 4'hC;
						8'h44: DATA[3:0] <= 4'hD;
						8'h45: DATA[3:0] <= 4'hE;
						8'h46: DATA[3:0] <= 4'hF;
						default: FAIL_DATA[0] <= 1'b1;
					endcase
					case (DATA_DATA[15:8])
						8'h30: DATA[7:4] <= 4'h0;
						8'h31: DATA[7:4] <= 4'h1;
						8'h32: DATA[7:4] <= 4'h2;
						8'h33: DATA[7:4] <= 4'h3;
						8'h34: DATA[7:4] <= 4'h4;
						8'h35: DATA[7:4] <= 4'h5;
						8'h36: DATA[7:4] <= 4'h6;
						8'h37: DATA[7:4] <= 4'h7;
						8'h38: DATA[7:4] <= 4'h8;
						8'h39: DATA[7:4] <= 4'h9;
						8'h41: DATA[7:4] <= 4'hA;
						8'h42: DATA[7:4] <= 4'hB;
						8'h43: DATA[7:4] <= 4'hC;
						8'h44: DATA[7:4] <= 4'hD;
						8'h45: DATA[7:4] <= 4'hE;
						8'h46: DATA[7:4] <= 4'hF;
						default: FAIL_DATA[1] <= 1'b1;
					endcase
					case (DATA_DATA[23:16])
						8'h30: DATA[11:8] <= 4'h0;
						8'h31: DATA[11:8] <= 4'h1;
						8'h32: DATA[11:8] <= 4'h2;
						8'h33: DATA[11:8] <= 4'h3;
						8'h34: DATA[11:8] <= 4'h4;
						8'h35: DATA[11:8] <= 4'h5;
						8'h36: DATA[11:8] <= 4'h6;
						8'h37: DATA[11:8] <= 4'h7;
						8'h38: DATA[11:8] <= 4'h8;
						8'h39: DATA[11:8] <= 4'h9;
						8'h41: DATA[11:8] <= 4'hA;
						8'h42: DATA[11:8] <= 4'hB;
						8'h43: DATA[11:8] <= 4'hC;
						8'h44: DATA[11:8] <= 4'hD;
						8'h45: DATA[11:8] <= 4'hE;
						8'h46: DATA[11:8] <= 4'hF;
						default: FAIL_DATA[2] <= 1'b1;
					endcase
					case (DATA_DATA[31:24])
						8'h30: DATA[15:12] <= 4'h0;
						8'h31: DATA[15:12] <= 4'h1;
						8'h32: DATA[15:12] <= 4'h2;
						8'h33: DATA[15:12] <= 4'h3;
						8'h34: DATA[15:12] <= 4'h4;
						8'h35: DATA[15:12] <= 4'h5;
						8'h36: DATA[15:12] <= 4'h6;
						8'h37: DATA[15:12] <= 4'h7;
						8'h38: DATA[15:12] <= 4'h8;
						8'h39: DATA[15:12] <= 4'h9;
						8'h41: DATA[15:12] <= 4'hA;
						8'h42: DATA[15:12] <= 4'hB;
						8'h43: DATA[15:12] <= 4'hC;
						8'h44: DATA[15:12] <= 4'hD;
						8'h45: DATA[15:12] <= 4'hE;
						8'h46: DATA[15:12] <= 4'hF;
						default: FAIL_DATA[3] <= 1'b1;
					endcase
					case (DATA_DATA[39:32])
						8'h30: DATA[19:16] <= 4'h0;
						8'h31: DATA[19:16] <= 4'h1;
						8'h32: DATA[19:16] <= 4'h2;
						8'h33: DATA[19:16] <= 4'h3;
						8'h34: DATA[19:16] <= 4'h4;
						8'h35: DATA[19:16] <= 4'h5;
						8'h36: DATA[19:16] <= 4'h6;
						8'h37: DATA[19:16] <= 4'h7;
						8'h38: DATA[19:16] <= 4'h8;
						8'h39: DATA[19:16] <= 4'h9;
						8'h41: DATA[19:16] <= 4'hA;
						8'h42: DATA[19:16] <= 4'hB;
						8'h43: DATA[19:16] <= 4'hC;
						8'h44: DATA[19:16] <= 4'hD;
						8'h45: DATA[19:16] <= 4'hE;
						8'h46: DATA[19:16] <= 4'hF;
						default: FAIL_DATA[4] <= 1'b1;
					endcase
					case (DATA_DATA[47:40])
						8'h30: DATA[23:20] <= 4'h0;
						8'h31: DATA[23:20] <= 4'h1;
						8'h32: DATA[23:20] <= 4'h2;
						8'h33: DATA[23:20] <= 4'h3;
						8'h34: DATA[23:20] <= 4'h4;
						8'h35: DATA[23:20] <= 4'h5;
						8'h36: DATA[23:20] <= 4'h6;
						8'h37: DATA[23:20] <= 4'h7;
						8'h38: DATA[23:20] <= 4'h8;
						8'h39: DATA[23:20] <= 4'h9;
						8'h41: DATA[23:20] <= 4'hA;
						8'h42: DATA[23:20] <= 4'hB;
						8'h43: DATA[23:20] <= 4'hC;
						8'h44: DATA[23:20] <= 4'hD;
						8'h45: DATA[23:20] <= 4'hE;
						8'h46: DATA[23:20] <= 4'hF;
						default: FAIL_DATA[5] <= 1'b1;
					endcase
					case (DATA_DATA[55:48])
						8'h30: DATA[27:24] <= 4'h0;
						8'h31: DATA[27:24] <= 4'h1;
						8'h32: DATA[27:24] <= 4'h2;
						8'h33: DATA[27:24] <= 4'h3;
						8'h34: DATA[27:24] <= 4'h4;
						8'h35: DATA[27:24] <= 4'h5;
						8'h36: DATA[27:24] <= 4'h6;
						8'h37: DATA[27:24] <= 4'h7;
						8'h38: DATA[27:24] <= 4'h8;
						8'h39: DATA[27:24] <= 4'h9;
						8'h41: DATA[27:24] <= 4'hA;
						8'h42: DATA[27:24] <= 4'hB;
						8'h43: DATA[27:24] <= 4'hC;
						8'h44: DATA[27:24] <= 4'hD;
						8'h45: DATA[27:24] <= 4'hE;
						8'h46: DATA[27:24] <= 4'hF;
						default: FAIL_DATA[6] <= 1'b1;
					endcase
					case (DATA_DATA[63:56])
						8'h30: DATA[31:28] <= 4'h0;
						8'h31: DATA[31:28] <= 4'h1;
						8'h32: DATA[31:28] <= 4'h2;
						8'h33: DATA[31:28] <= 4'h3;
						8'h34: DATA[31:28] <= 4'h4;
						8'h35: DATA[31:28] <= 4'h5;
						8'h36: DATA[31:28] <= 4'h6;
						8'h37: DATA[31:28] <= 4'h7;
						8'h38: DATA[31:28] <= 4'h8;
						8'h39: DATA[31:28] <= 4'h9;
						8'h41: DATA[31:28] <= 4'hA;
						8'h42: DATA[31:28] <= 4'hB;
						8'h43: DATA[31:28] <= 4'hC;
						8'h44: DATA[31:28] <= 4'hD;
						8'h45: DATA[31:28] <= 4'hE;
						8'h46: DATA[31:28] <= 4'hF;
						default: FAIL_DATA[7] <= 1'b1;
					endcase
					FAIL <= |FAIL_DATA || |FAIL_ADDR;
				end
				else begin
					FAIL <= 1'b1;
				end
			end
			else if ( STATE_DATA == 16'h5220 ) begin
				STATE_W <= 0;
				STATE_R <= 1;
				if (ENTER_R == 16'h0D0A) begin
					//ADDR STATE MACHINE------------------------------------
					case (ADDR_DATA[23:16])
						8'h30: ADDR[7:4] <= 4'h0;
						8'h31: ADDR[7:4] <= 4'h1;
						8'h32: ADDR[7:4] <= 4'h2;
						8'h33: ADDR[7:4] <= 4'h3;
						8'h34: ADDR[7:4] <= 4'h4;
						8'h35: ADDR[7:4] <= 4'h5;
						8'h36: ADDR[7:4] <= 4'h6;
						8'h37: ADDR[7:4] <= 4'h7;
						8'h38: ADDR[7:4] <= 4'h8;
						8'h39: ADDR[7:4] <= 4'h9;
						8'h41: ADDR[7:4] <= 4'hA;
						8'h42: ADDR[7:4] <= 4'hB;
						8'h43: ADDR[7:4] <= 4'hC;
						8'h44: ADDR[7:4] <= 4'hD;
						8'h45: ADDR[7:4] <= 4'hE;
						8'h46: ADDR[7:4] <= 4'hF;
						default: FAIL_ADDR[1] <= 1'b1;
					endcase
					case (ADDR_DATA[15:7])
						8'h30: ADDR[3:0] <= 4'h0;
						8'h31: ADDR[3:0] <= 4'h1;
						8'h32: ADDR[3:0] <= 4'h2;
						8'h33: ADDR[3:0] <= 4'h3;
						8'h34: ADDR[3:0] <= 4'h4;
						8'h35: ADDR[3:0] <= 4'h5;
						8'h36: ADDR[3:0] <= 4'h6;
						8'h37: ADDR[3:0] <= 4'h7;
						8'h38: ADDR[3:0] <= 4'h8;
						8'h39: ADDR[3:0] <= 4'h9;
						8'h41: ADDR[3:0] <= 4'hA;
						8'h42: ADDR[3:0] <= 4'hB;
						8'h43: ADDR[3:0] <= 4'hC;
						8'h44: ADDR[3:0] <= 4'hD;
						8'h45: ADDR[3:0] <= 4'hE;
						8'h46: ADDR[3:0] <= 4'hF;
						default: FAIL_ADDR[0] <= 1'b1;
					endcase
					FAIL <= |FAIL_ADDR;
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
