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

module signed_add_with_overflow(
    input  signed [3:0] a,
    input  signed [3:0] b,
    output signed [3:0] sum,
    output              overflow
);
    wire signed [3:0] sum_temp;
    assign sum_temp = a + b;
    assign sum = sum_temp;

    // overflow: if sign of a == sign of b and sign of sum != sign of a
    assign overflow = (~(a[3] ^ b[3])) & (a[3] ^ sum[3]);
endmodule


  // Task:
  //
  // Implement a module that adds two signed numbers
  // and detects an overflow.
  //
  // By "signed" we mean "two's complement numbers".
  // See https://en.wikipedia.org/wiki/Two%27s_complement for details.
  //
  // The 'overflow' output bit should be set to 1
  // when the sum (either positive or negative)
  // of two input arguments does not fit into 4 bits.
  // Otherwise the 'overflow' should be set to 0.


