module game_fsm(
    input clk,
    input rst,
    input [4:0] player_row,
    input [4:0] player_col,
    output reg [1:0] level_select
);

    // State constants
    wire [1:0] LEVEL1 = 2'd0;
    wire [1:0] LEVEL2 = 2'd1;
    wire [1:0] LEVEL3 = 2'd2;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            level_select <= LEVEL1;
        else begin
            case (level_select)
                2'd0: if (player_row == 5'd4 && player_col == 5'd2)
                          level_select <= LEVEL2;

                2'd1: if (player_row == 5'd5 && player_col == 5'd2)
                          level_select <= LEVEL3;

                default: level_select <= level_select;
            endcase
        end
    end

endmodule
