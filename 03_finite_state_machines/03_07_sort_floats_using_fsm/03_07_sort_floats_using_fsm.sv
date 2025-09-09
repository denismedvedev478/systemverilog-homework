//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

typedef enum reg[2:0] {
    IDLE, 
    st1_v0_less_v1,
    st1_v1_less_v0,

    st2_v1_less_v2,
    st2_v2_less_v1,

    st3_v0_less_v2,
    st3_v2_less_v0
} fl_cmp_state;

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

assign err = f_le_err;
assign valid_out = err;


// module progress stages
reg[9:0] progress_stages;
always_ff @(posedge clk) begin
    if (rst) begin
        progress_stages <= 9'b01;
    end
    else begin
        progress_stages <= {progress_stages[8:0], 1'b0};
    end
end


//////// FSM stuff/ //////

fl_cmp_state state, new_state;


// update state
always_ff @(posedge clk) begin
    if (rst) 
        state <= IDLE;
    else 
        state <= new_state;
end

// get new state
always_comb begin
    new_state = state;
    case (state)
        IDLE:           
        st1_v0_less_v1: 
        st1_v1_less_v0: 

        st2_v1_less_v2: 
        st2_v2_less_v1: 

        st3_v0_less_v2: 
        st3_v2_less_v0: 
    endcase
end

// update wires state
always_comb begin

end

// update FFs state
always_ff @(posedge clk) begin

end

endmodule


// Task:
// Implement a module that accepts three Floating-Point numbers and outputs them 
// in the increasing order using FSM.
//
// Requirements:
// The solution must have latency equal to the three clock cycles.
// The solution should use the inputs and outputs to the single "f_less_or_equal" module.
// The solution should NOT create instances of any modules.
//
// Notes:
// res0 must be less or equal to the res1
// res1 must be less or equal to the res1
//
// The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
// and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.
