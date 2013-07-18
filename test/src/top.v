////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 13.3
//  \   \         Application : sch2hdl
//  /   /         Filename : top.vf
// /___/   /\     Timestamp : 09/19/2012 01:12:31
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: sch2hdl -intstyle ise -family virtex5 -verilog /home/seva/src/xc4v_test/top.vf -w /home/seva/src/xc4v_test/top.sch
//Design Name: top
//Device: virtex5
//Purpose:
//    This verilog netlist is translated from an ECS schematic.It can be 
//    synthesized and simulated, but it should not be modified. 
//
`timescale 100 ps / 10 ps

module CB16CE_HXILINX_top(CEO, Q, TC, C, CE, CLR);
   
   parameter TERMINAL_COUNT = 16'b1111_1111_1111_1111;
   
   output             CEO;
   output [15:0]      Q;
   output             TC;

   input 	      C;	
   input 	      CE;	
   input 	      CLR;	
   
   reg    [15:0]      Q;
   
   always @(posedge C or posedge CLR)
     begin
	if (CLR)
	  Q <= 16'b0000_0000_0000_0000;
	else if (CE)
	  Q <= Q + 1;
     end
   
   assign CEO = TC & CE;
   assign TC = CLR ? 1'b0 : (Q == TERMINAL_COUNT);
   
endmodule
`timescale 1ns / 1ps

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
    input rxd;
   output led0;
   output led1;
   output led2;
   output led3;
   output led4;
   output led5;
   output led6;
   output led7;
   output txd;
   
   wire [31:0] q;
   wire XLXN_4;
   wire XLXN_12;
   wire XLXN_23;
   wire XLXN_26;
   wire XLXN_29;
   
   (* HU_SET = "XLXI_1_0" *) 
   CB16CE_HXILINX_top  XLXI_1 (.C(osc_clk), 
                              .CE(XLXN_4), 
                              .CLR(XLXN_12), 
                              .CEO(XLXN_26), 
                              .Q(q[15:0]), 
                              .TC());
   VCC  XLXI_3 (.P(XLXN_4));
   GND  XLXI_4 (.G(XLXN_12));
   BUF  XLXI_5 (.I(q[15]), 
               .O(led0));
   BUF  XLXI_6 (.I(q[14]), 
               .O(led1));
   BUF  XLXI_7 (.I(q[13]), 
               .O(led2));
   BUF  XLXI_9 (.I(q[25]), 
               .O(led3));
   BUF  XLXI_10 (.I(XLXN_23), 
                .O(led4));
   BUF  XLXI_11 (.I(XLXN_29), 
                .O(led5));
   BUF  XLXI_12 (.I(XLXN_23), 
                .O(led6));
   BUF  XLXI_13 (.I(XLXN_29), 
                .O(led7));
   GND  XLXI_14 (.G(XLXN_29));
   VCC  XLXI_15 (.P(XLXN_23));
   (* HU_SET = "XLXI_16_1" *) 
   CB16CE_HXILINX_top  XLXI_16 (.C(osc_clk), 
                               .CE(XLXN_26), 
                               .CLR(XLXN_12), 
                               .CEO(), 
                               .Q(q[31:16]), 
                               .TC());
   BUF  XLXI_17 (.I(rxd), 
                .O(txd));
endmodule
