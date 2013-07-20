module dds_uart_clock(
        clk,
        baudrate,
        enable_16
    );

    input clk;
    input [15:0] baudrate;
    output reg enable_16;

    reg [17:0] accum = 0;

    always @(posedge clk)
    begin
        if (accum > 62500)
            begin
                accum <= accum + baudrate - 62500;
                enable_16 <= 1;
            end
        else
            begin
                accum <= accum + baudrate;
                enable_16 <= 0;
            end
    end

endmodule

module top(osc_clk, 
           rxd, 
           led0, 
           led1, 
           led2, 
           led3, 
           led4, 
           led5, 
           led6, 
           led7, 
           txd);

    input osc_clk;

   output led0;
   output led1;
   output led2;
   output led3;
   output led4;
   output led5;
   output led6;
   output led7;

    input rxd;
   output txd;
   
   reg [31:0] cnt = 0;

   wire enable_16;
   wire rst;
   wire [7:0] rx_data;
   wire [7:0] tx_data;
   wire rx_done;
   wire tx_wr;
   wire tx_done;
   
   reg blym = 0;

   assign led0 = rx_data[0];
   assign led1 = rx_data[1];
   assign led2 = rx_data[2];
   assign led3 = rx_data[3];
   assign led4 = rx_data[4];
   assign led5 = rx_data[5];
   assign led6 = rx_data[6];
   assign led7 = rx_data[7];

   assign tx_data = rx_data;
   assign tx_wr = rx_done;
   assign rst = 0;

    always @(posedge osc_clk)
    begin
        cnt <= cnt + 1;
        if (enable_16)
            blym <= ~blym;
    end

    dds_uart_clock uclock1(
        .clk(osc_clk),
        .baudrate(2142),
        .enable_16(enable_16)
    );

    uart_transceiver uart1(
        .sys_clk(osc_clk),
        .sys_rst(rst),
        .uart_rx(rxd),
        .uart_tx(txd),
        .enable_16(enable_16),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .tx_data(tx_data),
        .tx_wr(tx_wr),
        .tx_done(tx_done)
    );


endmodule
