`timescale 1ns / 1ps
module score_counter(
    input clk,
    input rst,
    input [1:0] level_select,
    input [4:0] player_row,
    input [4:0] player_col,
    output reg [7:0] score
);

    // Level constants
    wire [1:0] LEVEL1     = 2'd0;
    wire [1:0] LEVEL2     = 2'd1;
    wire [1:0] LEVEL3     = 2'd2;
    wire [1:0] WIN_STATE  = 2'd3;

    // Flags to avoid re-scoring
    reg collected_l1;
    reg collected_l2;
    reg collected_l3;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            score <= 8'd0;
            collected_l1 <= 0;
            collected_l2 <= 0;
            collected_l3 <= 0;
        end else begin
            case (level_select)
                LEVEL1: begin
                    if (player_row == 5'd4 && player_col == 5'd4 && !collected_l1) begin
                        score <= score + 1;
                        collected_l1 <= 1;
                    end else if (player_row != 5'd4 || player_col != 5'd4) begin
                        collected_l1 <= 0; // reset flag if player moves away
                    end
                end

                LEVEL2: begin
                    if (player_row == 5'd0 && player_col == 5'd0 && !collected_l2) begin
                        score <= score + 1;
                        collected_l2 <= 1;
                    end else if (player_row != 5'd0 || player_col != 5'd0) begin
                        collected_l2 <= 0;
                    end
                end

                LEVEL3: begin
                    if (player_row == 5'd2 && player_col == 5'd4 && !collected_l3) begin
                        score <= score + 1;
                        collected_l3 <= 1;
                    end else if (player_row != 5'd2 || player_col != 5'd4) begin
                        collected_l3 <= 0;
                    end
                end

                WIN_STATE: begin
                    // Do nothing, final state
                end
            endcase
        end
    end

endmodule
