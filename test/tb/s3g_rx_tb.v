`include "../src/s3g_rx.v"
`include "../src/s3g_tx.v"
`include "../src/executor.v"

module s3g_rx_tb;

    reg [7:0] rx_data;
    reg rx_done;
    reg clk;
    reg rst;
    reg [31:0] cycle;
    reg packet_wr;
    reg tx_done;
    wire tx_wr;

    s3g_rx dut(
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    s3g_tx dut2(
        .clk(clk),
        .rst(rst),
        .tx_done(tx_done),
        .tx_wr(tx_wr),
        .payload_len(8'h3),
        .packet_wr(packet_wr),
        .buf0(8'h1),
        .buf1(8'h2),
        .buf2(8'h3)
    );

    executor dut3(
        .clk(clk),
        .rst(rst),
        .tx_done(tx_done)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,dut);
        $dumpvars(0,dut2);
        
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

                if (packet_wr == 1)
                    packet_wr = 0;

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
                    80: begin
                            packet_wr = 1;
                        end
                    90: tx_done = 1;
                    100: tx_done = 1;
                    110: tx_done = 1;
                    120: tx_done = 1;
                    130: tx_done = 1;
                    140: tx_done = 1;
                    400: $finish;
                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
            end
    end


endmodule
