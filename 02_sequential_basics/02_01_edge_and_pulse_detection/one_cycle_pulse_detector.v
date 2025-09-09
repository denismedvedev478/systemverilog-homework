module one_cycle_pulse_detector (
    input clk, 
    input rst, 
    input a, 
    output reg detected,
    output reg [2:0] cur_sequence
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin  // interrupts my "program" and writes b'000 to "last_seq" and b'0 to "detected"
      cur_sequence <= 3'b000;
      detected <= 0;
    end 
    else begin
      cur_sequence <= {cur_sequence[1:0], a};

      if ({cur_sequence[1:0], a} == 3'b010)
        detected <= 1;
      else
        detected <= 0;
    end
  end

endmodule

