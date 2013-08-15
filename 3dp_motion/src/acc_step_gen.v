module acc_step_gen(
           input clk,
           input reset,
           input [31:0] dt_val, // Step interval
           input [31:0] steps_val, // Number of steps in current sequence
           input load,
           input set_steps_limit,
           input set_dt_limit,
           input reset_steps,
           input reset_dt,
           output reg [31:0] steps,
           output reg [31:0] dt,
           output reg abort,           // combinatorial
           output reg step_stb, 	// combinatorial
           output reg done 		// combinatorial
       );

localparam S_INIT = 0, S_WORKING = 1, S_WAIT = 2, S_ABORT = 3;

reg [31:0] next_dt;
reg [31:0] next_steps;

reg [31:0] steps_limit;
reg [31:0] next_steps_limit;
reg [31:0] dt_limit;
reg [31:0] next_dt_limit;

reg [2:0] state;
reg [2:0] next_state;

always @(state, load, dt_val, steps_val, steps, dt, reset, steps_limit, dt_limit, set_steps_limit, set_dt_limit, reset_steps, reset_dt)
    begin
        next_state <= state;
        next_dt <= dt + 1;
        next_steps <= steps;
        next_steps_limit <= steps_limit;
        next_dt_limit <= dt_limit;

        abort <= 0;
        step_stb <= 0;
        done <= 0;

        if (reset)
            begin
                next_state <= S_INIT;
                next_dt <= 0;
                next_steps <= 0;
                next_steps_limit <= 0;
                next_dt_limit <= 0;
            end
        else
            if (load)
                begin
                    if (reset_dt)
                        next_dt <= 0;
                    if (reset_steps)
                        next_steps <= 0;
                    if (set_steps_limit)
                        next_steps_limit <= steps_val;
                    if (set_dt_limit)
                        next_dt_limit <= dt_val;
                end
            case (state)
                S_INIT:
                    begin
                        if (load)
                            next_state <= S_WORKING;
                    end
                S_WORKING:
                    begin
                        if (!load)
                            begin
                                if (dt + 1 >= dt_limit)
                                    begin
                                        next_dt <= 0;
                                        next_steps <= steps + 1;
                                        step_stb <= 1;
                                        if (steps + 1 >= steps_limit)
                                            begin
                                                done <= 1;
                                                next_state <= S_WAIT;
                                            end
                                    end
                            end
                    end
                S_WAIT:
                    begin
                        if (load) // new data loaded in time
                            next_state <= S_WORKING;
                        else // timeout waiting for next data, aborting
                            begin
                                if (dt + 1 >= dt_limit)
                                    begin
                                        next_dt <= 0;
                                        next_steps <= steps + 1;
                                        abort <= 1;
                                        step_stb <= 1;
                                        next_state <= S_ABORT;
                                    end
                            end
                    end
                S_ABORT: // data not available, run abort sequence - generate step_stb's with abort set
                    begin
                        if (load) // RESTART
                            next_state <= S_WORKING;
                        else
                            begin
                                abort <= 1;
                                if (dt + 1 >= dt_val)
                                    begin
                                        next_steps <= steps + 1;
                                        next_dt <= 0;
                                        step_stb <= 1;
                                    end
                            end
                    end
            endcase
    end

always @(posedge clk)
    begin
        dt <= next_dt;
        dt_limit <= next_dt_limit;
        steps <= next_steps;
        steps_limit <= next_steps_limit;
        state <= next_state;
    end

endmodule
