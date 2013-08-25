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

wire rst;

wire enable_16;

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

wire [31:0] stbs;

wire [31:0] out_reg0;
wire [31:0] out_reg1;
wire [31:0] out_reg2;
wire [31:0] out_reg3;
wire [31:0] out_reg4;
wire [31:0] out_reg5;
wire [31:0] out_reg6;
wire [31:0] out_reg7;
wire [31:0] out_reg8;
wire [31:0] out_reg9;
wire [31:0] out_reg10;
wire [31:0] out_reg11;
wire [31:0] out_reg12;
wire [31:0] out_reg13;
wire [31:0] out_reg14;
wire [31:0] out_reg15;
wire [31:0] out_reg16;
wire [31:0] out_reg17;
wire [31:0] out_reg18;
wire [31:0] out_reg19;
wire [31:0] out_reg20;
wire [31:0] out_reg21;
wire [31:0] out_reg22;
wire [31:0] out_reg23;
wire [31:0] out_reg24;
wire [31:0] out_reg25;
wire [31:0] out_reg26;
wire [31:0] out_reg27;
wire [31:0] out_reg28;
wire [31:0] out_reg29;
wire [31:0] out_reg30;
wire [31:0] out_reg31;
wire [31:0] out_reg32;
wire [31:0] out_reg33;
wire [31:0] out_reg34;
wire [31:0] out_reg35;
wire [31:0] out_reg36;
wire [31:0] out_reg37;
wire [31:0] out_reg38;
wire [31:0] out_reg39;
wire [31:0] out_reg40;
wire [31:0] out_reg41;
wire [31:0] out_reg42;
wire [31:0] out_reg43;
wire [31:0] out_reg44;
wire [31:0] out_reg45;
wire [31:0] out_reg46;
wire [31:0] out_reg47;
wire [31:0] out_reg48;
wire [31:0] out_reg49;
wire [31:0] out_reg50;
wire [31:0] out_reg51;
wire [31:0] out_reg52;
wire [31:0] out_reg53;
wire [31:0] out_reg54;
wire [31:0] out_reg55;
wire [31:0] out_reg56;
wire [31:0] out_reg57;
wire [31:0] out_reg58;
wire [31:0] out_reg59;
wire [31:0] out_reg60;
wire [31:0] out_reg61;
wire [31:0] out_reg62;
wire [31:0] out_reg63;

wire [31:0] in_reg0;
wire [31:0] in_reg1;
wire [31:0] in_reg2;
wire [31:0] in_reg3;
wire [31:0] in_reg4;
wire [31:0] in_reg5;
wire [31:0] in_reg6;
wire [31:0] in_reg7;
wire [31:0] in_reg8;
wire [31:0] in_reg9;

wire int0;
wire int30;
wire abort;
wire acc_step;
wire debug_as;
wire debug_ad;
wire debug_bd;

wire x_step;
wire x_dir;
wire y_step;
wire y_dir;
wire z_step;
wire z_dir;
wire a_step;
wire a_dir;

wire motor_x_step;
wire motor_x_dir;
wire motor_y_step;
wire motor_y_dir;
wire motor_z_step;
wire motor_z_dir;
wire motor_a_step;
wire motor_a_dir;

wire [15:0] ext_buffer_addr;
wire [39:0] ext_buffer_data;
wire ext_buffer_wr;

wire [7:0] ext_buffer_error;
wire [15:0] ext_buffer_pc;

wire [31:0] ext_out_reg_data;
wire [5:0] ext_out_reg_addr;
wire ext_out_reg_stb;
wire ext_out_reg_busy;

wire [31:0] ext_out_stbs;
wire [31:0] ext_pending_ints;
wire [31:0] ext_clear_ints;

wire load_be;
wire load;

always @(posedge osc_clk)
    begin
        cnt <= cnt + 1;
    end

assign rst = 0;
assign j1[0] = motor_x_step;
assign j1[1] = motor_y_step;
assign j1[2] = motor_z_step;
assign j1[3] = motor_a_step;
assign j1[6:4] = 0;
assign j1[7] = motor_x_dir;
assign j1[8] = motor_y_dir;
assign j1[9] = motor_z_dir;
assign j1[10] = motor_a_dir;
assign j1[14:11] = 0;
assign j1[18:15] = out_reg0[29:26];
assign j1[24:19] = 0;
assign j1[25] = debug_bd;
assign j1[26] = debug_ad;
assign j1[27] = debug_as;

assign j2[13:0] = out_reg63[13:0];
assign j3[13:0] = cnt[25:12];
assign j4[17:0] = cnt[25:8];
assign j5 = cnt[12];
assign j6[4:0] = cnt[16:12];
assign sd[3:0] = cnt[15:12];

assign load = stbs[0] | load_be;

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

s3g_executor s3g_exec1(
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

             .out_stbs(stbs),

             .out_reg0(out_reg0),
             .out_reg1(out_reg1),
             .out_reg2(out_reg2),
             .out_reg3(out_reg3),
             .out_reg4(out_reg4),
             .out_reg5(out_reg5),
             .out_reg6(out_reg6),
             .out_reg7(out_reg7),
             .out_reg8(out_reg8),
             .out_reg9(out_reg9),
             .out_reg10(out_reg10),
             .out_reg11(out_reg11),
             .out_reg12(out_reg12),
             .out_reg13(out_reg13),
             .out_reg14(out_reg14),
             .out_reg15(out_reg15),
             .out_reg16(out_reg16),
             .out_reg17(out_reg17),
             .out_reg18(out_reg18),
             .out_reg19(out_reg19),
             .out_reg20(out_reg20),
             .out_reg21(out_reg21),
             .out_reg22(out_reg22),
             .out_reg23(out_reg23),
             .out_reg24(out_reg24),
             .out_reg25(out_reg25),
             .out_reg26(out_reg26),
             .out_reg27(out_reg27),
             .out_reg28(out_reg28),
             .out_reg29(out_reg29),
             .out_reg30(out_reg30),
             .out_reg31(out_reg31),
             .out_reg32(out_reg32),
             .out_reg33(out_reg33),
             .out_reg34(out_reg34),
             .out_reg35(out_reg35),
             .out_reg36(out_reg36),
             .out_reg37(out_reg37),
             .out_reg38(out_reg38),
             .out_reg39(out_reg39),
             .out_reg40(out_reg40),
             .out_reg41(out_reg41),
             .out_reg42(out_reg42),
             .out_reg43(out_reg43),
             .out_reg44(out_reg44),
             .out_reg45(out_reg45),
             .out_reg46(out_reg46),
             .out_reg47(out_reg47),
             .out_reg48(out_reg48),
             .out_reg49(out_reg49),
             .out_reg50(out_reg50),
             .out_reg51(out_reg51),
             .out_reg52(out_reg52),
             .out_reg53(out_reg53),
             .out_reg54(out_reg54),
             .out_reg55(out_reg55),
             .out_reg56(out_reg56),
             .out_reg57(out_reg57),
             .out_reg58(out_reg58),
             .out_reg59(out_reg59),
             .out_reg60(out_reg60),
             .out_reg61(out_reg61),
             .out_reg62(out_reg62),
             .out_reg63(out_reg63),

             .in_reg0(in_reg0),
             .in_reg1(in_reg1),
             .in_reg2(in_reg2),
             .in_reg3(in_reg3),
             .in_reg4(in_reg4),
             .in_reg5(in_reg5),
             .in_reg6(in_reg6),
             .in_reg7(in_reg7),
             .in_reg8(in_reg8),
             .in_reg9(in_reg9),

             .in_reg63(out_reg63),

             .int0(int0),
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
             .int30(int30),
             .int31(stbs[31]),

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

buf_executor buf_exec1(
           .clk(osc_clk),
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

           .start(stbs[30]),
           .start_addr(out_reg62[15:0]),
           .done(done),
           .abort(stbs[29]),
           .load(load_be),
           .complete(int30),
           .ext_pending_ints(ext_pending_ints),
           .ext_clear_ints(ext_clear_ints),
           .ext_out_stbs(ext_out_stbs)
);

acc_step_gen acc_step1 (
             .clk(osc_clk),
             .reset(rst),
             .dt_val(out_reg1),
             .steps_val(out_reg2),
             .load(load),
             .set_dt_limit(out_reg0[0]),
             .set_steps_limit(out_reg0[1]),
             .reset_dt(out_reg0[2]),
             .reset_steps(out_reg0[3]),
             .dt(in_reg1),
             .steps(in_reg2),
             .abort(abort),
             .step_stb(acc_step),
             .done(int0)
);

acc_profile_gen acc_profile_x (
             .clk(osc_clk),
             .reset(rst),
             .acc_step(acc_step),
             .abort(abort),
             .load(load),
             .set_x(out_reg0[4]),
             .set_v(out_reg0[5]),
             .set_a(out_reg0[6]),
             .set_j(out_reg0[7]),
             .step_bit(out_reg0[25:20]),
             .x_val({out_reg4, out_reg3}),
             .v_val(out_reg5),
             .a_val(out_reg6),
             .j_val(out_reg7),
             .abort_a_val(out_reg8),
             .step(x_step),
             .dir(x_dir)
);

acc_profile_gen acc_profile_y (
             .clk(osc_clk),
             .reset(rst),
             .acc_step(acc_step),
             .abort(abort),
             .load(load),
             .set_x(out_reg0[8]),
             .set_v(out_reg0[9]),
             .set_a(out_reg0[10]),
             .set_j(out_reg0[11]),
             .step_bit(out_reg0[25:20]),
             .x_val({out_reg10, out_reg9}),
             .v_val(out_reg11),
             .a_val(out_reg12),
             .j_val(out_reg13),
             .abort_a_val(out_reg14),
             .step(y_step),
             .dir(y_dir)
);

acc_profile_gen acc_profile_z (
             .clk(osc_clk),
             .reset(rst),
             .acc_step(acc_step),
             .abort(abort),
             .load(load),
             .set_x(out_reg0[12]),
             .set_v(out_reg0[13]),
             .set_a(out_reg0[14]),
             .set_j(out_reg0[15]),
             .step_bit(out_reg0[25:20]),
             .x_val({out_reg16, out_reg15}),
             .v_val(out_reg17),
             .a_val(out_reg18),
             .j_val(out_reg19),
             .abort_a_val(out_reg20),
             .step(z_step),
             .dir(z_dir)
);


acc_profile_gen acc_profile_a (
             .clk(osc_clk),
             .reset(rst),
             .acc_step(acc_step),
             .abort(abort),
             .load(load),
             .set_x(out_reg0[16]),
             .set_v(out_reg0[17]),
             .set_a(out_reg0[18]),
             .set_j(out_reg0[19]),
             .step_bit(out_reg0[25:20]),
             .x_val({out_reg22, out_reg21}),
             .v_val(out_reg23),
             .a_val(out_reg24),
             .j_val(out_reg25),
             .abort_a_val(out_reg26),
             .step(a_step),
             .dir(a_dir)
);


motor_step_gen motor_x(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(out_reg27),
    .pulse_n(out_reg28),
    .post_n(out_reg29),
    .step_stb(x_step),
    .step_dir(x_dir),
    .step(motor_x_step),
    .dir(motor_x_dir)
);

motor_step_gen motor_y(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(out_reg27),
    .pulse_n(out_reg28),
    .post_n(out_reg29),
    .step_stb(y_step),
    .step_dir(y_dir),
    .step(motor_y_step),
    .dir(motor_y_dir)
);

motor_step_gen motor_z(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(out_reg27),
    .pulse_n(out_reg28),
    .post_n(out_reg29),
    .step_stb(z_step),
    .step_dir(z_dir),
    .step(motor_z_step),
    .dir(motor_z_dir)
);

motor_step_gen motor_a(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(out_reg27),
    .pulse_n(out_reg28),
    .post_n(out_reg29),
    .step_stb(a_step),
    .step_dir(a_dir),
    .step(motor_a_step),
    .dir(motor_a_dir)
);

motor_step_gen debug_acc(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(250),
    .pulse_n(750),
    .post_n(1000),
    .step_stb(acc_step),
    .step_dir(0),
    .step(debug_as)
);

motor_step_gen debug_done(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(25000),
    .pulse_n(75000),
    .post_n(100000),
    .step_stb(int0),
    .step_dir(0),
    .step(debug_ad)
);

motor_step_gen debug_buf_done(
    .clk(osc_clk),
    .reset(rst),
    .pre_n(25000),
    .pulse_n(75000),
    .post_n(100000),
    .step_stb(int1),
    .step_dir(0),
    .step(debug_bd)
);
endmodule
