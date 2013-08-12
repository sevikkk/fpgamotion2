`include "../src/acc_step_gen.v"

module acc_tb;

reg clk;
reg reset;
reg load;
reg [31:0] dt_val;
reg [31:0] steps_val;

reg [31:0] cycle;

acc_step_gen dut1(
           .clk(clk),
           .reset(reset),
           .dt_val(dt_val),
           .steps_val(steps_val),
           .load(load)
       );

initial
    begin
        $dumpfile("test.vcd");
        $dumpvars;

        reset = 1;
        load = 0;
        dt_val = 0;
        steps_val = 0;
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

                if (load == 1)
                    load = 0;

                case (cycle)
                    10:
                        begin
                            dt_val = 20;
                            steps_val = 3;
                            load = 1;
                        end

                    86:
                        begin
                            load = 1;
                        end
                    180:
                        begin
                            load = 1;
                        end

                    1500:
                        $finish;

                endcase

                #2;
                clk = 0;
                #5;
                cycle = cycle + 1;
                $display(cycle);
            end
    end


endmodule
