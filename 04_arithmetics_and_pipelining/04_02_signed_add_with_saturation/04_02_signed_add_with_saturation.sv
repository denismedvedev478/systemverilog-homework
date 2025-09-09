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
  output reg [3:0] sum
);
  wire overflow;
  wire signed [3:0] sum_temp;
  assign sum_temp = a + b;
  assign sum = sum_temp;

  always_comb begin
    if (overflow) begin
      if (sum[3])
        sum = 4'b0111;
      else 
        sum = 4'b1111;
    end
    else begin
      sum = sum_temp;
    end
  end

  // overflow: if sign of a == sign of b and sign of sum != sign of a
  assign overflow = (~(a[3] ^ b[3])) & (a[3] ^ sum[3]);
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


