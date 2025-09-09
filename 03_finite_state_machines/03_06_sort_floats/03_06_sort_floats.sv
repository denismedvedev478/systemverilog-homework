//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module sort_two_floats_ab (
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,

    output logic [FLEN - 1:0] res0,
    output logic [FLEN - 1:0] res1,
    output                    err
);

    logic a_less_or_equal_b;

    f_less_or_equal i_floe (
        .a   ( a                 ),
        .b   ( b                 ),
        .res ( a_less_or_equal_b ),
        .err ( err               )
    );

    always_comb begin : a_b_compare
        if ( a_less_or_equal_b ) begin
            res0 = a;
            res1 = b;
        end
        else
        begin
            res0 = b;
            res1 = a;
        end
    end

endmodule

//----------------------------------------------------------------------------
// Example - different style
//----------------------------------------------------------------------------

module sort_two_floats_array
(
    input        [0:1][FLEN - 1:0] unsorted,
    output logic [0:1][FLEN - 1:0] sorted,
    output                         err
);

    logic u0_less_or_equal_u1;

    f_less_or_equal i_floe
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( u0_less_or_equal_u1 ),
        .err ( err                 )
    );

    always_comb
        if (u0_less_or_equal_u1)
            sorted = unsorted;
        else
              {   sorted [0],   sorted [1] }
            = { unsorted [1], unsorted [0] };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_three_floats (
    input        [0:2][FLEN - 1:0] unsorted,
    output logic [0:2][FLEN - 1:0] sorted,
    output                         err
);
    wire v0_less_or_equal_v1, v1_less_or_equal_v2, v2_less_or_equal_v0;
    wire err01, err12, err20;
    f_less_or_equal i_floe01
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( v0_less_or_equal_v1 ),
        .err ( err01               )
    );

    f_less_or_equal i_floe12
    (
        .a   ( unsorted [1]        ),
        .b   ( unsorted [2]        ),
        .res ( v1_less_or_equal_v2 ),
        .err ( err12               )
    );

    f_less_or_equal i_floe20
    (
        .a   ( unsorted [2]        ),
        .b   ( unsorted [0]        ),
        .res ( v2_less_or_equal_v0 ),
        .err ( err20               )
    );

    assign err = err01 | err12 | err20;
    typedef enum reg[1:0]
    {
        UNKNOWN = 2'b00,
        FIRST  = 2'b01,
        SECOND = 2'b10,
        THIRD  = 2'b11
    } flag3;

    flag3 least_flag;

    reg [FLEN-1:0] v0, v1, v2;
    always_comb begin
        v0 = unsorted[0];
        v1 = unsorted[1];
        v2 = unsorted[2];

        least_flag = UNKNOWN;

        if (v0_less_or_equal_v1 & !v2_less_or_equal_v0) begin
            sorted[0] = unsorted[0];
            least_flag = FIRST;
        end
        else if (v1_less_or_equal_v2 & !v0_less_or_equal_v1)begin
            sorted[0] = unsorted[1];
            least_flag = SECOND;
        end
        else begin
            sorted[0] = unsorted[2];
            least_flag = THIRD;
        end

        case (least_flag)
            FIRST   : {sorted[1], sorted[2]} = v1_less_or_equal_v2 ? {v1, v2} : {v2, v1};
            SECOND  : {sorted[1], sorted[2]} = v2_less_or_equal_v0 ? {v2, v0} : {v0, v2};
            THIRD   : {sorted[1], sorted[2]} = v0_less_or_equal_v1 ? {v0, v1} : {v1, v0};
            UNKNOWN : {sorted[1], sorted[2]} = {1'dx, 1'dx};
        endcase
    end

endmodule

 // Task:
// Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order.
// The module should be combinational with zero latency.
// The solution can use up to three instances of the "f_less_or_equal" module.
//
// Notes:
// res0 must be less or equal to the res1
// res1 must be less or equal to the res1
//
// The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
// and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.