module UART_TX (
    input  wire         CLK,
    input  wire         TX_EN,
    input  wire         START,
    input  wire [7:0]   TX_IN,
    output reg          TX_OUT,
    output reg          DONE,
    output reg          BUSY
);

    reg [2:0]   STATE   = 3'b001;
    reg [7:0]   DATA_TX = 8'b0;
    reg [2:0]   BIT_IDX = 3'b0;
    
    // STATEs of STATE machine
    reg [2:0]   RESET       = 3'b001;
    reg [2:0]   IDLE        = 3'b010;
    reg [2:0]   START_BIT   = 3'b011;
    reg [2:0]   DATA_BITS   = 3'b100;
    reg [2:0]   STOP_BIT    = 3'b101;

    assign IDX = BIT_IDX;

    always @(posedge CLK) begin
        case (STATE)
            default: begin
                STATE   <= IDLE;
            end
            
            IDLE: begin
                TX_OUT  <= 1'b1;
                DONE    <= 1'b0;
                BUSY    <= 1'b0;
                BIT_IDX <= 3'b0;
                DATA_TX <= 8'b0;
                if (START & TX_EN) begin
                    DATA_TX <= TX_IN;
                    STATE   <= START_BIT;
                end
            end
            
            START_BIT: begin
                TX_OUT  <= 1'b0;
                BUSY    <= 1'b1;
                STATE   <= DATA_BITS;
            end
            
            DATA_BITS: begin
                TX_OUT     <= DATA_TX[BIT_IDX];
                if (&BIT_IDX) begin
                    BIT_IDX <= 3'b0;
                    STATE   <= STOP_BIT;
                end
                else begin
                    BIT_IDX <= BIT_IDX + 1'b1;
                end
            end
            
            STOP_BIT: begin
                DONE    <= 1'b1;
                DATA_TX <= 8'b0;
                STATE   <= IDLE;
            end
        endcase
    end

endmodule