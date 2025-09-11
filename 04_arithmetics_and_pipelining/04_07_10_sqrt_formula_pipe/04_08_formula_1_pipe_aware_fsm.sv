//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------
typedef enum reg[3:0] {IDLE, LOADED_A, LOADED_B, LOADED_C, AWAITING_RES} FSM_TYPE;
module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output reg        res_vld,
    output reg [31:0] res,

    // isqrt interface
    output reg        isqrt_x_vld,
    output reg [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);
    // Если поступают данные на вход, надо загрузить их подряд и начать ждать 
    // res от isqrt
/*
    reg [31:0] b_def, c_def; // deferred writing in FIFO

    always_ff @( posedge clk or posedge arg_vld) begin : Defer_b_c    
        if (arg_vld) begin
            b_def <= b;
            c_def <= c;
        end
    end

    FSM_TYPE state, new_state;
    
    always_ff @(posedge clk or posedge rst) begin : FSM_SaveNewState
        if (rst) state <= IDLE;
        else state <= new_state;
    end

    always_comb begin : FSM_TransitionLogic
        case (state)
            IDLE: new_state = arg_vld ? LOADED_A : IDLE; 
            LOADED_A: new_state = LOADED_B;
            LOADED_B: new_state = AWAITING_RES;
            AWAITING_RES: new_state = isqrt_y_vld ? IDLE : AWAITING_RES;
            default: new_state = IDLE;
        endcase
    end

    always_ff @(posedge clk) begin : FSM_OutputLogic
        if (state == IDLE && arg_vld) begin
            isqrt_x_vld <= 1;
            isqrt_x <= a;
        end
        if (state == LOADED_A) begin
            isqrt_x <= b_def;
        end
        if (state == LOADED_B) begin
            isqrt_x <= b_def;
        end
        if (state == AWAITING_RES) begin
            
        end
    end
    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

*/
endmodule
