module top_xc2v(
           input osc_clk,
           input rxd,
           output txd,
           output led0,
           output led1,
           output led2,
           output led3,
           output led4,
           output led5,
           output led6,
           output led7,
           output j7_5,
           output j7_6,
           output j7_9,
           output j7_10,
           output j7_11,
           output j7_12,
           output j7_13,
           output j7_14,

           output j4_1,
           output j4_2,
           output j4_3,
           output j4_4,
           output j4_5,
           output j4_6,
           output j4_7,
           output j4_8,

           output j4_11,
           output j4_12,
           output j4_13,
           output j4_14,
           output j4_15,
           output j4_16,
           output j4_17,
           output j4_18
       );

wire rst;

wire motor_x_step;
wire motor_x_dir;
wire motor_x_enable;
wire motor_y_step;
wire motor_y_dir;
wire motor_y_enable;
wire motor_z_step;
wire motor_z_dir;
wire motor_z_enable;
wire motor_a_step;
wire motor_a_dir;
wire motor_a_enable;

assign rst = 0;
assign j4_2 = motor_x_step;
assign j4_4 = motor_y_step;
assign j4_6 = motor_z_step;
assign j4_8 = motor_a_step;
assign j4_1 = motor_x_dir;
assign j4_3 = motor_y_dir;
assign j4_5 = motor_z_dir;
assign j4_7 = motor_a_dir;
assign j4_11 = motor_x_enable;
assign j4_12 = motor_y_enable;
assign j4_13 = motor_z_enable;
assign j4_14 = motor_a_enable;
assign j7_11 = 0;
assign j7_12 = 0;
assign j7_13 = 0;

assign j7_5 = 0;
assign j7_6 = 0;
assign j7_9 = 0;
assign j7_10 = 0;
assign j7_14 = 0;

assign j4_15 = 0;
assign j4_16 = 0;
assign j4_17 = 0;
assign j4_18 = 0;

assign led0 = 0;
assign led1 = 0;
assign led2 = 0;
assign led3 = 0;
assign led4 = 0;
assign led5 = 0;
assign led6 = 0;
assign led7 = 0;

fpgamotion #(.UART_TOP(15000)) uclock1(
	.osc_clk(osc_clk),
	.rst(rst),
	.rxd(rxd),
	.txd(txd),
	.motor_x_step(motor_x_step),
	.motor_x_dir(motor_x_dir),
	.motor_x_enable(motor_x_enable),
	.motor_y_step(motor_y_step),
	.motor_y_dir(motor_y_dir),
	.motor_y_enable(motor_y_enable),
	.motor_z_step(motor_z_step),
	.motor_z_dir(motor_z_dir),
	.motor_z_enable(motor_z_enable),
	.motor_a_step(motor_a_step),
	.motor_a_dir(motor_a_dir),
	.motor_a_enable(motor_a_enable)
);

endmodule
