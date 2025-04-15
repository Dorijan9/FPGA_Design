module score_counter (
    input logic clk,
    input logic rst,
    input logic level_complete,  
    output logic [7:0] score    
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            score <= 8'd0;
        else if (level_complete)
            score <= score + 8'd1;
    end

endmodule
