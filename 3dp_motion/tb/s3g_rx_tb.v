`include "../src/s3g_rx.v"
`include "../src/s3g_tx.v"
`include "../src/s3g_executor.v"
`include "../src/buf_executor.v"

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

wire ext_out_reg_busy;
wire [31:0] reg13;

wire [31:0] ext_out_reg_data;
wire [5:0] ext_out_reg_addr;
wire ext_out_reg_stb;

wire [31:0] ext_out_stbs;
wire [31:0] ext_pending_ints;
wire [31:0] ext_clear_ints;

reg int4;
reg int14;
wire [7:0] rx_buffer_addr;
wire [7:0] rx_buffer_data;
wire [7:0] ext_buffer_error;
wire [15:0] ext_buffer_pc;
wire [15:0] ext_buffer_addr;
wire [39:0] ext_buffer_data;
wire ext_buffer_wr;

wire[31:0] out_stbs;
wire int0;

reg done;

wire[31:0] out_reg1;

reg [2047:0] packet = 512'hD50123456789;
reg send_packet = 0;

s3g_rx dut_rx(
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
           .buf15(rx_buf15),
           .buffer_addr(rx_buffer_addr),
           .buffer_data(rx_buffer_data)
       );


s3g_executor #(100) dut_exec(
             .clk(clk),
             .rst(rst),
             .rx_packet_done(rx_packet_done),
             .rx_packet_error(rx_packet_error),
             .rx_payload_len(rx_payload_len),
             .rx_buffer_valid(rx_buffer_valid),
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

             .out_stbs(out_stbs),

             .out_reg1(out_reg1),
             .out_reg13(reg13),
             .in_reg13(reg13),

             .int0(int0),
             .int1(1'b0),
             .int2(1'b0),
             .int3(1'b0),
             .int4(int4),
             .int5(1'b0),
             .int6(1'b0),
             .int7(1'b0),
             .int8(1'b0),
             .int9(1'b0),
             .int10(1'b0),
             .int11(1'b0),
             .int12(1'b0),
             .int13(1'b0),
             .int14(int14),
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
             .int31(1'b0),
             .ext_out_reg_busy(ext_out_reg_busy),
             .ext_out_reg_data(ext_out_reg_data),
             .ext_out_reg_addr(ext_out_reg_addr),
             .ext_out_reg_stb(ext_out_reg_stb),

             .ext_buffer_addr(ext_buffer_addr),
             .ext_buffer_data(ext_buffer_data),
             .ext_buffer_wr(ext_buffer_wr),
             .ext_buffer_pc(ext_buffer_pc),
             .ext_buffer_error(ext_buffer_error),
             .ext_pending_ints(ext_pending_ints),
             .ext_clear_ints(ext_clear_ints),
             .ext_out_stbs(ext_out_stbs)
         );

s3g_tx dut_tx(
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

buf_executor dut_be(
           .clk(clk),
           .rst(rst),

           .ext_out_reg_addr(ext_out_reg_addr),
           .ext_out_reg_data(ext_out_reg_data),
           .ext_out_reg_stb(ext_out_reg_stb),
           .ext_out_reg_busy(ext_out_reg_busy),

           .ext_buffer_addr(ext_buffer_addr),
           .ext_buffer_data(ext_buffer_data),
           .ext_buffer_wr(ext_buffer_wr),
           .pc(ext_buffer_pc),
           .error(ext_buffer_error),

           .start(out_stbs[0]),
           .start_addr(out_reg1[15:0]),
           .done(done),
           .abort(out_stbs[1]),
           .load(load),
           .complete(int0),
           .ext_pending_ints(ext_pending_ints),
           .ext_clear_ints(ext_clear_ints),
           .ext_out_stbs(ext_out_stbs)
);


reg [3:0] tx_delay;
integer lp;

initial
    begin
        $dumpfile("test.vcd");
        $dumpvars;
        for (lp=0; lp<512; lp = lp+1) $dumpvars(0, dut_be.buffer[lp]);
        /* $dumpvars(0,dut);
        $dumpvars(0,dut2);
        $dumpvars(0,dut3); */

        rx_data = 0;
        rx_done = 0;
        tx_done = 0;
        int4 = 0;
        int14 = 0;
        rst = 1;
        clk = 0;
        #5;
        clk = 1;
        #5;
        clk = 0;
        #5;
        clk = 1;
        #5;
        clk = 0;
        #3;
        rst = 0;
        #2;
        clk = 1;
        #5;
        clk = 0;
        #5;
        clk = 1;
        #5;
        clk = 0;
        #5;
        clk = 1;
        #5;
        clk = 0;
        #5;
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
                    tx_delay = 5;

                if (int4 == 1)
                    int4 = 0;

                if (int14 == 1)
                    int14 = 0;

                if (tx_delay>0)
                    begin
                        tx_delay = tx_delay - 1;
                        if (tx_delay == 0)
                            tx_done = 1;
                    end

                case (cycle)
                    10:
                        begin
                            packet = 512'h0DD50301020304; // spare byte and wrong checksum
                            send_packet = 1;
                        end

                    120:
                        begin
                            packet = 512'hD503010203; // unknown command
                            send_packet = 1;
                        end

                    220:
                        begin
                            packet = 512'hD503000203; // version cmd
                            send_packet = 1;
                        end

                    320:
                        begin
                            packet = 512'hD5031B0102; // extended version cmd
                            send_packet = 1;
                        end

                    420:
                        begin
                            packet = 512'hD5063C0D01020304; // write reg cmd
                            send_packet = 1;
                        end


                    520:
                        begin
                            packet = 512'hD5023D0D; // read reg cmd
                            send_packet = 1;
                        end

                    620:
                        begin
                            packet = 512'hD5053E01020408; // out stb cmd
                            send_packet = 1;
                        end

                    700:
                        begin
                            int4 <= 1;
                        end


                    820:
                        begin
                            packet = 512'hD5053FFF000000; // clear ints
                            send_packet = 1;
                        end

                    920:
                        begin
                            packet = 512'hD5054000FF0000; // set int mask
                            send_packet = 1;
                        end

                    1050:
                        begin
                            int4 <= 1;
                        end

                    1100:
                        begin
                            int14 <= 1;
                        end

                    1200:
                        begin
                            packet = 512'hD5053FFFFF0000; // clear ints
                            send_packet = 1;
                        end

                    1300:
                        begin
                            packet = 512'hD51841041001010203044E111213144D040408088100000000BF; // write buffer
                            send_packet = 1;
                        end
                    1650:
                        begin
                            packet = 512'hD5063C0110010000; // write reg cmd
                            send_packet = 1;
                        end

                    1780:
                        begin
                            packet = 512'hD5053E01000000; // out stb cmd
                            send_packet = 1;
                        end

                    2500:
                        $finish;

                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
            end
    end

integer ppos, first;
always @(negedge clk)
    begin
        if (send_packet)
        begin
            $display("send", packet, $time);
            send_packet <= 0;
            first = 1;
            for (ppos = 2047; ppos>0; ppos = ppos - 8)
            begin
                if (first)
                    begin
                        if (packet[ppos-:8] != 0)
                            begin
                                first = 0;
                                rx_data = packet[ppos-:8];
                                rx_done = 1;
                                $display("time: %g send %h", $time, rx_data);
                                #100;
                            end
                    end
                else
                    begin
                        rx_data = packet[ppos-:8];
                        rx_done = 1;
                        $display("time: %g send %h", $time, rx_data);
                        #100;
                    end
            end
            rx_data = dut_rx.crc;
            rx_done = 1;
            $display("time: %g send crc %h", $time, rx_data);
            #100;
           
        end
    end


endmodule
