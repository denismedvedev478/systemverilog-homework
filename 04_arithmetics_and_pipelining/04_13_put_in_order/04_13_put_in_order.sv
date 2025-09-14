module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ width    - 1 : 0 ] up_data [ 0 :n_inputs - 1 ],

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);
    // FIFO interface
    logic [n_inputs-1:0] push;
    logic [n_inputs-1:0] pop;
    logic [n_inputs-1:0] wdata;
    logic [n_inputs-1:0] rdata;

    logic [n_inputs-1:0] empty; // for row_ready buffer
    logic [n_inputs-1:0] full;  // for posting an error

    // FIFO memory
    localparam fifo_depth = 4;
    genvar i;
    generate
        for (i=0; i<n_inputs; i++) begin : fifo_array
            flip_flop_fifo_with_counter_and_debug_1 #(.width(width), .depth(fifo_depth)) 
            fifo (.clk(clk), .rst(rst), 
            .push(push[i]), .pop(pop[i]), .write_data(wdata[i]), .read_data(rdata[i]), .empty(empty[i]), .full(full[i]));
        end
    endgenerate
    
    // row_ready tracks which FIFOs have valid data for the next row.
    // When all bits are set, one complete row is ready to be serialized.
    reg [n_inputs-1:0] row_ready;
    always_ff @(posedge clk or posedge rst) begin : track_1st_buf
        if (rst) begin  
            for (integer i=0; i<n_inputs; i++) begin
                row_ready[i] <= 1'b0;
            end
        end 
        else begin
            for (integer i=0; i<n_inputs; i++) begin
                if (up_vlds[i]) begin
                    row_ready[i] <= 1;
                    push[i] <= 1'b1;
                end else begin
                    push[i] <= 1'b0;
                end
            end
        end
    end

    // counter for round-robin serialization
    reg [$clog2(n_inputs)-1:0] idx;
    reg active;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            idx    <= '0;
            active <= 1'b0;
            pop    <= '0;
        end
        else begin
            pop <= '0; // default

            if (!active && &row_ready) begin
                active <= 1'b1;
                idx    <= '0;
            end

            if (active) begin
                pop[idx] <= 1'b1;   // дёргаем pop текущего FIFO
                if (idx == n_inputs-1) begin
                    active <= 1'b0; // закончили ряд
                    row_ready <= '0;
                end
                else begin
                    idx <= idx + 1;
                end
            end
        end
    end

    reg active_prev;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            active_prev <= 1'b0;
        end
        else begin
            // on transition active: 1 -> 0, mark all non-empty FIFOs as ready
            if (active_prev && !active) begin
                row_ready <= ~empty; // set bit = 1 where FIFO is not empty
            end
            active_prev <= active;
        end
    end

    // outputs routing
    assign down_data = rdata[idx];
    assign down_vld  = active;

    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.


endmodule
