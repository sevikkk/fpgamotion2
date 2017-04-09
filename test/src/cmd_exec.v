module cmd_exec(
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
    output reg [7:0] tx_buf15

    input [31:0] in_reg0;
    input [31:0] in_reg1;
    input [31:0] in_reg2;
    input [31:0] in_reg3;
    input [31:0] in_reg4;
    input [31:0] in_reg5;
    input [31:0] in_reg6;
    input [31:0] in_reg7;
    input [31:0] in_reg8;
    input [31:0] in_reg9;
    input [31:0] in_reg10;
    input [31:0] in_reg11;
    input [31:0] in_reg12;
    input [31:0] in_reg13;
    input [31:0] in_reg14;
    input [31:0] in_reg15;

    output reg [31:0] out_reg0;
    output reg [31:0] out_reg1;
    output reg [31:0] out_reg2;
    output reg [31:0] out_reg3;
    output reg [31:0] out_reg4;
    output reg [31:0] out_reg5;
    output reg [31:0] out_reg6;
    output reg [31:0] out_reg7;
    output reg [31:0] out_reg8;
    output reg [31:0] out_reg9;
    output reg [31:0] out_reg10;
    output reg [31:0] out_reg11;
    output reg [31:0] out_reg12;
    output reg [31:0] out_reg13;
    output reg [31:0] out_reg14;
    output reg [31:0] out_reg15;
    output reg [31:0] out_reg16;
    output reg [31:0] out_reg17;
    output reg [31:0] out_reg18;
    output reg [31:0] out_reg19;
    output reg [31:0] out_reg20;
    output reg [31:0] out_reg20;
    output reg [31:0] out_reg21;
    output reg [31:0] out_reg22;
    output reg [31:0] out_reg23;
    output reg [31:0] out_reg24;
    output reg [31:0] out_reg25;
    output reg [31:0] out_reg26;
    output reg [31:0] out_reg27;
    output reg [31:0] out_reg28;
    output reg [31:0] out_reg29;
    output reg [31:0] out_reg30;
    output reg [31:0] out_reg31;

    output reg [31:0] out_strobes;

    input int0;
    input int1;
    input int2;
    input int3;
    input int4;
    input int5;
    input int6;
    input int7;
    input int8;
    input int9;
    input int10;
    input int11;
    input int12;
    input int13;
    input int14;
    input int15;
    input int16;
    input int17;
    input int18;
    input int19;
    input int20;
    input int21;
    input int22;
    input int23;
    input int24;
    input int25;
    input int26;
    input int27;
    input int28;
    input int29;
    input int30;
    input int31;
);

localparam S_INIT = 0, S_WAIT = 1;

reg [3:0] input_mux;
reg [3:0] next_input_mux;
wire [31:0] input_data;

always @(input_mux, in_reg0, in_reg1, in_reg2, in_reg3, in_reg4, in_reg5, in_reg6, in_reg7, in_reg8, in_reg9, in_reg10, in_reg11, in_reg12, in_reg13, in_reg14, in_reg15)
    begin
        input_data <= 0;
        case (input_mux)
            0: input_data <= in_reg0;
            1: input_data <= in_reg1;
            2: input_data <= in_reg2;
            3: input_data <= in_reg3;
            4: input_data <= in_reg4;
            5: input_data <= in_reg5;
            6: input_data <= in_reg6;
            7: input_data <= in_reg7;
            8: input_data <= in_reg8;
            9: input_data <= in_reg9;
            10: input_data <= in_reg10;
            11: input_data <= in_reg11;
            12: input_data <= in_reg12;
            13: input_data <= in_reg13;
            14: input_data <= in_reg14;
            15: input_data <= in_reg15;
        endcase
    end

localparam TXCMD_NONE = 0, TXCMD_VER = 1, TXCMD_READ_REG = 2, TXCMD_OK = 3;
reg [2:0] tx_cmd;

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

    case (tx_cmd)
        TXCMD_VER:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 3;
                tx_buf0 <= 8'h81;
                tx_buf1 <= 8'hBA;
                tx_buf2 <= 8'hCE;
            end
        TXCMD_OK:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 1;
                tx_buf0 <= 8'h81;
            end
        TXCMD_READ_REG:
            begin
                tx_packet_wr <= 1;
                tx_payload_len <= 5;
                tx_buf0 <= 8'h81;
                tx_buf1 <= input_data[7:0];
                tx_buf2 <= input_data[15:8];
                tx_buf3 <= input_data[23:16];
                tx_buf4 <= input_data[31:24];
            end
    endcase
end

reg [4:0] out_reg_select;
reg [31:0] out_reg_data;

always @(posedge clk)
    begin
        case (out_reg_select)
            0: out_reg_0 <= out_reg_data;
            1: out_reg_1 <= out_reg_data;
            2: out_reg_2 <= out_reg_data;
            3: out_reg_3 <= out_reg_data;
            4: out_reg_4 <= out_reg_data;
            5: out_reg_5 <= out_reg_data;
            6: out_reg_6 <= out_reg_data;
            7: out_reg_7 <= out_reg_data;
            8: out_reg_8 <= out_reg_data;
            9: out_reg_9 <= out_reg_data;
            10: out_reg_10 <= out_reg_data;
            11: out_reg_11 <= out_reg_data;
            12: out_reg_12 <= out_reg_data;
            13: out_reg_13 <= out_reg_data;
            14: out_reg_14 <= out_reg_data;
            15: out_reg_15 <= out_reg_data;
            16: out_reg_16 <= out_reg_data;
            17: out_reg_17 <= out_reg_data;
            18: out_reg_18 <= out_reg_data;
            19: out_reg_19 <= out_reg_data;
            20: out_reg_20 <= out_reg_data;
            21: out_reg_21 <= out_reg_data;
            22: out_reg_22 <= out_reg_data;
            23: out_reg_23 <= out_reg_data;
            24: out_reg_24 <= out_reg_data;
            25: out_reg_25 <= out_reg_data;
            26: out_reg_26 <= out_reg_data;
            27: out_reg_27 <= out_reg_data;
            28: out_reg_28 <= out_reg_data;
            29: out_reg_29 <= out_reg_data;
            30: out_reg_30 <= out_reg_data;
            31: out_reg_31 <= out_reg_data;
        endcase
    end

reg [31:0] int_enable;
reg [31:0] int_status;
reg int_clear;

always @(posedge clk)
begin
    if (int_clear)
        int_status <= int_enable & {
            int31, int30, int29, int28, int27, int26, int25, int24, 
            int23, int22, int21, int20, int19, int18, int17, int16, 
            int15, int14, int13, int12, int11, int10, int9, int8, 
            int7, int6, int5, int4, int3, int2, int1, int0
        }
    else
        int_status <= int_enable & (int_status | {
            int31, int30, int29, int28, int27, int26, int25, int24, 
            int23, int22, int21, int20, int19, int18, int17, int16, 
            int15, int14, int13, int12, int11, int10, int9, int8, 
            int7, int6, int5, int4, int3, int2, int1, int0
        })

endmodule
