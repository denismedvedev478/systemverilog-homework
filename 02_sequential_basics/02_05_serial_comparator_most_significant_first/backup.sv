module serial_comparator_most_significant_first
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);
  reg is_first_stage;
  reg old_res_eq, old_res_le;   // or_eq decides if result should be overwritten
  
  wire cur_eq, cur_le;

  assign cur_eq = (a == b);   // a == b
  assign cur_le = (!a & b);   // a < b  

  reg result_le, result_eq;
  // пусть на этом этапе results должны быть на самом деле wire
  // и они синтезируются по простому в wire
  // тогда здесь всё должно быть правильно по сути
  assign a_less_b    = !rst & (is_first_stage ?  cur_le  : !result_eq & result_le);
  assign a_greater_b = !rst & (is_first_stage ?  !cur_le : !result_eq & !result_le);
  assign a_eq_b      = !rst & (is_first_stage ?  cur_eq  : result_eq);

  always @(posedge clk) begin
    if (rst) begin
      is_first_stage <= 1;
      result_eq = cur_eq;
      result_le = cur_le;
      old_res_eq <= result_eq;
      old_res_le <= result_le;
    end
    else begin
      is_first_stage <= 0;
      // теперь тут:
      // если до этого момента всё это время был old_res_eq == 1, то 
      if (old_res_eq) begin
        result_eq = cur_eq;
        result_le = cur_le;
      end
      // если ёбаный result_eq не равен 0, то нужно сохранить result_le
      if (!old_res_eq) begin
        result_le = old_res_le;
        result_eq = 0;
      end
      
      if (is_first_stage) begin
        old_res_eq <= cur_eq;
        old_res_le <= cur_le;
      end
      else begin
        old_res_eq <= result_eq;
        old_res_le <= result_le;
      end
    end
  end
  // Task:
  // Implement a module that compares two numbers in a serial manner.
  // The module inputs a and b are 1-bit digits of the numbers
  // and most significant bits are first.
  // The module outputs a_less_b, a_eq_b, and a_greater_b
  // should indicate whether a is less than, equal to, or greater than b, respectively.
  // The module should also use the clk and rst inputs.
  //
  // See the testbench for the output format ($display task).


endmodule





module serial_comparator_most_significant_first_abandonned
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);
  reg is_first_stage;
  reg conc_eq, conc_le;
  
  wire cur_eq, cur_le;
  reg prev_eq, prev_le;

  assign cur_eq = (a == b);           // a == b
  assign cur_le = !cur_eq & (!a & b);  // a < b
  
  assign a_less_b    = is_first_stage ?  (!a & b) : (prev_eq == 0) & (prev_le == 1);
  assign a_greater_b = is_first_stage ?  (a & !b) : (prev_eq == 0) & (prev_le == 0);
  assign a_eq_b      = is_first_stage ?  (a == b) : prev_eq;


  always @(posedge clk ) begin
    if (rst) begin
      is_first_stage <= 1;
    end
    else begin
      is_first_stage <= 0;
      conc_eq <= prev_eq & cur_eq;
      prev_eq <= is_first_stage ? cur_eq : a_eq_b;
      prev_le <= is_first_stage ? cur_le : a_less_b;
    end
  end
  // Task:
  // Implement a module that compares two numbers in a serial manner.
  // The module inputs a and b are 1-bit digits of the numbers
  // and most significant bits are first.
  // The module outputs a_less_b, a_eq_b, and a_greater_b
  // should indicate whether a is less than, equal to, or greater than b, respectively.
  // The module should also use the clk and rst inputs.
  //
  // See the testbench for the output format ($display task).


endmodule
