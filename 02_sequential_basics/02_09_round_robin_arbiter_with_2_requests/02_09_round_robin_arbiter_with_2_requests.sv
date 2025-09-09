//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
// Implement a "arbiter" module that accepts up to two requests
// and grants one of them to operate in a round-robin manner.
//
// The module should maintain an internal register
// to keep track of which requester is next in line for a grant.
//
// Note:
// Check the waveform diagram in the README for better understanding.
//
// Example:
// requests -> 01 00 10 11 11 00 11 00 11 11
// grants   -> 01 00 10 01 10 00 01 00 10 01

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    reg [1:0] last_grants;
    reg [1:0] grants_deferred;
    
    reg [1:0] res_grants;

    assign grants = (requests != 2'b11) ? requests : res_grants;

    always_comb begin
        if (requests == 2'b11) begin
            if (last_grants == 2'b11) begin
                res_grants = grants_deferred;
            end
            else if (last_grants != 2'b00) begin
                res_grants = requests^last_grants;
            end
            else begin
                res_grants = 2'b01;
            end
        end
        else begin
            res_grants = requests;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            last_grants <= 2'b00;
            grants_deferred <= 2'b00;
        end
        else begin
            if (requests == grants_deferred) begin
                grants_deferred <= 2'b00;
            end
            if (requests == 2'b11 & last_grants != 2'b11) begin
                grants_deferred <= (last_grants != 2'b00) ? !(requests^last_grants): 2'b10;
            end
            else if (requests == 2'b11 & last_grants == 2'b11) begin
                grants_deferred <= 2'b00;
            end
            last_grants <= requests;
        end
    end

endmodule
