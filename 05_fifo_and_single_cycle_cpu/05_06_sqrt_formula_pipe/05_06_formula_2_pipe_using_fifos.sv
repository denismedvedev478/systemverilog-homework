//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_fifos
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

    // Task:
    //
    // Implement a pipelined module formula_2_pipe_using_fifos that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    localparam isqrt_latency = 16;
    reg x_vld_1, x_vld_2, x_vld_3;
    reg [31:0] x_1, x_2, x_3;
    wire y_vld_1, y_vld_2, y_vld_3;
    wire [15:0] y_1, y_2, y_3;
    isqrt #(.n_pipe_stages(isqrt_latency)) isqrt_1 (.*, .x_vld(x_vld_1), .x(x_1), .y_vld(y_vld_1), .y(y_1));
    isqrt #(.n_pipe_stages(isqrt_latency)) isqrt_2 (.*, .x_vld(x_vld_2), .x(x_2), .y_vld(y_vld_2), .y(y_2));
    isqrt #(.n_pipe_stages(isqrt_latency)) isqrt_3 (.*, .x_vld(x_vld_3), .x(x_3), .y_vld(y_vld_3), .y(y_3));
    // 3. Your solution should use FIFOs instead of shift registers
    // which were used in 04_10_formula_2_pipe.sv.
    
    reg push1, pop1, push2, pop2;
    reg [31:0] wdata1, wdata2;
    wire [15:0] rdata1, rdata2;
    wire empty1, full1, empty2, full2;

    flip_flop_fifo_with_counter #(.width(32), .depth(isqrt_latency)) fifo1
    (.*, .push(push1), .pop(pop1), .write_data(wdata1), .read_data(rdata1), .empty(empty1), .full(full1));

    flip_flop_fifo_with_counter #(.width(32), .depth(2*isqrt_latency+1)) fifo2
    (.*, .push(push2), .pop(pop2), .write_data(wdata2), .read_data(rdata2), .empty(empty2), .full(full2));

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            x_vld_1 <= 0;
            x_vld_2 <= 0;
            x_vld_3 <= 0;
            
            push1 <= 0;
            push2 <= 0;
            pop1 <= 0;
            pop2 <= 0;
            wdata1 <= 0;
            wdata2 <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (arg_vld) begin
            x_vld_1 <= arg_vld;
            x_1 <= c;
            
            push1 <= arg_vld;
            wdata1 <= b;

            push2 <= arg_vld;
            wdata2 <= a;
        end
        else begin
            x_vld_1 <= 0;
            push1 <= 0;
            push2 <= 0;
        end
    end

    reg[31:0] x_2_def;
    reg x_vld_2_def;
    reg[31:0] x_3_def;
    reg x_vld_3_def;
    always_ff @(posedge clk or posedge rst) begin
        // TODO: write assertions for y_vld==1 and fifo1 popping valid data
        if (rst) begin
            x_2_def <= 0;
            x_vld_2_def <= 0;
            
            x_3_def <= 0; 
            x_vld_3_def <= 0;
        end 
        else begin
            pop1 <= 1;
            x_2_def <= y_1 + rdata1;
            x_2 <= x_2_def;
            
            x_vld_2_def <= y_vld_1;
            x_vld_2 <= x_vld_2_def;

            pop2 <= 1;
            x_3_def <= y_2 + rdata2;
            x_3 <= x_3_def;
            
            x_vld_3_def <= y_vld_2;
            x_vld_3 <= x_vld_3_def;
        end 
    end

    assign res_vld = y_vld_3;
    assign res = y_3;
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm


endmodule
