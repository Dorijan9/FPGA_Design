module score_counter (
    input clk,
    input rst,
    input level_complete,
    output reg [7:0] score
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            score <= 8'd0;
        else if (level_complete)
            score <= score + 8'd1;
    end

endmodule
