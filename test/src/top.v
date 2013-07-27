module top(osc_clk, 
           rxd, 
           txd,
           led0, 
           led1, 
           led2, 
           led3, 
           led4, 
           led5, 
           led6, 
           led7, 
           j1,
           j2,
           j3,
           j4,
           j5,
           j6,
           sd
       );


    input osc_clk;

   output reg led0;
   output reg led1;
   output reg led2;
   output reg led3;
   output reg led4;
   output reg led5;
   output reg led6;
   output reg led7;
   output [27:0] j1;
   output [13:0] j2;
   output [13:0] j3;
   output [17:0] j4;
   output j5;
   output [4:0] j6;
   output [3:0] sd;

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
   wire [7:0] payload_len;
   wire buffer_valid;
   wire packet_done;

   wire [7:0] pkt_len;
   wire [7:0] pkt_b0;
   wire [7:0] pkt_b1;
   wire [7:0] pkt_b2;
   
   reg blym = 0;
   
   assign j1[27:14] = cnt[25:12];
   assign j1[13:0] = cnt[25:12] & cnt[26:11];
   assign j2[13:0] = cnt[25:12];
   assign j3[13:0] = cnt[25:12];
   assign j4[17:0] = cnt[25:8];
   assign j5 = cnt[12];
   assign j6[4:0] = cnt[16:12];
   assign sd[3:0] = cnt[15:12];

    always @(posedge osc_clk)
    begin
       led0 <= payload_len[0];
       led1 <= payload_len[1];
       led2 <= payload_len[2];
       led3 <= payload_len[3];
       led4 <= payload_len[4];
       led5 <= payload_len[5];
       led6 <= payload_len[6];
       led7 <= buffer_valid;
   end

   assign rst = 0;

    always @(posedge osc_clk)
    begin
        cnt <= cnt + 1;
        if (enable_16)
            blym <= ~blym;
    end

    dds_uart_clock uclock1(
        .clk(osc_clk),
        .baudrate(7525),
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

    s3g_rx s3g_rx1(
        .clk(osc_clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .payload_len(payload_len),
        .buffer_valid(buffer_valid),
        .packet_done(packet_done)
    );

   assign pkt_len = 8'h03;
   assign pkt_b0 = 8'h81;
   assign pkt_b1 = 8'hBA;
   assign pkt_b2 = 8'hCE;

    s3g_tx s3g_tx1(
        .clk(osc_clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_wr(tx_wr),
        .packet_wr(packet_done),
        .payload_len(pkt_len),
        .buf0(pkt_b0),
        .buf1(pkt_b1),
        .buf2(pkt_b2)
    );
endmodule
