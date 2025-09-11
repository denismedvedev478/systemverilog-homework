module isqrt_test;

reg clk = 0;
reg rst;

event tb_ready;
initial begin
    $dumpvars;
    clk = 0;
    rst = 0;
    fork
        forever #5 clk = ~clk;
        begin
            rst = 1;
            #20 rst = 0;
            ->tb_ready;
        end
        begin
            #100 
            $finish;
        end
    join_none
end

wire isqrt_a_vld, isqrt_b_vld, isqrt_c_vld;
wire [15:0] isqrt_a_res, isqrt_b_res, isqrt_c_res;
    
reg [31:0] a, b, c;


initial begin
    wait(tb_ready.triggered);
end

endmodule
