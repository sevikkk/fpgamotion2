module s3g_rx_tb;

    reg [7:0] rx_data;
    reg rx_done;
    reg clk;
    reg rst;
    reg [31:0] cycle;

    s3g_rx dut(
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    initial begin
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
                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
            end;
    end;


endmodule
