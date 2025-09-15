// This design is a Yuri Panchul's edition
// of the code derived from:
//
// Digital Design: A Systems Approach
// by William James Dally and R. Curtis Harting
// 2012

module double_buffer_from_dally_harting
# (
    parameter width = 0
)
(
    input                      clk,
    input                      rst,

    input                      up_valid,
    output logic               up_ready,
    input        [width - 1:0] up_data,

    output logic               down_valid,
    input                      down_ready,
    output logic [width - 1:0] down_data
);
// up signals:
// for importing input data to stash
// down signals:
// for accessing saved bufdata or bypassing and receiving rerouted up_data


// 1) Изначально up_ready 1, и все данные, которые мы пихаем в модуль, сохраняются
// и заносятся в buf_data (при условии down_ready==0)
// 2) Если down_ready==1, это значит, что мы хотим получать последние 
// записанные в буфер данные и сидеть только на них смотреть

    logic               buf_valid;
    logic [width - 1:0] buf_data;

    always_ff @ (posedge clk)                   // data
    begin
        if (up_ready & ~ down_ready)
            buf_data <= up_data;

        if (down_ready)
            down_data <= up_ready ? up_data : buf_data;
    end

    always_ff @ (posedge clk or posedge rst)    // valid
        if (rst)
        begin
            buf_valid  <= 1'b0;
            down_valid <= 1'b0;
            up_ready   <= 1'b1;
        end
        else
        begin
            if (up_ready & ~ down_ready)
                buf_valid  <= up_valid;

            if (down_ready)
                down_valid <= up_ready ? up_valid : buf_valid;

            up_ready <= down_ready;
        end

endmodule
