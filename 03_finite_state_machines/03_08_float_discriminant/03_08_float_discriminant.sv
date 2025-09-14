//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);
    reg [FLEN-1:0] c_def;
    reg [FLEN-1:0] b_sqr;
    always_ff @(posedge clk ) begin
        if (arg_vld)
            c_def <= c;
        if (w_down_valid_1)
            b_sqr <= w_res_1;
    end

    reg up_valid_mul;
    wire [FLEN-1:0] a_1, b_1, a_2, b_2;
    assign a_1 = arg_vld ? a : 'x;
    assign b_1 = arg_vld ? b : 'x;
    assign a_2 = arg_vld ? a : 'x;
    assign b_2 = arg_vld ? b : 'x;
    assign up_valid_1 = arg_vld;
    assign up_valid_2 = arg_vld;
    assign const4 = 64'h4010_0000_0000_0000;

    // pow(b, 2)
    f_mult f1 ( .clk(clk), .rst(rst),
    .a(a_1), .b(b_1), .up_valid(up_valid_1),
    .res(w_res_1), .down_valid(w_down_valid_1), .busy(w_busy_1), .error(w_err_1));

    // 4*a
    f_mult f2 ( .clk(clk), .rst(rst),
    .a(const4), .b(b_2), .up_valid(up_valid_2),
    .res(w_res_2), .down_valid(w_down_valid_2), .busy(w_busy_2), .error(w_err_2));


    // (4a)*c
    f_mult f3 ( .clk(clk), .rst(rst),
    .a(w_res_2), .b(c_def), .up_valid(w_down_valid_2),
    .res(w_res_3), .down_valid(w_down_valid_3), .busy(w_busy_3), .error(w_err_3));

    // D = (b^2)-(4ac)
    f_sub f4 ( .clk(clk), .rst(rst),
    .a(b_sqr), .b(w_res_3), .up_valid(w_down_valid_3),
    .res(w_res_4), .down_valid(w_down_valid_4), .busy(w_busy_4), .error(w_err_4));

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs their discriminant.
    // The resulting value res should be calculated as a discriminant of the quadratic polynomial.
    // That is, res = b^2 - 4ac == b*b - 4*a*c
    //
    // Note:
    // If any argument is not a valid number, that is NaN or Inf, the "err" flag should be set.
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.
    assign busy = w_busy_1 | w_busy_2 | w_busy_3 | w_busy_4;
    assign err = w_err_1 | w_err_2 | w_err_3 | w_err_4;

endmodule
