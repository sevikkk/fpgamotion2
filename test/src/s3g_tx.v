module s3g_tx(
        clk,
        rst,

        tx_data,
        tx_wr,
        tx_done,

        busy,

        packet_wr,
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

    input tx_done;
    input packet_wr;
    output reg [7:0] tx_data;
    output reg tx_wr;
    output reg busy;

    input [7:0] payload_len;
    input [7:0] buf0;
    input [7:0] buf1;
    input [7:0] buf2;
    input [7:0] buf3;
    input [7:0] buf4;
    input [7:0] buf5;
    input [7:0] buf6;
    input [7:0] buf7;
    input [7:0] buf8;
    input [7:0] buf9;
    input [7:0] buf10;
    input [7:0] buf11;
    input [7:0] buf12;
    input [7:0] buf13;
    input [7:0] buf14;
    input [7:0] buf15;
    
    localparam S_INIT = 0, S_LEN = 1, S_DATA = 2, S_CRC = 3;

    reg [2:0] state = S_INIT;
    reg [2:0] next_state;
    reg [3:0] byte_cnt = 0;
    reg [3:0] next_byte_cnt;
    reg [7:0] crc = 0;
    reg [7:0] next_crc;

    reg next_busy;
    reg [7:0] next_tx_data;
    reg next_tx_wr;

    reg [7:0] buffer[0:15];
    reg [3:0] saved_len;
    reg save_buf;

    always @(posedge clk)
        if (save_buf)
        begin
            saved_len <= payload_len[3:0];
            buffer[0] <= buf0;
            buffer[1] <= buf1;
            buffer[2] <= buf2;
            buffer[3] <= buf3;
            buffer[4] <= buf4;
            buffer[5] <= buf5;
            buffer[6] <= buf6;
            buffer[7] <= buf7;
            buffer[8] <= buf8;
            buffer[9] <= buf9;
            buffer[10] <= buf10;
            buffer[11] <= buf11;
            buffer[12] <= buf12;
            buffer[13] <= buf13;
            buffer[14] <= buf14;
            buffer[15] <= buf15;
        end

    always @(state, byte_cnt, crc, busy, tx_done, packet_wr, tx_data, saved_len)
        begin
            next_state <= state;
            next_byte_cnt <= byte_cnt;
            next_crc <= crc;
            next_busy <= busy;

            save_buf <= 0;
            next_tx_data <= tx_data;
            next_tx_wr <= 0;

            if (state == S_INIT)
                begin
                    if (packet_wr)
                    begin
                        next_state <= S_LEN;
                        next_busy <= 1;

                        save_buf <= 1;
                        next_tx_data <= 8'hD5;
                        next_tx_wr <= 1;
                    end
                end
            else if (state == S_LEN)
                begin
                    if (tx_done)
                    begin
                        next_state <= S_DATA;
                        next_tx_data <= saved_len;
                        next_tx_wr <= 1;
                        next_byte_cnt <= 0;
                        next_crc <= 0;
                    end
                end
            else if (state == S_DATA)
                begin
                    if (tx_done)
                    begin
                        next_byte_cnt <= byte_cnt + 1;
                        next_tx_wr <= 1;

                        if (byte_cnt != saved_len)
                            begin
                                next_crc <= nextCRC8_D8(buffer[byte_cnt], crc);
                                next_tx_data <= buffer[byte_cnt];
                            end
                        else
                            begin
                                next_tx_data <= crc;
                                next_state <= S_CRC;
                            end
                    end
                end
            else if (state == S_CRC)
                begin
                    if (tx_done)
                    begin
                        next_state <= S_INIT;
                        next_busy <= 0;
                    end
                end
            else 
                next_state <= S_INIT;
        end
    
    always @(posedge clk)
    begin
        if (rst)
            begin
                state <= S_INIT;
                crc <= 0;
                byte_cnt <= 0;
                busy <= 0;
                tx_data <= 0;
                tx_wr <= 0;
            end
        else
            begin
                state <= next_state;
                crc <= next_crc;
                byte_cnt <= next_byte_cnt;
                busy <= next_busy;
                tx_data <= next_tx_data;
                tx_wr <= next_tx_wr;
            end
    end

endmodule
