`include "02_02_single_and_double_rate_fibonacci.sv"

module testbench;

  logic clk, rst;
  wire [15:0] f1_num, f1_num2, f2_num, f2_num2;

  fibonacci f1 (.clk(clk), .rst(rst), .num(f1_num), .num2(f1_num2));
  fibonacci_2 f2 (.clk(clk), .rst(rst), .num(f2_num), .num2(f2_num2));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1;
    #10;
    rst = 0;
  end

  

  initial begin
    $dumpfile("design.vcd");
    $dumpvars(1, testbench);
    #1000;
    $finish;
  end

endmodule
