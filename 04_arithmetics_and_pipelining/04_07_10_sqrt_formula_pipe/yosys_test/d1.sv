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
            for (integer i = 0; i<depth; i++) begin
                mem_vld[i] <= 0;
                mem_data[i] <= 0;
            end
        end 
        else begin
            for (int i = 0; i < depth-1; i ++)
                mem_vld [i+1] <= mem_vld [i];
            mem_vld[0] <= in_vld;

            for (int i = 0; i < depth-1; i ++)
                mem_data [i+1] <= mem_data [i];
            mem_data[0] <= in_data;
        end
    end

    assign out_vld = mem_vld[depth-1];
    assign out_data = mem_data[depth-1];

endmodule