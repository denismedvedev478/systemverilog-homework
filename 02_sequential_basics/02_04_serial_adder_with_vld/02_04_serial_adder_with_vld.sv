// Task:
// Implement a module that performs serial addition of two numbers
// (one pair of bits is summed per clock cycle).
//
// It should have input signals a and b, and output signal sum.
// Additionally, the module have two control signals, vld and last.
//
// The vld signal indicates when the input values are valid.
// The last signal indicates when the last digits of the input numbers has been received.
//
// When vld is high, the module should add the values of a and b and produce the sum.
// When last is high, the module should output the sum and reset its internal state, but
// only if vld is also high, otherwise last should be ignored.
//
// When rst is high, the module should reset its internal state.


module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  vld,
  input  a,
  input  b,
  input  last,
  output sum  
);
  // WIRES that are available and ready to provide a value
  reg sum_av;
  reg carry_av;
  
  // previous values
  reg sum_stashed;
  reg carry_stashed;

  assign sum = (vld & last) ? sum_stashed : 0;

  always @(*) begin
    if (vld & ~last) begin
      {carry_av, sum_av} = a + b + carry_stashed;
    end
    else begin
      {carry_av, sum_av} = {carry_stashed, sum_stashed};
    end
  end

  // idea
  // always stash sum if it will be needed later
  always_ff @(posedge clk ) begin
    if (rst | (last & vld)) begin
      carry_stashed <= 0; 
      sum_stashed <= 0;
    end
    else begin
      sum_stashed <= sum_av;
      carry_stashed <= carry_av;
    end
  end

endmodule


module serial_adder_vlad
(
  input  clk,
  input  rst,
  input  vld,
  input  a,
  input  b,
  input  last,
  output sum  
);

logic carry_r;
wire carry_w, sum_w;

assign {carry_w, sum_w} = (a + b + carry_r) ;
assign sum = sum_w & vld;

always_ff @ (posedge clk)begin
  if(rst | last)
    carry_r <= 'd0;
  else
    carry_r <= carry_w;
end

endmodule

/*
vld == 1 значит надо посчитать сумму.
Пускай она стала 1;
запихали её в stashed. Stashed обновляется только при успешных vld

Хорошо, но что если нам нужно значение в ту же секунду:
у нас не только vld == 1 , но и last = 1:
Это означает, что нам надо тут же вывести эту сумму:
assign sum = (vld & last) ? a + b + carry : 0
*/

/*
vld == 1:
только посчитать сумму

vld == 1 and last == 1:
только вывести сумму

 */