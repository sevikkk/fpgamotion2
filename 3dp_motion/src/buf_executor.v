module buf_executor (
           input clk,
           input rst,

           output reg [5:0] ext_out_reg_addr,
           output reg [31:0] ext_out_reg_data,
           output reg ext_out_reg_stb,
           input ext_out_reg_busy,

           output reg [31:0] ext_out_stbs,

           input [31:0] ext_pending_ints,
           output reg [31:0] ext_clear_ints,

           input [15:0] ext_buffer_addr,
           input [39:0] ext_buffer_data,
           input ext_buffer_wr,

           input start,
           input [15:0] start_addr,
           input done,
           input abort,
           output reg load,
           output reg complete,
           output reg [15:0] pc,
           output reg [7:0] error
);

reg [3:0] state;
reg [3:0] next_state;

reg [15:0] next_pc;

reg [7:0] next_error;

parameter BUFFER_ADDR_LEN = 13;

localparam BUFFER_SIZE = (1 << BUFFER_ADDR_LEN);

reg [39:0] buffer[0:BUFFER_SIZE - 1];
reg [39:0] buffer_data;

always @(posedge clk)
    begin
        if (ext_buffer_wr)
            buffer[ext_buffer_addr[BUFFER_ADDR_LEN-1:0]] <= ext_buffer_data;

        buffer_data <= buffer[pc[BUFFER_ADDR_LEN-1:0]];
    end

localparam S_INIT = 0, S_WAIT_DONE = 1, S_REG_BUSY = 2, S_DECODE = 3, S_FETCH = 4;

always @(state, pc, rst, ext_out_reg_busy, start, start_addr, done, abort, error)
    begin
        next_pc <= pc;
        next_state <= state;
        complete <= 0;
        load <= 0;
        ext_out_reg_addr <= 0;
        ext_out_reg_data <= 0;
        ext_out_reg_stb <= 0;
        next_error <= 0;
        ext_out_stbs <= 0;
        ext_clear_ints <= 0;

        if (rst || abort)
            begin
                next_pc <= 0;
                next_state <= S_INIT;
                if (abort)
                    next_error <= 8'h82;
                else
                    next_error <= 0;
            end
        else
            case (state)
                S_INIT:
                    begin
                        next_error <= error;
                        if (start)
                            begin
                                next_pc <= start_addr;
                                next_state <= S_FETCH;
                                next_error <= 0;
                            end
                    end
                S_FETCH:
                    begin
                        next_state <= S_DECODE;
                    end
                S_DECODE:
                    begin
                        case (buffer_data[39:38])
                            2'b01: // WRITE_REG
                                begin
                                    if (!ext_out_reg_busy)
                                    begin
                                        next_state <= S_FETCH;
                                        next_pc <= pc + 1;
                                        ext_out_reg_addr <= buffer_data[37:32];
                                        ext_out_reg_data <= buffer_data[31:0];
                                        ext_out_reg_stb <= 1;
                                    end
                                end
                            2'b10: // Misc
                                case (buffer_data[37:32])
                                    0: // NOP
                                        begin
                                            next_state <= S_FETCH;
                                            next_pc <= pc + 1;
                                        end
                                    1: // STB
                                        begin
                                            ext_out_stbs <= buffer_data[31:0];
                                            next_state <= S_FETCH;
                                            next_pc <= pc + 1;
                                        end
                                    2: // WAIT_ALL
                                        begin
                                            if (ext_pending_ints & buffer_data[31:0] == buffer_data[31:0])
                                                begin
                                                    next_state <= S_FETCH;
                                                    next_pc <= pc + 1;
                                                end
                                            else
                                                next_error <= 2;
                                        end
                                    3: // WAIT_ANY
                                        begin
                                            if (ext_pending_ints & buffer_data[31:0] != 0)
                                                begin
                                                    next_state <= S_FETCH;
                                                    next_pc <= pc + 1;
                                                end
                                            else
                                                next_error <= 2;
                                        end
                                    4: // CLEAR clear ints
                                        begin
                                            ext_clear_ints <= buffer_data[31:0];
                                            next_state <= S_FETCH;
                                            next_pc <= pc + 1;
                                        end
                                    63: // DONE
                                        begin
                                            next_state <= S_INIT;
                                            next_error <= buffer_data[7:0];
                                            complete <= 1;
                                        end
                                    default: // halt on error
                                        begin
                                            next_state <= S_INIT;
                                            next_error <= 8'h81;
                                            complete <= 1;
                                        end
                                endcase
                            default: // halt on error
                                begin
                                    next_state <= S_INIT;
                                    next_error <= 8'h81;
                                    complete <= 1;
                                end
                        endcase
                    end
                default:
                    begin
                        next_state <= S_INIT;
                        next_error <= 0;
                    end
            endcase
    end

always @(posedge clk)
    begin
        pc <= next_pc;
        state <= next_state;
        error <= next_error;
    end

endmodule


