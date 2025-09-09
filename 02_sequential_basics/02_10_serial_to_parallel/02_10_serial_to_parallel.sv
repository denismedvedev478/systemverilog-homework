//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
// Implement a module that converts serial data to the parallel multibit value.
//
// The module should accept one-bit values with valid interface in a serial manner.
// After accumulating 'width' bits, the module should assert the parallel_valid
// output and set the data.
//
// Note:
// Check the waveform diagram in the README for better understanding.
module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output reg               parallel_valid,
    output reg [width - 1:0] parallel_data
);
    localparam COUNTER_WIDTH = $clog2(width) - 1;
    reg [COUNTER_WIDTH : 0] counter;


    //assign parallel_valid = (counter == width) ? 1 : 0;
    always_comb begin
        parallel_valid = (counter == (width-1)) ? 1 : 0;
    end

    always_ff @( posedge clk ) begin
        if (rst) begin
            parallel_data <= 0;
            parallel_valid <= 0;
            counter <= 0;
        end
        else begin
            if (serial_valid) begin
                parallel_data[counter] <= serial_data;
                counter <= counter + 1;
            end
        end
        //counter[COUNTER_WIDTH] <= 0;
    end

endmodule
