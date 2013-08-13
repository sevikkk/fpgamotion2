module debounce(
           input clk,
           input reset,
           input sig_in,
           input [31:0] pos_in,
           input [31:0] timeout,
           output reg value,
           output reg value_changed,
           output reg [31:0] change_pos,
           output reg [31:0] max_bounce
       );

reg sig_reg1;
reg sig;

// sync to clock
always @(posedge clk)
    begin
        sig_reg1 <= sig_in;
        sig <= sig_reg1;
    end

localparam S_STABLE=0, S_BOUNCE1=1, S_BOUNCE2=2;

reg [31:0] timer;
reg [31:0] next_timer;

reg [2:0] state;
reg [2:0] next_state;

reg next_change_pos;

reg next_value;
reg next_value_changed;

reg [31:0] start_pos;
reg [31:0] next_start_pos;

reg [31:0] next_max_bounce;

always @(reset or timeout or sig or timer or dstate or value or max_bounce or start_pos or pos_in or change_pos)
    begin
        next_timer <= timer;
        next_state <= state;
        next_value <= value;
        next_max_bounce <= max_bounce;
        next_start_pos <= start_pos;
        next_change_pos <= change_pos;
        next_value_changed <= 0;

        if (reset)
            begin
                next_timer <= 0;
                next_state <= S_STABLE;
                next_value <= 0;
                next_max_bounce <= 0;
                next_start_pos <= 0;
                next_change_pos <= 0;
            end
        else
            begin

                case (state)
                    S_STABLE:
                        begin
                            if (sig != value)
                                begin
                                    next_timer <= 0;
                                    next_start_pos <= pos_in;
                                    next_state <= S_BOUNCE1;
                                    next_max_bounce <= 0;
                                end
                        end
                    S_BOUNCE1:
                        begin
                            if (sig != value)
                                begin
                                    next_timer <= timer + 1;
                                    if (timer > timeout)
                                        begin
                                            next_value <= sig;
                                            next_state <= S_STABLE;
                                            next_value_changed <= 1;
                                            next_change_pos <= start_pos;
                                        end
                                end
                            else
                                begin
                                    next_state <= S_BOUNCE2;
                                    next_timer <= 0;
                                    if (timer > max_bounce)
                                        begin
                                            next_max_bounce <= timer;
                                        end
                                end
                        end
                    S_BOUNCE2:
                        begin
                            if (sig == value)
                                begin
                                    next_timer <= timer + 1;
                                    if (timer > timeout)
                                        begin
                                            next_state <= S_STABLE;
                                        end
                                end
                            else
                                begin
                                    next_state <= S_BOUNCE1;
                                    next_timer <= 0;
                                    if (timer > max_bounce)
                                        begin
                                            next_max_bounce <= timer;
                                        end
                                end
                        end
                endcase
            end
    end

always @(posedge clk)
    begin
        timer <= next_timer;
        max_bounce <= next_max_bounce;
        state <= next_state;
        value <= next_value;
        value_changed <= next_value_changed;
        start_pos <= next_start_pos;
    end

endmodule
