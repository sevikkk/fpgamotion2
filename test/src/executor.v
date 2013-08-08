module executor (
    input clk,
    input rst,

    // s3g_rx interface
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

    // s3g_tx interface
    input tx_busy,
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

    // output_registers
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
    output reg [31:0] out_reg31,
    output reg [31:0] out_reg32,
    output reg [31:0] out_reg33,
    output reg [31:0] out_reg34,
    output reg [31:0] out_reg35,
    output reg [31:0] out_reg36,
    output reg [31:0] out_reg37,
    output reg [31:0] out_reg38,
    output reg [31:0] out_reg39,
    output reg [31:0] out_reg40,
    output reg [31:0] out_reg41,
    output reg [31:0] out_reg42,
    output reg [31:0] out_reg43,
    output reg [31:0] out_reg44,
    output reg [31:0] out_reg45,
    output reg [31:0] out_reg46,
    output reg [31:0] out_reg47,
    output reg [31:0] out_reg48,
    output reg [31:0] out_reg49,
    output reg [31:0] out_reg50,
    output reg [31:0] out_reg51,
    output reg [31:0] out_reg52,
    output reg [31:0] out_reg53,
    output reg [31:0] out_reg54,
    output reg [31:0] out_reg55,
    output reg [31:0] out_reg56,
    output reg [31:0] out_reg57,
    output reg [31:0] out_reg58,
    output reg [31:0] out_reg59,
    output reg [31:0] out_reg60,
    output reg [31:0] out_reg61,
    output reg [31:0] out_reg62,
    output reg [31:0] out_reg63,

    input [31:0] in_reg0,
    input [31:0] in_reg1,
    input [31:0] in_reg2,
    input [31:0] in_reg3,
    input [31:0] in_reg4,
    input [31:0] in_reg5,
    input [31:0] in_reg6,
    input [31:0] in_reg7,
    input [31:0] in_reg8,
    input [31:0] in_reg9,
    input [31:0] in_reg10,
    input [31:0] in_reg11,
    input [31:0] in_reg12,
    input [31:0] in_reg13,
    input [31:0] in_reg14,
    input [31:0] in_reg15,
    input [31:0] in_reg16,
    input [31:0] in_reg17,
    input [31:0] in_reg18,
    input [31:0] in_reg19,
    input [31:0] in_reg20,
    input [31:0] in_reg21,
    input [31:0] in_reg22,
    input [31:0] in_reg23,
    input [31:0] in_reg24,
    input [31:0] in_reg25,
    input [31:0] in_reg26,
    input [31:0] in_reg27,
    input [31:0] in_reg28,
    input [31:0] in_reg29,
    input [31:0] in_reg30,
    input [31:0] in_reg31,
    input [31:0] in_reg32,
    input [31:0] in_reg33,
    input [31:0] in_reg34,
    input [31:0] in_reg35,
    input [31:0] in_reg36,
    input [31:0] in_reg37,
    input [31:0] in_reg38,
    input [31:0] in_reg39,
    input [31:0] in_reg40,
    input [31:0] in_reg41,
    input [31:0] in_reg42,
    input [31:0] in_reg43,
    input [31:0] in_reg44,
    input [31:0] in_reg45,
    input [31:0] in_reg46,
    input [31:0] in_reg47,
    input [31:0] in_reg48,
    input [31:0] in_reg49,
    input [31:0] in_reg50,
    input [31:0] in_reg51,
    input [31:0] in_reg52,
    input [31:0] in_reg53,
    input [31:0] in_reg54,
    input [31:0] in_reg55,
    input [31:0] in_reg56,
    input [31:0] in_reg57,
    input [31:0] in_reg58,
    input [31:0] in_reg59,
    input [31:0] in_reg60,
    input [31:0] in_reg61,
    input [31:0] in_reg62,
    input [31:0] in_reg63,

    output reg [31:0] out_stbs
);

localparam CMD_NONE = 0, CMD_OK = 1, CMD_ERROR = 2, CMD_UNKNOWN = 3, CMD_READ_REG = 4, CMD_VERSION = 5, CMD_EXT_VERSION = 6;

localparam S_INIT = 0, S_DELAY = 1, S_BUSY = 2, S_READ = 3, S_READ1 = 4;

reg [3:0] state = S_INIT;
reg [3:0] next_state;

reg [2:0] next_tx_cmd;

reg [5:0] out_reg_addr;
reg [31:0] out_reg_data;
reg out_reg_stb;
reg [31:0] next_out_stbs;

reg [5:0] next_in_mux;
reg [5:0] in_mux;
reg [31:0] in_data;

always @(posedge clk)
begin
    out_stbs <= next_out_stbs;
    in_mux <= next_in_mux;
    in_data <= 0;
    case (in_mux)
        0: in_data <= in_reg0;
        1: in_data <= in_reg1;
        2: in_data <= in_reg2;
        3: in_data <= in_reg3;
        4: in_data <= in_reg4;
        5: in_data <= in_reg5;
        6: in_data <= in_reg6;
        7: in_data <= in_reg7;
        8: in_data <= in_reg8;
        9: in_data <= in_reg9;
        10: in_data <= in_reg10;
        11: in_data <= in_reg11;
        12: in_data <= in_reg12;
        13: in_data <= in_reg13;
        14: in_data <= in_reg14;
        15: in_data <= in_reg15;
        16: in_data <= in_reg16;
        17: in_data <= in_reg17;
        18: in_data <= in_reg18;
        19: in_data <= in_reg19;
        20: in_data <= in_reg20;
        21: in_data <= in_reg21;
        22: in_data <= in_reg22;
        23: in_data <= in_reg23;
        24: in_data <= in_reg24;
        25: in_data <= in_reg25;
        26: in_data <= in_reg26;
        27: in_data <= in_reg27;
        28: in_data <= in_reg28;
        29: in_data <= in_reg29;
        30: in_data <= in_reg30;
        31: in_data <= in_reg31;
        32: in_data <= in_reg32;
        33: in_data <= in_reg33;
        34: in_data <= in_reg34;
        35: in_data <= in_reg35;
        36: in_data <= in_reg36;
        37: in_data <= in_reg37;
        38: in_data <= in_reg38;
        39: in_data <= in_reg39;
        40: in_data <= in_reg40;
        41: in_data <= in_reg41;
        42: in_data <= in_reg42;
        43: in_data <= in_reg43;
        44: in_data <= in_reg44;
        45: in_data <= in_reg45;
        46: in_data <= in_reg46;
        47: in_data <= in_reg47;
        48: in_data <= in_reg48;
        49: in_data <= in_reg49;
        50: in_data <= in_reg50;
        51: in_data <= in_reg51;
        52: in_data <= in_reg52;
        53: in_data <= in_reg53;
        54: in_data <= in_reg54;
        55: in_data <= in_reg55;
        56: in_data <= in_reg56;
        57: in_data <= in_reg57;
        58: in_data <= in_reg58;
        59: in_data <= in_reg59;
        60: in_data <= in_reg60;
        61: in_data <= in_reg61;
        62: in_data <= in_reg62;
        63: in_data <= in_reg63;
    endcase
end


always @(tx_busy, rx_packet_done, rx_packet_done, rx_packet_error, rx_payload_len,
    rx_buf0, rx_buf1, rx_buf2, rx_buf3, rx_buf4, rx_buf5, rx_buf6, rx_buf7,
    rx_buf8, rx_buf9, rx_buf10, rx_buf11, rx_buf12, rx_buf13, rx_buf14, rx_buf15, state, in_mux)
    begin
        next_state <= state;
        next_tx_cmd <= CMD_NONE;
        next_in_mux <= in_mux;
        next_out_stbs <= 0;

        out_reg_stb <= 0;
        out_reg_addr <= 0;
        out_reg_data <= 0;

        case (state)
            S_INIT:
                begin
                    if (rx_packet_done)
                        begin
                            next_tx_cmd <= CMD_UNKNOWN;
                            next_state <= S_DELAY;
                            if (rx_payload_len == 0)
                                begin
                                    next_tx_cmd <= CMD_OK;
                                end
                            else
                                case (rx_buf0)
                                    0: next_tx_cmd <= CMD_VERSION;
                                    27: next_tx_cmd <= CMD_EXT_VERSION;
                                    60: // WRITE_OUT_REG
                                    begin
                                        out_reg_stb <= 1;
                                        out_reg_addr <= rx_buf1;
                                        out_reg_data <= {rx_buf5, rx_buf4, rx_buf3, rx_buf2};
                                        next_tx_cmd <= CMD_OK;
                                    end
                                    61: // READ_IN_REG
                                    begin
                                        next_in_mux <= rx_buf1;
                                        next_state <= S_READ;
                                        next_tx_cmd <= CMD_NONE;
                                    end
                                    62: // OUT_STBS
                                    begin
                                        next_out_stbs <= {rx_buf4, rx_buf3, rx_buf2, rx_buf1};
                                        next_tx_cmd <= CMD_OK;
                                    end
                                endcase
                        end
                    else if (rx_packet_error)
                        begin
                            next_tx_cmd <= CMD_ERROR;
                            next_state <= S_DELAY;
                        end
                end
            S_DELAY:
                begin
                        next_state <= S_BUSY;
                end
            S_BUSY:
                begin
                    if (!tx_busy)
                        next_state <= S_INIT;
                end
            S_READ:
                begin
                    next_state <= S_READ1;
                end
            S_READ1:
                begin
                    next_state <= S_DELAY;
                    next_tx_cmd <= CMD_READ_REG;
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
        CMD_UNKNOWN:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 1;
                tx_buf0 <= 8'h85;
            end
        CMD_VERSION:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 3;
                tx_buf0 <= 8'h81;
                tx_buf1 <= 8'hBA;
                tx_buf2 <= 8'hCE;
            end
        CMD_EXT_VERSION:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 9;
                tx_buf0 <= 8'h81;
                tx_buf1 <= 8'h01;
                tx_buf2 <= 8'h00;
                tx_buf3 <= 8'h01;
                tx_buf4 <= 8'h00;
                tx_buf5 <= 8'hCE;
                tx_buf6 <= 8'h00;
                tx_buf7 <= 8'h00;
                tx_buf8 <= 8'h00;
            end
        CMD_READ_REG:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 5;
                tx_buf0 <= 8'h81;
                tx_buf1 <= in_data[7:0];
                tx_buf2 <= in_data[15:8];
                tx_buf3 <= in_data[23:16];
                tx_buf4 <= in_data[31:24];
            end
    endcase
end

always @(posedge clk)
begin
    if (out_reg_stb)
        case (out_reg_addr)
            0: out_reg0 <= out_reg_data;
            1: out_reg1 <= out_reg_data;
            2: out_reg2 <= out_reg_data;
            3: out_reg3 <= out_reg_data;
            4: out_reg4 <= out_reg_data;
            5: out_reg5 <= out_reg_data;
            6: out_reg6 <= out_reg_data;
            7: out_reg7 <= out_reg_data;
            8: out_reg8 <= out_reg_data;
            9: out_reg9 <= out_reg_data;
            10: out_reg10 <= out_reg_data;
            11: out_reg11 <= out_reg_data;
            12: out_reg12 <= out_reg_data;
            13: out_reg13 <= out_reg_data;
            14: out_reg14 <= out_reg_data;
            15: out_reg15 <= out_reg_data;
            16: out_reg16 <= out_reg_data;
            17: out_reg17 <= out_reg_data;
            18: out_reg18 <= out_reg_data;
            19: out_reg19 <= out_reg_data;
            20: out_reg20 <= out_reg_data;
            21: out_reg21 <= out_reg_data;
            22: out_reg22 <= out_reg_data;
            23: out_reg23 <= out_reg_data;
            24: out_reg24 <= out_reg_data;
            25: out_reg25 <= out_reg_data;
            26: out_reg26 <= out_reg_data;
            27: out_reg27 <= out_reg_data;
            28: out_reg28 <= out_reg_data;
            29: out_reg29 <= out_reg_data;
            30: out_reg30 <= out_reg_data;
            31: out_reg31 <= out_reg_data;
            32: out_reg32 <= out_reg_data;
            33: out_reg33 <= out_reg_data;
            34: out_reg34 <= out_reg_data;
            35: out_reg35 <= out_reg_data;
            36: out_reg36 <= out_reg_data;
            37: out_reg37 <= out_reg_data;
            38: out_reg38 <= out_reg_data;
            39: out_reg39 <= out_reg_data;
            40: out_reg40 <= out_reg_data;
            41: out_reg41 <= out_reg_data;
            42: out_reg42 <= out_reg_data;
            43: out_reg43 <= out_reg_data;
            44: out_reg44 <= out_reg_data;
            45: out_reg45 <= out_reg_data;
            46: out_reg46 <= out_reg_data;
            47: out_reg47 <= out_reg_data;
            48: out_reg48 <= out_reg_data;
            49: out_reg49 <= out_reg_data;
            50: out_reg50 <= out_reg_data;
            51: out_reg51 <= out_reg_data;
            52: out_reg52 <= out_reg_data;
            53: out_reg53 <= out_reg_data;
            54: out_reg54 <= out_reg_data;
            55: out_reg55 <= out_reg_data;
            56: out_reg56 <= out_reg_data;
            57: out_reg57 <= out_reg_data;
            58: out_reg58 <= out_reg_data;
            59: out_reg59 <= out_reg_data;
            60: out_reg60 <= out_reg_data;
            61: out_reg61 <= out_reg_data;
            62: out_reg62 <= out_reg_data;
            63: out_reg63 <= out_reg_data;
        endcase
end

endmodule

