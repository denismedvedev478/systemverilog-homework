//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module one_bit_wide_shift_register_with_reset
# (
    parameter depth = 8
)
(
    input  clk,
    input  rst,
    input  in_data,
    output out_data
);
    logic [depth - 1:0] data;

    always_ff @ (posedge clk)
        if (rst)
            data <= '0;
        else
            data <= { data [depth - 2:0], in_data };

    assign out_data = data [depth - 1];

endmodule

//----------------------------------------------------------------------------

module shift_register
# (
    parameter width = 8, depth = 8
)
(
    input                clk,
    input  [width - 1:0] in_data,
    output [width - 1:0] out_data
);
    logic [width - 1:0] data [0:depth - 1];

    always_ff @ (posedge clk)
    begin
        data [0] <= in_data;

        for (int i = 1; i < depth; i ++)
            data [i] <= data [i - 1];
    end

    assign out_data = data [depth - 1];

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module shift_register_with_valid
# (
    parameter width = 8, depth = 8
)
(
    input                clk,
    input                rst,

    input                in_vld,
    input  [width - 1:0] in_data,

    output               out_vld,
    output [width - 1:0] out_data
);
    reg mem_vld [0:depth - 1];
    reg [width - 1:0] mem_data [0:depth - 1];

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < depth; i++) begin
                mem_vld[i]  <= 1'b0;
                mem_data[i] <= '0;
            end
        end 
        else begin
            // сдвиг valid
            for (int i = depth-1; i > 0; i--) begin
                mem_vld[i] <= mem_vld[i-1];
                if (mem_vld[i-1]) // shift data only when valid
                    mem_data[i] <= mem_data[i-1];
            end
            mem_vld[0] <= in_vld;
            if (in_vld)
                mem_data[0] <= in_data;
        end
    end
    assign out_vld = mem_vld[depth-1];
    assign out_data = mem_data[depth-1];

endmodule
