`include "02_01_edge_and_pulse_detection.sv"

module testbench;

  reg clk = 0;
  always #3 clk = ~clk;

  reg rst = 0;
  reg a = 0;
  wire pd_detected;
  wire ocpd_detected;
  wire [2:0] cur_sequence;
  wire a_r;

  initial begin
    # 0;
    rst = 0;
    a = 0;
    # 10;
    rst = 0;
    a = 1;
    # 10;
    rst = 0;
    a = 0;

    # 10;
    rst = 0;
    a = 0;
    # 10;
    rst = 0;
    a = 1;
    # 10;
    rst = 1;
    a = 0;

    #10 $finish;
  end

  initial begin
    $dumpfile("design.vcd");
    $dumpvars(1, a, a_r, clk, rst, pd_detected, ocpd_detected, cur_sequence);
    # 5000 $finish;
  end

  posedge_detector         pd   (.detected (pd_detected),   .*);
  one_cycle_pulse_detector ocpd (.detected (ocpd_detected), .*);

endmodule
