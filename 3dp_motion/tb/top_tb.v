`include "../src/acc_step_gen.v"
`include "../src/acc_profile_gen.v"
`include "../src/motor_step_gen.v"
`include "../src/top.v"

module top_tb;

reg clk;
reg reset;

reg [63:0] cycle;

wire rxd;

top dut(
           .osc_clk(clk),
           .rst(reset),
           .rxd(rxd)
       );

initial
    begin
        $dumpfile("test.vcd");
        $dumpvars;

        reset = 1;
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
        reset = 0;
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

                case (cycle)
                    10:
                        begin
                        end

                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
                $display(cycle);
            end
    end


endmodule
