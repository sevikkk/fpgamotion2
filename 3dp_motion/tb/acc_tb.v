`include "../src/acc_step_gen.v"
`include "../src/acc_profile_gen.v"

module acc_tb;

reg clk;
reg reset;
reg load;
reg [31:0] dt_val;
reg [31:0] steps_val;

reg [31:0] cycle;

wire acc_step;
wire abort;
wire done;

reg set_x;
reg set_v;
reg set_a;
reg set_j;

reg [31:0] a_val;
reg [31:0] j_val;

acc_step_gen acc_step_dut(
           .clk(clk),
           .reset(reset),
           .dt_val(dt_val),
           .steps_val(steps_val),
           .load(load),
           .step_stb(acc_step),
           .abort(abort),
           .done(done)
       );

acc_profile_gen acc_profile_dut(
           .clk(clk),
           .reset(reset),
           .acc_step(acc_step),
           .load(load),
           .set_x(set_x),
           .set_v(set_v),
           .set_a(set_a),
           .set_j(set_j),
           .a_val(a_val),
           .j_val(j_val),
           .step_bit(15),
           .abort(abort),
           .abort_a_val(1500)
       );

initial
    begin
        $dumpfile("test.vcd");
        $dumpvars;

        reset = 1;
        load = 0;
        dt_val = 0;
        steps_val = 0;
        set_x = 0;
        set_v = 0;
        set_a = 0;
        set_j = 0;
        a_val = 0;
        j_val = 0;
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
                            dt_val = 200;
                            steps_val = 3;
                            load = 1;
                            a_val = 200;
                            set_a = 1;
                        end

                    803:
                        begin
                            a_val = 1000;
                            load = 1;
                        end
                    1500:
                        begin
                            a_val = -3000;
                            load = 1;
                        end

                    4000:
                        begin
                            a_val = -1000;
                            load = 1;
                        end

                    5500:
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
