`timescale 1ns / 1ps
module game_fsm(
    input clk,
    input rst,
    input [4:0] player_row,
    input [4:0] player_col,
    output reg [1:0] level_select,
    output reg win
);

    // State constants
    wire [1:0] LEVEL1 = 2'd0;
    wire [1:0] LEVEL2 = 2'd1;
    wire [1:0] LEVEL3 = 2'd2;
    wire [1:0] WIN_STATE = 2'd3;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            level_select <= LEVEL1;
            win <= 0;
        end else begin
            case (level_select)
                LEVEL1:
                    if (player_row == 5'd4 && player_col == 5'd2)
                        level_select <= LEVEL2;

                LEVEL2:
                    if (player_row == 5'd5 && player_col == 5'd2)
                        level_select <= LEVEL3;

                LEVEL3:
                    if (player_row == 5'd0 && player_col == 5'd4) begin
                        level_select <= WIN_STATE;
                        win <= 1;
                    end

                WIN_STATE:
                    level_select <= WIN_STATE; // Stay locked in
            endcase
        end
    end

endmodule
