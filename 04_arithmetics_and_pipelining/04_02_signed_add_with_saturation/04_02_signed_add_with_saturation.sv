//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_saturation
(
  input  [3:0] a, b,
  output reg signed [3:0] sum,
  output reg signed [4:0] raw_sum
  //output reg debug_overflow,
  //output reg debug_branch_taken
);
  assign ext_a = a[4];
  assign ext_b = b[4];
  assign ext_raw_sum = raw_sum[4];

  always_comb begin
    raw_sum = $signed(a) + $signed(b);
    sum = raw_sum;
    
    if (raw_sum > 5'b00111 && ~ext_raw_sum) begin
      sum = 4'b0111; // $signed(7)
    end
    if (raw_sum < $signed(-8) && ext_raw_sum) begin
      sum = $signed(-8);
    end
    
  end

endmodule
  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.


