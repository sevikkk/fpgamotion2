module acc_profile_gen(
           input clk,
           input reset,
           input acc_step,
           input load,
           input set_x,
           input set_v,
           input set_a,
           input set_j,
           input signed [63:0] x_val,
           input signed [31:0] v_val,
           input signed [31:0] a_val,
           input signed [31:0] j_val,
           input [5:0] step_bit,

           input abort,
           input signed [31:0] abort_a_val,

           output reg signed [63:0] x,
           output reg signed [31:0] v,
           output reg signed [31:0] a,
           output reg signed [31:0] j,

           output reg step,
           output reg dir,
           output reg stopped
       );

reg signed [31:0] next_v;
reg signed [31:0] next_a;
reg signed [31:0] next_j;
reg next_stopped;

always @(reset, acc_step, load, set_v, set_a, set_j, v_val, a_val, j_val, v, a, j, abort, abort_a_val, stopped)
    begin
        next_v <= v;
        next_a <= a;
        next_j <= j;
        next_stopped <= stopped;
        if (reset)
            begin
                next_v <= 0;
                next_a <= 0;
                next_j <= 0;
                next_stopped <= 0;
            end
        else if (load)
            begin
                if (set_v)
                    next_v <= v_val;
                if (set_a)
                    next_a <= a_val;
                if (set_j)
                    next_j <= j_val;
            end
        else if (acc_step)
            begin
                next_stopped <= 0;
                if (abort)
                    begin
                        next_j <= 0;
                        if (v != 0)
                            begin
                                if (v > abort_a_val)
                                    begin
                                        next_v <= v - abort_a_val;
                                        next_a <= -abort_a_val;
                                    end
                                else if (v >= -abort_a_val)
                                    begin
                                        next_v <= 0;
                                        next_a <= -v;
                                        next_stopped <= 1;
                                    end
                                else
                                    begin
                                        next_v <= v + abort_a_val;
                                        next_a <= abort_a_val;
                                    end
                            end
                        else
                            begin
                                next_v <= 0;
                                next_a <= 0;
                                next_stopped <= 1;
                            end
                    end
                else
                    begin
                        next_v <= v + a + (j>>1);
                        next_a <= a + j;
                    end
            end
    end

reg next_dir;
reg next_step;
reg signed [63:0] next_x;
wire signed [63:0] x_acc;

assign x_acc = x + v + (a>>1);

always @(reset, load, set_x, x_val, x, v, step_bit)
    begin
        next_x <= x;
        next_dir <= dir;
        next_step <= 0;

        if (reset)
            begin
                next_x <= 0;
                next_dir <= 0;
            end
        else if (load && set_x)
            begin
                next_x <= x_val;
                next_dir <= 0;
            end
        else
            begin
                next_x <= x_acc;
                if (x[step_bit] != x_acc[step_bit])
                    begin
                        if (v>0)
                            next_dir <= 1;
                        else
                            next_dir <= 0;
                        next_step <= 1;
                    end
            end
    end

always @(posedge clk)
    begin
        x <= next_x;
        v <= next_v;
        a <= next_a;
        j <= next_j;
        step <= next_step;
        dir <= next_dir;
        stopped <= next_stopped;
    end

endmodule
