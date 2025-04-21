`timescale 1ns / 1ps
module score_counter (
    input clk,
    input rst,
    input level_complete,
    input heart_collected,
    output reg [7:0] score
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            score <= 8'd0;
        else if (level_complete || heart_collected)
            score <= score + 8'd1;
    end

endmodule
