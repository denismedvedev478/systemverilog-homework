`include "04_13_put_in_order.sv"
`include "fifo.sv"

module tb;
    localparam n_inputs = 4;
    localparam width = 16;

    reg clk;
    reg rst;

    initial begin
        fork
            begin
                rst = 1;
                # 15 rst = 0;
            end
            begin
                clk = 0;
                forever begin
                #5 clk = ~clk;
                end
            end
        join_none
    end

    reg [ n_inputs-1 : 0 ] up_vlds;
    reg [ width-1 : 0 ] up_data [ n_inputs-1 : 0 ];

    wire down_vld;
    wire [ width-1 : 0 ] down_data;

    put_in_order #( .width( width ), .n_inputs( n_inputs ) )
    DUT(
        .clk        ( clk       ),
        .rst        ( rst       ),
        .up_vlds    ( up_vlds   ),
        .up_data    ( up_data   ),
        .down_vld   ( down_vld  ),
        .down_data  ( down_data )
    );

    initial begin
        $dumpvars();
        #111169 $finish;
    end

    initial begin
        up_vlds = '0;
        for (integer i=0; i<n_inputs; i++) begin
            up_data[i] = '0;
        end

        @(negedge rst);
        @(posedge clk);
        
        write_data(0);
        write_data(1);
        write_data(2);
        write_data(3);        

        #10 $finish;
    end

    event send;
    task write_data(input integer num);
        static integer counter = 1;
        ->send;
        up_vlds = '0;
        for (integer i=0; i<n_inputs; i++) begin
            up_data[i] = '0;
        end

        @(posedge clk);
        up_vlds[num] = 1'b1;
        up_data[num] = num*10 + counter;
        counter++;
    endtask

endmodule
