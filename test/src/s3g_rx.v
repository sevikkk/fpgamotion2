module s3g_rx(
           clk,
           rst,
           rx_data,
           rx_done,

           packet_done,
           packet_error,
           buffer_valid,
           buffer_addr,
           buffer_data,

           payload_len,

           buf0,
           buf1,
           buf2,
           buf3,
           buf4,
           buf5,
           buf6,
           buf7,
           buf8,
           buf9,
           buf10,
           buf11,
           buf12,
           buf13,
           buf14,
           buf15
       );

`include "crc8.v"

input clk;
input rst;
input [7:0] rx_data;
input rx_done;

output reg packet_done;
output reg packet_error;
output reg buffer_valid;

output reg [7:0] payload_len;
output reg [7:0] buf0;
output reg [7:0] buf1;
output reg [7:0] buf2;
output reg [7:0] buf3;
output reg [7:0] buf4;
output reg [7:0] buf5;
output reg [7:0] buf6;
output reg [7:0] buf7;
output reg [7:0] buf8;
output reg [7:0] buf9;
output reg [7:0] buf10;
output reg [7:0] buf11;
output reg [7:0] buf12;
output reg [7:0] buf13;
output reg [7:0] buf14;
output reg [7:0] buf15;

input [7:0] buffer_addr;
output reg [7:0] buffer_data;

reg [7:0] buffer[0:255];

localparam S_INIT = 0, S_LEN = 1, S_DATA = 2, S_CRC = 3;

reg [2:0] state = S_INIT;
reg [2:0] next_state;
reg [7:0] byte_cnt = 0;
reg [7:0] next_byte_cnt;
reg [7:0] crc = 0;
reg [7:0] next_crc;
reg next_packet_done;
reg next_packet_error;

reg save_buf;

reg [7:0] save_addr;
reg [7:0] next_save_addr;

reg [7:0] next_payload_len;
reg next_buffer_valid;
reg [7:0] next_buf0;
reg [7:0] next_buf1;
reg [7:0] next_buf2;
reg [7:0] next_buf3;
reg [7:0] next_buf4;
reg [7:0] next_buf5;
reg [7:0] next_buf6;
reg [7:0] next_buf7;
reg [7:0] next_buf8;
reg [7:0] next_buf9;
reg [7:0] next_buf10;
reg [7:0] next_buf11;
reg [7:0] next_buf12;
reg [7:0] next_buf13;
reg [7:0] next_buf14;
reg [7:0] next_buf15;

always @(state, byte_cnt, crc, save_addr, rx_done, rx_data, payload_len, buffer_valid,
             buf0, buf1, buf2, buf3, buf4, buf5, buf6, buf7,
             buf8, buf9, buf10, buf11, buf12, buf13, buf14, buf15)
    begin
        next_state <= state;
        next_byte_cnt <= byte_cnt;
        next_crc <= crc;
        next_packet_done <= 0;
        next_packet_error <= 0;

        next_payload_len <= payload_len;
        next_buffer_valid <= buffer_valid;

        next_save_addr <= save_addr;
        save_buf <= 0;

        next_buf0 <= buf0;
        next_buf1 <= buf1;
        next_buf2 <= buf2;
        next_buf3 <= buf3;
        next_buf4 <= buf4;
        next_buf5 <= buf5;
        next_buf6 <= buf6;
        next_buf7 <= buf7;
        next_buf8 <= buf8;
        next_buf9 <= buf9;
        next_buf10 <= buf10;
        next_buf11 <= buf11;
        next_buf12 <= buf12;
        next_buf13 <= buf13;
        next_buf14 <= buf14;
        next_buf15 <= buf15;

        if (state == S_INIT)
            begin
                if (rx_done && rx_data == 8'hD5)
                    begin
                        next_state <= S_LEN;
                        next_buffer_valid <= 0;

                        next_payload_len <= 0;

                        next_save_addr <= 0;

                        next_buf0 <= 0;
                        next_buf1 <= 0;
                        next_buf2 <= 0;
                        next_buf3 <= 0;
                        next_buf4 <= 0;
                        next_buf5 <= 0;
                        next_buf6 <= 0;
                        next_buf7 <= 0;
                        next_buf8 <= 0;
                        next_buf9 <= 0;
                        next_buf10 <= 0;
                        next_buf11 <= 0;
                        next_buf12 <= 0;
                        next_buf13 <= 0;
                        next_buf14 <= 0;
                        next_buf15 <= 0;
                    end
            end
        else if (state == S_LEN)
            begin
                if (rx_done)
                    begin
                        next_state <= S_DATA;
                        next_byte_cnt <= rx_data;
                        next_crc <= 0;
                        next_payload_len <= rx_data;
                    end
            end
        else if (state == S_DATA)
            begin
                if (rx_done)
                    begin
                        next_byte_cnt <= byte_cnt - 1;
                        next_crc <= nextCRC8_D8(rx_data, crc);

                        save_buf <= 1;
                        next_save_addr <= save_addr + 1;
                        case (save_addr)
                            0:
                                next_buf0 <= rx_data;
                            1:
                                next_buf1 <= rx_data;
                            2:
                                next_buf2 <= rx_data;
                            3:
                                next_buf3 <= rx_data;
                            4:
                                next_buf4 <= rx_data;
                            5:
                                next_buf5 <= rx_data;
                            6:
                                next_buf6 <= rx_data;
                            7:
                                next_buf7 <= rx_data;
                            8:
                                next_buf8 <= rx_data;
                            9:
                                next_buf9 <= rx_data;
                            10:
                                next_buf10 <= rx_data;
                            11:
                                next_buf11 <= rx_data;
                            12:
                                next_buf12 <= rx_data;
                            13:
                                next_buf13 <= rx_data;
                            14:
                                next_buf14 <= rx_data;
                            15:
                                next_buf15 <= rx_data;
                        endcase

                        if (byte_cnt == 1)
                            next_state <= S_CRC;
                    end
            end
        else if (state == S_CRC)
            begin
                if (rx_done)
                    begin
                        next_state <= S_INIT;
                        if (rx_data == crc)
                            begin
                                next_packet_done <= 1;
                                next_buffer_valid <= 1;
                            end
                        else
                            next_packet_error <= 1;
                    end
            end
        else
            next_state <= S_INIT;
    end

always @(posedge clk)
    begin
        state <= next_state;
        crc <= next_crc;
        byte_cnt <= next_byte_cnt;
        packet_error <= next_packet_error;
        packet_done <= next_packet_done;

        payload_len <= next_payload_len;
        buffer_valid <= next_buffer_valid;

        save_addr <= next_save_addr;

        buf0 <= next_buf0;
        buf1 <= next_buf1;
        buf2 <= next_buf2;
        buf3 <= next_buf3;
        buf4 <= next_buf4;
        buf5 <= next_buf5;
        buf6 <= next_buf6;
        buf7 <= next_buf7;
        buf8 <= next_buf8;
        buf9 <= next_buf9;
        buf10 <= next_buf10;
        buf11 <= next_buf11;
        buf12 <= next_buf12;
        buf13 <= next_buf13;
        buf14 <= next_buf14;
        buf15 <= next_buf15;

        if (save_buf)
            buffer[save_addr] <= rx_data;

    end

always @(posedge clk)
    buffer_data <= buffer[buffer_addr];

endmodule
