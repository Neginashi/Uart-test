`timescale 1ns / 1ps

module FPGA_TOP(
	input	wire		CLK_50M,	
	input	wire		DATA_PC_EN,
	input	wire		DATA_PC_IN,

	output 	wire			FPGA_OUT,
	output 	wire			FPGA_DONE,
	output 	wire			FPGA_BUSY
	);


	wire [7:0] 	RX_OUT_DATA;
	wire 	 	RX_OUT_DONE;

	UART_RX UART_RX(
		//input
		.CLK	(CLK_50M),	
		.RX_EN	(DATA_PC_EN),
		.RX_IN	(DATA_PC_IN),

		//output
		.RX_OUT	(RX_OUT_DATA),
		.DONE 	(RX_OUT_DONE)
		);


	wire [15:0] PRO_RX_ADDR;
	wire [63:0] PRO_RX_DATA;
	wire  		PRO_RX_STATE_R;
	wire  		PRO_RX_STATE_W;
	wire  		PRO_RX_FAIL;
	wire 		PRO_RX_DONE;
	
	UART_PRO_RX UART_PRO_RX(
		//input
		.CLK 		(CLK_50M),
		.DATA_EN 	(DATA_PC_EN),
		.DATA_IN 	(RX_OUT_DATA),
		.START 		(RX_OUT_DONE),

		//output
		.STATE_R		(PRO_RX_STATE_R),
		.STATE_W		(PRO_RX_STATE_W),
		.ADDR			(PRO_RX_ADDR),
		.DATA 			(PRO_RX_DATA),
		.FAIL 			(PRO_RX_FAIL),
		.OUTPUT_DONE 	(PRO_RX_DONE)
		);


	wire  		UART_DEC_STATE_R;
	wire  		UART_DEC_STATE_W;
	wire  		UART_DEC_FAIL;
	wire [7:0] 	UART_DEC_ADDR;
	wire [31:0] UART_DEC_DATA;
	wire 		UART_DEC_DONE;

	UART_DEC UART_DEC(
		//input
		.CLK 			(CLK_50M),
		.DATA_EN 		(DATA_PC_EN),
		.STATE_R_IN 	(PRO_RX_STATE_R),
		.STATE_W_IN 	(PRO_RX_STATE_W),
		.ADDR_IN 		(PRO_RX_ADDR),
		.DATA_IN 		(PRO_RX_DATA),
		.FAIL_IN 		(PRO_RX_FAIL),
		.START 			(PRO_RX_DONE),

		//output
		.STATE_R_OUT 	(UART_DEC_STATE_R),
		.STATE_W_OUT 	(UART_DEC_STATE_W),
		.ADDR_OUT 		(UART_DEC_ADDR),
		.DATA_OUT 		(UART_DEC_DATA),
		.FAIL_OUT 		(UART_DEC_FAIL),
		.DONE 			(UART_DEC_DONE)
		);


	wire  		UART_REG_STATE_R;
	wire  		UART_REG_FAIL;
	wire 	 	UART_REG_OK;
	wire [31:0] UART_REG_DATA;
	wire 	 	UART_REG_DONE;

	UART_REG UART_REG(
		//input
		.CLK 			(CLK_50M),
		.DATA_EN 		(DATA_PC_EN),
		.STATE_R 		(UART_DEC_STATE_R),
		.STATE_W 		(UART_DEC_STATE_W),
		.ADDR 			(UART_DEC_ADDR),
		.DATA_IN 		(UART_DEC_DATA),
		.STATE_FAIL 	(UART_DEC_FAIL),
		.START 			(UART_DEC_DONE),

		//output
		.DATA_OUT 		(UART_REG_DATA),
		.STATE_R_OUT 	(UART_REG_STATE_R),
		.FAIL_OUT 		(UART_REG_FAIL),
		.OK 			(UART_REG_OK),
		.DONE 			(UART_REG_DONE)
		);

	wire  		UART_ENC_STATE_R;
	wire  		UART_ENC_FAIL;
	wire 	 	UART_ENC_OK;
	wire 		UART_ENC_DONE;
	wire [79:0] UART_ENC_DATA;

	UART_ENC UART_ENC(
	//input 			
	.CLK 				(CLK_50M),
	.DATA_EN 			(DATA_PC_EN),
	.DATA_IN 			(UART_REG_DATA),
	.FAIL 				(UART_REG_FAIL),				
	.OK 				(UART_REG_OK),
	.STATE_R 			(UART_REG_STATE_R),
	.START 				(UART_REG_DONE),

	//output
	.DATA_OUT 			(UART_ENC_DATA),
	.FAIL_OUT 			(UART_ENC_FAIL),
	.OK_OUT 			(UART_ENC_OK),
	.DONE 				(UART_ENC_DONE),
	.STATE_R_OUT 		(UART_ENC_STATE_R)
	);


	wire 		UART_PRO_START;
	wire [7:0] 	UART_PRO_TX_DATA;

	UART_PRO_TX UART_PRO_TX(
	//input
	.CLK 				(CLK_50M),
	.DATA_EN 			(DATA_PC_EN),
	.DATA_IN 			(UART_ENC_DATA),
	.FAIL 				(UART_ENC_FAIL),				
	.OK 				(UART_ENC_OK),
	.STATE_R 			(UART_ENC_STATE_R),
	.START 				(UART_ENC_DONE),

	//output
	.DATA_OUT 			(UART_PRO_TX_DATA),
	.START_OUT 			(UART_PRO_START)
	);

	UART_TX UART_TX(
		//input
		.CLK 			(CLK_50M),
		.TX_EN 			(DATA_PC_EN),
		.START 			(UART_PRO_START),
		.TX_IN 			(UART_PRO_TX_DATA),

		//output
		.OUT 			(FPGA_OUT),
		.DONE 			(FPGA_DONE),
		.BUSY 			(FPGA_BUSY)
		);

endmodule