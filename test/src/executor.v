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

           output reg [7:0] next_rx_buffer_addr,
           input [7:0] rx_buffer_data,

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

           output reg [31:0] out_stbs,

           input int0,
           input int1,
           input int2,
           input int3,
           input int4,
           input int5,
           input int6,
           input int7,
           input int8,
           input int9,
           input int10,
           input int11,
           input int12,
           input int13,
           input int14,
           input int15,
           input int16,
           input int17,
           input int18,
           input int19,
           input int20,
           input int21,
           input int22,
           input int23,
           input int24,
           input int25,
           input int26,
           input int27,
           input int28,
           input int29,
           input int30,
           input int31,

           output reg [15:0] ext_buffer_addr,
           output reg [39:0] ext_buffer_data,
           output reg ext_buffer_wr
       );

parameter INTS_TIMER = 1000000;
parameter EXT_VER_1 = 8'h01;
parameter EXT_VER_2 = 8'h00;
parameter EXT_VER_3 = 8'h01;
parameter EXT_VER_4 = 8'h00;
parameter EXT_VER_5 = 8'hCE;
parameter EXT_VER_6 = 8'h00;
parameter EXT_VER_7 = 8'h00;
parameter EXT_VER_8 = 8'h00;

localparam
    CMD_NONE = 0, CMD_OK = 1, CMD_ERROR = 2, CMD_UNKNOWN = 3, CMD_READ_REG = 4, 
    CMD_VERSION = 5, CMD_EXT_VERSION = 6, CMD_INTERRUPT = 7;

localparam 
    S_INIT = 0, S_DELAY = 1, S_BUSY = 2, S_READ = 3, S_READ1 = 4, 
    S_BUFFER0 = 5, S_BUFFER1 = 6, S_BUFFER2 = 7, S_BUFFER3 = 8, 
    S_BUFFER4 = 9, S_BUFFER5 = 10;

reg [3:0] state = S_INIT;
reg [3:0] next_state;

reg [3:0] next_tx_cmd;

reg [5:0] out_reg_addr;
reg [31:0] out_reg_data;
reg out_reg_stb;
reg [31:0] next_out_stbs;

reg [5:0] next_in_mux;
reg [5:0] in_mux;
reg [31:0] in_data;

wire [31:0] ints_vector;
reg [31:0] ints_pending;
reg [31:0] ints_mask;
reg [31:0] next_ints_mask;
reg [31:0] ints_to_clear;

reg [31:0] next_ints_timer;
reg [31:0] ints_timer;

reg [7:0] rx_buffer_addr;
reg [15:0] next_ext_buffer_addr;
reg [39:0] next_ext_buffer_data;
reg next_ext_buffer_wr;

reg [7:0] word_cnt;
reg [7:0] next_word_cnt;

assign ints_vector = { 
    int31, int30, int29, int28, int27, int26, int25, int24, 
    int23, int22, int21, int20, int19, int18, int17, int16, 
    int15, int14, int13, int12, int11, int10, int9, int8, 
    int7, int6, int5, int4, int3, int2, int1, int0 };

always @(posedge clk)
    begin
        if (rst)
            ints_pending <= 0;
        else
            ints_pending <= (ints_pending & ~ints_to_clear) | ints_vector;
    end

always @(posedge clk)
    begin
        if (rst)
            begin
                out_stbs <= 0;
                ints_mask <= 32'hFFFFFFFF;
                in_mux <= 0;
                ints_timer <= 0;
                rx_buffer_addr <= 0;
                word_cnt <= 0;
                ext_buffer_addr <= 0;
                ext_buffer_data <= 0;
                ext_buffer_wr <= 0;
            end
        else
            begin
                out_stbs <= next_out_stbs;
                ints_mask <= next_ints_mask;
                in_mux <= next_in_mux;
                ints_timer <= next_ints_timer;
                rx_buffer_addr <= next_rx_buffer_addr;
                word_cnt <= next_word_cnt;
                ext_buffer_addr <= next_ext_buffer_addr;
                ext_buffer_data <= next_ext_buffer_data;
                ext_buffer_wr <= next_ext_buffer_wr;
            end

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
             rx_buf8, rx_buf9, rx_buf10, rx_buf11, rx_buf12, rx_buf13, rx_buf14, rx_buf15, 
             state, in_mux, ints_pending, ints_timer, rx_buffer_addr, word_cnt, 
             ext_buffer_addr, ints_mask, ext_buffer_data, rx_buffer_data)
    begin
        next_state <= state;
        next_tx_cmd <= CMD_NONE;
        next_in_mux <= in_mux;
        next_out_stbs <= 0;

        next_ints_mask <= ints_mask;

        out_reg_stb <= 0;
        out_reg_addr <= 0;
        out_reg_data <= 0;

        ints_to_clear <= 0;

        next_ints_timer <= ints_timer - 1;

        if (ints_timer == 0)
            next_ints_timer <= 0;

        next_rx_buffer_addr <= rx_buffer_addr;
        next_word_cnt <= word_cnt;
        next_ext_buffer_addr <= ext_buffer_addr;
        next_ext_buffer_data <= ext_buffer_data;
        next_ext_buffer_wr <= 0;

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
                                    0:
                                        next_tx_cmd <= CMD_VERSION;
                                    27:
                                        next_tx_cmd <= CMD_EXT_VERSION;
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
                                    63: // CLEAR_INTS
                                        begin
                                            ints_to_clear <= {rx_buf4, rx_buf3, rx_buf2, rx_buf1};
                                            next_ints_timer <= 0;
                                            next_tx_cmd <= CMD_OK;
                                        end
                                    64: // MASK_INTS
                                        begin
                                            next_ints_mask <= {rx_buf4, rx_buf3, rx_buf2, rx_buf1};
                                            next_tx_cmd <= CMD_OK;
                                        end
                                    65: // WRITE_BUF
                                        begin
                                            next_rx_buffer_addr <= 4;
                                            next_word_cnt <= rx_buf1;
                                            next_ext_buffer_addr <= {rx_buf3, rx_buf2};
                                            next_ext_buffer_data <= 0;
                                            next_state <= S_BUFFER0;
                                            next_tx_cmd <= CMD_NONE;
                                        end
                                endcase
                        end
                    else if (rx_packet_error)
                        begin
                            next_tx_cmd <= CMD_ERROR;
                            next_state <= S_DELAY;
                        end
                    else if ((ints_pending & ints_mask) != 0)
                        begin
                            //$display("ints:", ints_pending & ints_mask);
                            if (ints_timer == 0)
                                begin
                                    next_tx_cmd <= CMD_INTERRUPT;
                                    next_state <= S_DELAY;
                                    next_ints_timer <= INTS_TIMER;
                                end
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
            S_BUFFER0:
                begin
                    next_state <= S_BUFFER1;
                    next_rx_buffer_addr <= rx_buffer_addr + 1;
                    next_ext_buffer_data[7:0] <= rx_buffer_data;
                end
            S_BUFFER1:
                begin
                    next_state <= S_BUFFER2;
                    next_rx_buffer_addr <= rx_buffer_addr + 1;
                    next_ext_buffer_data[15:8] <= rx_buffer_data;
                end
            S_BUFFER2:
                begin
                    next_state <= S_BUFFER3;
                    next_rx_buffer_addr <= rx_buffer_addr + 1;
                    next_ext_buffer_data[23:16] <= rx_buffer_data;
                end
            S_BUFFER3:
                begin
                    next_state <= S_BUFFER4;
                    next_rx_buffer_addr <= rx_buffer_addr + 1;
                    next_ext_buffer_data[31:24] <= rx_buffer_data;
                end
            S_BUFFER4:
                begin
                    next_state <= S_BUFFER5;
                    next_ext_buffer_data[39:32] <= rx_buffer_data;
                    next_ext_buffer_wr <= 1;
                    next_word_cnt <= word_cnt - 1;
                end
            S_BUFFER5:
                begin
                    if (word_cnt == 0)
                        begin
                            next_state <= S_DELAY;
                            next_tx_cmd <= CMD_OK;
                        end
                    else
                        begin
                            next_rx_buffer_addr <= rx_buffer_addr + 1;
                            next_ext_buffer_addr <= ext_buffer_addr + 1;
                            next_state <= S_BUFFER0;
                            next_ext_buffer_data <= 0;
                        end
                end
            default:
                next_state <= S_INIT;
        endcase
    end


always @(posedge clk)
    begin
        if (rst)
            state <= S_INIT;
        else
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
                    tx_buf1 <= EXT_VER_1;
                    tx_buf2 <= EXT_VER_2;
                    tx_buf3 <= EXT_VER_3;
                    tx_buf4 <= EXT_VER_4;
                    tx_buf5 <= EXT_VER_5;
                    tx_buf6 <= EXT_VER_6;
                    tx_buf7 <= EXT_VER_7;
                    tx_buf8 <= EXT_VER_8;
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
            CMD_INTERRUPT:
                begin
                    tx_packet_wr <= 1;
                    tx_payload_len <= 5;
                    tx_buf0 <= 80;
                    tx_buf1 <= ints_pending[7:0];
                    tx_buf2 <= ints_pending[15:8];
                    tx_buf3 <= ints_pending[23:16];
                    tx_buf4 <= ints_pending[31:24];
                end
        endcase
    end

always @(posedge clk)
    begin
        if (rst)
            begin
                out_reg0 <= 0;
                out_reg1 <= 0;
                out_reg2 <= 0;
                out_reg3 <= 0;
                out_reg4 <= 0;
                out_reg5 <= 0;
                out_reg6 <= 0;
                out_reg7 <= 0;
                out_reg8 <= 0;
                out_reg9 <= 0;
                out_reg10 <= 0;
                out_reg11 <= 0;
                out_reg12 <= 0;
                out_reg13 <= 0;
                out_reg14 <= 0;
                out_reg15 <= 0;
                out_reg16 <= 0;
                out_reg17 <= 0;
                out_reg18 <= 0;
                out_reg19 <= 0;
                out_reg20 <= 0;
                out_reg21 <= 0;
                out_reg22 <= 0;
                out_reg23 <= 0;
                out_reg24 <= 0;
                out_reg25 <= 0;
                out_reg26 <= 0;
                out_reg27 <= 0;
                out_reg28 <= 0;
                out_reg29 <= 0;
                out_reg30 <= 0;
                out_reg31 <= 0;
                out_reg32 <= 0;
                out_reg33 <= 0;
                out_reg34 <= 0;
                out_reg35 <= 0;
                out_reg36 <= 0;
                out_reg37 <= 0;
                out_reg38 <= 0;
                out_reg39 <= 0;
                out_reg40 <= 0;
                out_reg41 <= 0;
                out_reg42 <= 0;
                out_reg43 <= 0;
                out_reg44 <= 0;
                out_reg45 <= 0;
                out_reg46 <= 0;
                out_reg47 <= 0;
                out_reg48 <= 0;
                out_reg49 <= 0;
                out_reg50 <= 0;
                out_reg51 <= 0;
                out_reg52 <= 0;
                out_reg53 <= 0;
                out_reg54 <= 0;
                out_reg55 <= 0;
                out_reg56 <= 0;
                out_reg57 <= 0;
                out_reg58 <= 0;
                out_reg59 <= 0;
                out_reg60 <= 0;
                out_reg61 <= 0;
                out_reg62 <= 0;
                out_reg63 <= 0;
            end
        else if (out_reg_stb)
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

