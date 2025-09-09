  // Task:
  // Implement a serial adder using only ^ (XOR), | (OR), & (AND), ~ (NOT) bitwise operations.
  //
  // Notes:
  // See Harris & Harris book
  // or https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder webpage
  // for information about the 1-bit full adder implementation.
  //
  // See the testbench for the output format ($display task).


module serial_adder
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);

  // Note:
  // carry_d represents the combinational data input to the carry register.

  logic carry;
  wire carry_d;

  assign { carry_d, sum } = a + b + carry;

  always_ff @ (posedge clk)
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;
endmodule


module serial_adder_using_logic_operations_only
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);
  reg carry;
  wire carry_d;

  assign sum = (rst == 0) ? a ^ b ^ carry : 0;
  // assign new_calc_carry = (a & b) | (sum & carry); this one somehow creates a combinational loop 
  assign new_calc_carry = (a & b) | (carry & (a ^ b));
  assign carry_d = (rst == 0) ? new_calc_carry : 0;
  
  always @(posedge clk) begin
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;
  end
endmodule

module serial_adder_ff(   // идиотское запоздалое обновление sum через 1 такт (пусть сначала обновится carry)
  input  clk,
  input  rst,
  input  a,
  input  b,
  output reg sum
);
  reg carry;
  reg new_calc_carry = 0;

  always @(posedge clk ) begin
    if (rst) begin
      sum = '0;
      carry <= '0;
    end
    else begin
      sum = a ^ b ^ carry;
      new_calc_carry = (a & b) | (carry & (a ^ b));
      carry <= new_calc_carry;
    end
  end
endmodule