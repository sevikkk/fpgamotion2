`include "../src/s3g_rx.v"
`include "../src/s3g_tx.v"
`include "../src/executor.v"

module s3g_rx_tb;

    reg clk;
    reg rst;

    reg [31:0] cycle;

    reg [7:0] rx_data;
    reg rx_done;

    reg tx_done;
    wire tx_wr;
    wire [7:0] tx_data;

    wire rx_packet_done;
    wire rx_packet_error;
    wire rx_buffer_valid;

    wire [7:0] rx_payload_len;
    wire [7:0] rx_buf0;
    wire [7:0] rx_buf1;
    wire [7:0] rx_buf2;
    wire [7:0] rx_buf3;
    wire [7:0] rx_buf4;
    wire [7:0] rx_buf5;
    wire [7:0] rx_buf6;
    wire [7:0] rx_buf7;
    wire [7:0] rx_buf8;
    wire [7:0] rx_buf9;
    wire [7:0] rx_buf10;
    wire [7:0] rx_buf11;
    wire [7:0] rx_buf12;
    wire [7:0] rx_buf13;
    wire [7:0] rx_buf14;
    wire [7:0] rx_buf15;

    wire tx_packet_wr;
    wire tx_busy;

    wire [7:0] tx_payload_len;
    wire [7:0] tx_buf0;
    wire [7:0] tx_buf1;
    wire [7:0] tx_buf2;
    wire [7:0] tx_buf3;
    wire [7:0] tx_buf4;
    wire [7:0] tx_buf5;
    wire [7:0] tx_buf6;
    wire [7:0] tx_buf7;
    wire [7:0] tx_buf8;
    wire [7:0] tx_buf9;
    wire [7:0] tx_buf10;
    wire [7:0] tx_buf11;
    wire [7:0] tx_buf12;
    wire [7:0] tx_buf13;
    wire [7:0] tx_buf14;
    wire [7:0] tx_buf15;

    s3g_rx dut(
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .packet_done(rx_packet_done),
        .packet_error(rx_packet_error),
        .payload_len(rx_payload_len),
        .buffer_valid(rx_buffer_valid),
        .buf0(rx_buf0),
        .buf1(rx_buf1),
        .buf2(rx_buf2),
        .buf3(rx_buf3),
        .buf4(rx_buf4),
        .buf5(rx_buf5),
        .buf6(rx_buf6),
        .buf7(rx_buf7),
        .buf8(rx_buf8),
        .buf9(rx_buf9),
        .buf10(rx_buf10),
        .buf11(rx_buf11),
        .buf12(rx_buf12),
        .buf13(rx_buf13),
        .buf14(rx_buf14),
        .buf15(rx_buf15)
    );


    executor dut3(
        .clk(clk),
        .rst(rst),
        .rx_packet_done(rx_packet_done),
        .rx_packet_error(rx_packet_error),
        .rx_payload_len(rx_payload_len),
        .rx_buf0(rx_buf0),
        .rx_buf1(rx_buf1),
        .rx_buf2(rx_buf2),
        .rx_buf3(rx_buf3),
        .rx_buf4(rx_buf4),
        .rx_buf5(rx_buf5),
        .rx_buf6(rx_buf6),
        .rx_buf7(rx_buf7),
        .rx_buf8(rx_buf8),
        .rx_buf9(rx_buf9),
        .rx_buf10(rx_buf10),
        .rx_buf11(rx_buf11),
        .rx_buf12(rx_buf12),
        .rx_buf13(rx_buf13),
        .rx_buf14(rx_buf14),
        .rx_buf15(rx_buf15),

        .tx_busy(tx_busy),
        .tx_packet_wr(tx_packet_wr),
        .tx_payload_len(tx_payload_len),
        .tx_buf0(tx_buf0),
        .tx_buf1(tx_buf1),
        .tx_buf2(tx_buf2),
        .tx_buf3(tx_buf3),
        .tx_buf4(tx_buf4),
        .tx_buf5(tx_buf5),
        .tx_buf6(tx_buf6),
        .tx_buf7(tx_buf7),
        .tx_buf8(tx_buf8),
        .tx_buf9(tx_buf9),
        .tx_buf10(tx_buf10),
        .tx_buf11(tx_buf11),
        .tx_buf12(tx_buf12),
        .tx_buf13(tx_buf13),
        .tx_buf14(tx_buf14),
        .tx_buf15(tx_buf15)
    );

    s3g_tx dut2(
        .clk(clk),
        .rst(rst),
        .tx_done(tx_done),
        .tx_wr(tx_wr),
        .busy(tx_busy),
        .payload_len(tx_payload_len),
        .packet_wr(tx_packet_wr),
        .buf0(tx_buf0),
        .buf1(tx_buf1),
        .buf2(tx_buf2),
        .buf3(tx_buf3),
        .buf4(tx_buf4),
        .buf5(tx_buf5),
        .buf6(tx_buf6),
        .buf7(tx_buf7),
        .buf8(tx_buf8),
        .buf9(tx_buf9),
        .buf10(tx_buf10),
        .buf11(tx_buf11),
        .buf12(tx_buf12),
        .buf13(tx_buf13),
        .buf14(tx_buf14),
        .buf15(tx_buf15)
    );

    reg [3:0] tx_delay;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,dut);
        $dumpvars(0,dut2);
        $dumpvars(0,dut3);
        
        rst = 0;
        clk = 0;
        rx_data = 0;
        rx_done = 0;
        cycle = 0;
        forever
            begin
                clk = 1;
                #3;

                if (rx_done == 1)
                    rx_done = 0;

                if (tx_done == 1)
                    tx_done = 0;

                if (tx_wr == 1)
                    tx_delay = 30;

                if (tx_delay>0)
                begin
                    tx_delay = tx_delay - 1;
                    if (tx_delay == 0)
                        tx_done = 1;
                end

                case (cycle)
                    10: begin
                        rx_data = 13;
                        rx_done = 1;
                    end
                    20: begin
                        rx_data = 8'hD5;
                        rx_done = 1;
                    end
                    30: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    40: begin
                        rx_data = 8'h01;
                        rx_done = 1;
                    end
                    50: begin
                        rx_data = 8'h02;
                        rx_done = 1;
                    end
                    60: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    70: begin
                        rx_data = 8'hCC;
                        rx_done = 1;
                    end
                    120: begin
                        rx_data = 8'hD5;
                        rx_done = 1;
                    end
                    130: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    140: begin
                        rx_data = 8'h01;
                        rx_done = 1;
                    end
                    150: begin
                        rx_data = 8'h02;
                        rx_done = 1;
                    end
                    160: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    170: begin
                        rx_data = 8'hD8;
                        rx_done = 1;
                    end

                    220: begin
                        rx_data = 8'hD5;
                        rx_done = 1;
                    end
                    230: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    240: begin
                        rx_data = 0;
                        rx_done = 1;
                    end
                    250: begin
                        rx_data = 8'h01;
                        rx_done = 1;
                    end
                    260: begin
                        rx_data = 8'h02;
                        rx_done = 1;
                    end
                    270: begin
                        rx_data = 8'h78;
                        rx_done = 1;
                    end

                    320: begin
                        rx_data = 8'hD5;
                        rx_done = 1;
                    end
                    330: begin
                        rx_data = 8'h03;
                        rx_done = 1;
                    end
                    340: begin
                        rx_data = 27;
                        rx_done = 1;
                    end
                    350: begin
                        rx_data = 8'h01;
                        rx_done = 1;
                    end
                    360: begin
                        rx_data = 8'h02;
                        rx_done = 1;
                    end
                    370: begin
                        rx_data = 8'hF3;
                        rx_done = 1;
                    end
                    600: $finish;
                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
            end
    end


endmodule
