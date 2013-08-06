module executor (
    input clk,
    input rst,

    input rx_packet_done,
    input rx_packet_error,
    input rx_buffer_valid,

    input [7:0] rx_payload_len,
    input [7:0] rx_buf0,
    input [7:0] rx_buf1,
    input [7:0] rx_buf2,
    input [7:0] rx_buf3,
    input [7:0] rx_buf4,
    input [7:0] rx_buf5,
    input [7:0] rx_buf6,
    input [7:0] rx_buf7,
    input [7:0] rx_buf8,
    input [7:0] rx_buf9,
    input [7:0] rx_buf10,
    input [7:0] rx_buf11,
    input [7:0] rx_buf12,
    input [7:0] rx_buf13,
    input [7:0] rx_buf14,
    input [7:0] rx_buf15,

    input tx_done,
    output reg tx_packet_wr,

    output reg [7:0] tx_payload_len,
    output reg [7:0] tx_buf0,
    output reg [7:0] tx_buf1,
    output reg [7:0] tx_buf2,
    output reg [7:0] tx_buf3,
    output reg [7:0] tx_buf4,
    output reg [7:0] tx_buf5,
    output reg [7:0] tx_buf6,
    output reg [7:0] tx_buf7,
    output reg [7:0] tx_buf8,
    output reg [7:0] tx_buf9,
    output reg [7:0] tx_buf10,
    output reg [7:0] tx_buf11,
    output reg [7:0] tx_buf12,
    output reg [7:0] tx_buf13,
    output reg [7:0] tx_buf14,
    output reg [7:0] tx_buf15,

    output reg [31:0] out_reg0,
    output reg [31:0] out_reg1,
    output reg [31:0] out_reg2,
    output reg [31:0] out_reg3,
    output reg [31:0] out_reg4,
    output reg [31:0] out_reg5,
    output reg [31:0] out_reg6,
    output reg [31:0] out_reg7,
    output reg [31:0] out_reg8,
    output reg [31:0] out_reg9,
    output reg [31:0] out_reg10,
    output reg [31:0] out_reg11,
    output reg [31:0] out_reg12,
    output reg [31:0] out_reg13,
    output reg [31:0] out_reg14,
    output reg [31:0] out_reg15,
    output reg [31:0] out_reg16,
    output reg [31:0] out_reg17,
    output reg [31:0] out_reg18,
    output reg [31:0] out_reg19,
    output reg [31:0] out_reg20,
    output reg [31:0] out_reg21,
    output reg [31:0] out_reg22,
    output reg [31:0] out_reg23,
    output reg [31:0] out_reg24,
    output reg [31:0] out_reg25,
    output reg [31:0] out_reg26,
    output reg [31:0] out_reg27,
    output reg [31:0] out_reg28,
    output reg [31:0] out_reg29,
    output reg [31:0] out_reg30,
    output reg [31:0] out_reg31
);

localparam CMD_NONE = 0, CMD_OK = 1, CMD_ERROR = 2, CMD_READ_REG = 3;

localparam S_INIT = 0, S_BUSY = 1;

reg [1:0] state = S_INIT;
reg [1:0] next_state;

reg [2:0] next_tx_cmd;

always @(tx_done, rx_packet_done, rx_packet_done, rx_packet_error, rx_payload_len,
    rx_buf0, rx_buf1, rx_buf2, rx_buf3, rx_buf4, rx_buf5, rx_buf6, rx_buf7,
    rx_buf8, rx_buf9, rx_buf10, rx_buf11, rx_buf12, rx_buf13, rx_buf14, rx_buf15)
    begin
        next_state <= state;
        next_tx_cmd <= CMD_NONE;

        case (state)
            S_INIT:
                begin
                    if (rx_packet_done)
                        begin
                            next_tx_cmd <= CMD_OK;
                            next_state <= S_BUSY;
                        end
                    else if (rx_packet_error)
                        begin
                            next_tx_cmd <= CMD_ERROR;
                            next_state <= S_BUSY;
                        end
                end
            S_BUSY:
                begin
                    if (tx_done)
                        next_state <= S_INIT;
                end
            default:
                next_state <= S_INIT;
        endcase
    end


always @(posedge clk)
begin
    state <= next_state;
end

always @(posedge clk)
begin

    tx_packet_wr <= 0;

    tx_payload_len <= 0;
    tx_buf0 <= 0;
    tx_buf1 <= 0;
    tx_buf2 <= 0;
    tx_buf3 <= 0;
    tx_buf4 <= 0;
    tx_buf5 <= 0;
    tx_buf6 <= 0;
    tx_buf7 <= 0;
    tx_buf8 <= 0;
    tx_buf9 <= 0;
    tx_buf10 <= 0;
    tx_buf11 <= 0;
    tx_buf12 <= 0;
    tx_buf13 <= 0;
    tx_buf14 <= 0;
    tx_buf15 <= 0;

    case (next_tx_cmd)
        CMD_OK:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 1;
                tx_buf0 <= 8'h81;
            end
        CMD_ERROR:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 1;
                tx_buf0 <= 8'h80;
            end
    endcase
end

endmodule
