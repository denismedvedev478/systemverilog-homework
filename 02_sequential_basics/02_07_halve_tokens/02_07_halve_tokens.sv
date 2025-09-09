//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
// Implement a serial module that reduces amount of incoming '1' tokens by half.
//
// Note:
// Check the waveform diagram in the README for better understanding.
//
// Example:
// a -> 110_011_101_000_1111
// b -> 010_001_001_000_0101
module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);

reg count;
reg replace_flag;       // if ==1 then '0' will be replaced with '1'
assign b = (a==0) ? 0 : !replace_flag;

always_comb begin
    if (a == 1) begin
        if (count == 0) begin
            replace_flag = 1;
        end
        else begin
            replace_flag = 0;
        end
    end    
end

always_ff @( posedge clk ) begin
    if (rst) begin
        count <= 0;
    end
    if (a == 1 & count == 0) begin
        count <= 1;
    end
    if (a == 1 & count == 1) begin
        count <= 0;
    end
end

endmodule
