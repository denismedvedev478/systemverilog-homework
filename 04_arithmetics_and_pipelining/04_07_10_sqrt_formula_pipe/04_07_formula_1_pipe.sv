//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output reg  res_vld,
    output reg [31:0] res
);
    wire isqrt_a_vld, isqrt_b_vld, isqrt_c_vld;
    wire [15:0] isqrt_a_res, isqrt_b_res, isqrt_c_res;
    
    reg [31:0] a_def, b_def, c_def;

    always_ff @( posedge clk ) begin : inputs_deferred
        if (rst) begin
            a_def <= 0;
            b_def <= 0;
            c_def <= 0;    
        end
        a_def <= a;
        b_def <= b;
        c_def <= c;
    end

    isqrt isqrt_a (.*, .x_vld(arg_vld), .x(a_def), .y_vld(isqrt_a_vld), .y(isqrt_a_res));
    isqrt isqrt_b (.*, .x_vld(arg_vld), .x(b_def), .y_vld(isqrt_b_vld), .y(isqrt_b_res));
    isqrt isqrt_c (.*, .x_vld(arg_vld), .x(c_def), .y_vld(isqrt_c_vld), .y(isqrt_c_res));

    always_comb begin
        res = 0;
        res_vld = 0;
        if (isqrt_a_vld && isqrt_b_vld && isqrt_c_vld) begin
            res = isqrt_a_res + isqrt_b_res + isqrt_c_res;
            res_vld = 1;
        end
    end

    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0


endmodule
