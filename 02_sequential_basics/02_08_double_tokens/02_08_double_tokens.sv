//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------
// Task:
// Implement a serial module that doubles each incoming token '1' two times.
// The module should handle doubling for at least 200 tokens '1' arriving in a row.
//
// In case module detects more than 200 sequential tokens '1', it should assert
// an overflow error. The overflow error should be sticky. Once the error is on,
// the only way to clear it is by using the "rst" reset signal.
//
// Note:
// Check the waveform diagram in the README for better understanding.
//
// Example:
// a -> 10010011000110100001100100
// b -> 11011011110111111001111110

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output reg overflow
);

reg [7:0] count;
reg replace_flag;   // if ==1 then it '0' should be replaced with '1'
// rf должен активироваться только в случаях, когда надо перевести из 0 в 1.
// count будет считать все случаи появления '1'. А когда появляется возможность - ещё и вычитать из себя 1



assign b = (a==1) ? 1 : replace_flag;

always_comb begin
    if (count > 0 & a == 0) begin
        replace_flag = 1;
    end
    else replace_flag = 0;
end

always_ff @(posedge clk) begin
    if (count > 8'd198) begin       // independent overflow assertion
        overflow <= 1;
    end

    if (rst) begin
        overflow <= 0;
        count <= 8'b0;
    end
    else begin
        if (a == 1) begin
            count <= count + 1;
        end
        if (a==0 & count > 0) begin
            count <= count - 1;
        end
    end
end

endmodule
