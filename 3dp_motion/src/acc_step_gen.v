module acc_step_gen(
           input clk,
           input reset,
           input [31:0] dt_val, // Step interval
           input [31:0] steps_val, // Number of steps in current sequence
           input load,
           output reg [31:0] steps,
           output reg [31:0] dt,
           output reg abort,           // combinatorial
           output reg step_stb, 	// combinatorial
           output reg done 		// combinatorial
       );

localparam S_INIT = 0, S_WORKING = 1, S_WAIT = 2, S_ABORT = 3;

reg [31:0] next_dt;
reg [31:0] next_steps;

reg [2:0] state;
reg [2:0] next_state;

always @(state, load, dt_val, steps_val, steps, dt, reset)
    begin
        next_state <= state;
        next_dt <= dt;
        next_steps <= steps;

        abort <= 0;
        step_stb <= 0;
        done <= 0;

        if (reset)
            begin
                next_state <= S_INIT;
                next_dt <= 0;
                next_steps <= 0;
            end
        else
            case (state)
                S_INIT:
                    begin
                        if (load)
                            begin
                                next_dt <= 0;
                                next_steps <= 0;
                                next_state <= S_WORKING;
                            end
                    end
                S_WORKING:
                    begin
                        if (load) // Restart current step
                            begin
                                next_dt <= 0;
                                next_steps <= 0;
                            end
                        else
                            begin
                                next_dt <= dt + 1;
                                if (dt + 1 >= dt_val)
                                    begin
                                        next_dt <= 0;
                                        next_steps <= steps + 1;
                                        step_stb <= 1;
                                        if (steps + 1 >= steps_val)
                                            begin
                                                done <= 1;
                                                next_steps <= 0;
                                                next_state <= S_WAIT;
                                            end
                                    end
                            end
                    end
                S_WAIT:
                    begin
                        next_dt <= dt + 1;
                        if (load) // new data loaded in time
                            begin
                                next_steps <= 0;
                                next_state <= S_WORKING;
                            end
                        else // timeout waiting for next data, aborting
                            begin
                                if (dt + 1 >= dt_val)
                                    begin
                                        next_dt <= 0;
                                        abort <= 1;
                                        step_stb <= 1;
                                        next_state <= S_ABORT;
                                    end
                            end
                    end
                S_ABORT: // data not available, run abort sequence - generate step_stb's with abort set
                    begin
                        next_dt <= dt + 1;
                        if (load) // RESTART
                            begin
                                next_dt <= 0;
                                next_steps <= 0;
                                next_state <= S_WORKING;
                            end
                        else
                            begin
                                abort <= 1;
                                if (dt + 1 >= dt_val)
                                    begin
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
        steps <= next_steps;
        state <= next_state;
    end

endmodule
