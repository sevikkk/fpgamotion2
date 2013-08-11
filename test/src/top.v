module top(
    input osc_clk, 
    input rxd, 
    output txd,
    output reg led0, 
    output reg led1, 
    output reg led2, 
    output reg led3, 
    output reg led4, 
    output reg led5, 
    output reg led6, 
    output reg led7, 
    output [27:0] j1,
    output [13:0] j2,
    output [13:0] j3,
    output [17:0] j4,
    output j5,
    output [4:0] j6,
    output [3:0] sd
);
   
   reg [31:0] cnt = 0;

   wire enable_16;
   wire rst;

    wire [7:0] rx_data;
    wire rx_done;

    wire tx_done;
    wire tx_wr;
    wire [7:0] tx_data;

    wire rx_packet_done;
    wire rx_packet_error;
    wire rx_buffer_valid;

    wire [7:0] rx_buffer_addr;
    wire [7:0] rx_buffer_data;

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

    wire [31:0] reg13;

   assign rst = 0;

   always @(posedge osc_clk)
   begin
        cnt <= cnt + 1;
   end

   assign j1[27:14] = cnt[25:12];
   assign j1[13:0] = cnt[25:12] & cnt[26:11];
   assign j2[13:0] = reg13[13:0];
   assign j3[13:0] = cnt[25:12];
   assign j4[17:0] = cnt[25:8];
   assign j5 = cnt[12];
   assign j6[4:0] = cnt[16:12];
   assign sd[3:0] = cnt[15:12];

   always @(posedge osc_clk)
   begin
       led0 <= rx_payload_len[0];
       led1 <= rx_payload_len[1];
       led2 <= rx_payload_len[2];
       led3 <= rx_payload_len[3];
       led4 <= rx_payload_len[4];
       led5 <= rx_payload_len[5];
       led6 <= rx_payload_len[6];
       led7 <= rx_buffer_valid;
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
        .buf15(rx_buf15),
        .buffer_addr(rx_buffer_addr),
        .buffer_data(rx_buffer_data)
    );

    s3g_tx s3g_tx1(
        .clk(osc_clk),
        .rst(rst),
        .tx_data(tx_data),
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

    executor #(100) dut3(
        .clk(osc_clk),
        .rst(rst),
        .rx_packet_done(rx_packet_done),
        .rx_packet_error(rx_packet_error),
        .rx_buffer_valid(rx_buffer_valid),
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
        .next_rx_buffer_addr(rx_buffer_addr),
        .rx_buffer_data(rx_buffer_data),

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
        .tx_buf15(tx_buf15),

        .out_reg13(reg13),
        .in_reg13(reg13),

        .int0(1'b0),
        .int1(1'b0),
        .int2(1'b0),
        .int3(1'b0),
        .int4(1'b0),
        .int5(1'b0),
        .int6(1'b0),
        .int7(1'b0),
        .int8(1'b0),
        .int9(1'b0),
        .int10(1'b0),
        .int11(1'b0),
        .int12(1'b0),
        .int13(1'b0),
        .int14(1'b0),
        .int15(1'b0),
        .int16(1'b0),
        .int17(1'b0),
        .int18(1'b0),
        .int19(1'b0),
        .int20(1'b0),
        .int21(1'b0),
        .int22(1'b0),
        .int23(1'b0),
        .int24(1'b0),
        .int25(1'b0),
        .int26(1'b0),
        .int27(1'b0),
        .int28(1'b0),
        .int29(1'b0),
        .int30(1'b0),
        .int31(1'b0)
    );

endmodule
