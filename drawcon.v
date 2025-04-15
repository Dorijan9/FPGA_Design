module drawcon(
    input [10:0] blkpos_x,
    input [10:0] blkpos_y,
    input clk,
    input rst,
    input [1:0] level_select,
    output [3:0] draw_r,
    output [3:0] draw_g,
    output [3:0] draw_b,
    input [10:0] curr_x,
    input [10:0] curr_y
);

    // Common tile position
    wire [4:0] maze_col;
    wire [4:0] maze_row;
    wire [8:0] x_in_tile;
    wire [8:0] y_in_tile;

    // Final tile dimensions (selected per level)
    reg [9:0] TILE_W, TILE_H, WALL_MARGIN;
    reg [4:0] NUM_ROWS, NUM_COLS;

    assign maze_col = curr_x / TILE_W;
    assign maze_row = curr_y / TILE_H;
    assign x_in_tile = curr_x % TILE_W;
    assign y_in_tile = curr_y % TILE_H;

    // Level tile outputs
    wire [3:0] walls_l1, walls_l2, walls_l3;
    wire [9:0] TILE_W1, TILE_H1, WALL_MARGIN1;
    wire [4:0] NUM_ROWS1, NUM_COLS1;

    wire [9:0] TILE_W2, TILE_H2, WALL_MARGIN2;
    wire [4:0] NUM_ROWS2, NUM_COLS2;

    wire [9:0] TILE_W3, TILE_H3, WALL_MARGIN3;
    wire [4:0] NUM_ROWS3, NUM_COLS3;

    level1 level1_inst (
        .row(maze_row),
        .col(maze_col),
        .walls(walls_l1),
        .TILE_W(TILE_W1),
        .TILE_H(TILE_H1),
        .NUM_ROWS(NUM_ROWS1),
        .NUM_COLS(NUM_COLS1),
        .WALL_MARGIN(WALL_MARGIN1)
    );

    level2 level2_inst (
        .row(maze_row),
        .col(maze_col),
        .walls(walls_l2),
        .TILE_W(TILE_W2),
        .TILE_H(TILE_H2),
        .NUM_ROWS(NUM_ROWS2),
        .NUM_COLS(NUM_COLS2),
        .WALL_MARGIN(WALL_MARGIN2)
    );

    level3 level3_inst (
        .row(maze_row),
        .col(maze_col),
        .walls(walls_l3),
        .TILE_W(TILE_W3),
        .TILE_H(TILE_H3),
        .NUM_ROWS(NUM_ROWS3),
        .NUM_COLS(NUM_COLS3),
        .WALL_MARGIN(WALL_MARGIN3)
    );

    reg [3:0] walls;

    always @(*) begin
        case (level_select)
            2'd0: begin
                walls       = walls_l1;
                TILE_W      = TILE_W1;
                TILE_H      = TILE_H1;
                WALL_MARGIN = WALL_MARGIN1;
                NUM_ROWS    = NUM_ROWS1;
                NUM_COLS    = NUM_COLS1;
            end
            2'd1: begin
                walls       = walls_l2;
                TILE_W      = TILE_W2;
                TILE_H      = TILE_H2;
                WALL_MARGIN = WALL_MARGIN2;
                NUM_ROWS    = NUM_ROWS2;
                NUM_COLS    = NUM_COLS2;
            end
            2'd2: begin
                walls       = walls_l3;
                TILE_W      = TILE_W3;
                TILE_H      = TILE_H3;
                WALL_MARGIN = WALL_MARGIN3;
                NUM_ROWS    = NUM_ROWS3;
                NUM_COLS    = NUM_COLS3;
            end
            default: begin
                walls       = 4'b0000;
                TILE_W      = 10'd1;
                TILE_H      = 10'd1;
                WALL_MARGIN = 10'd1;
                NUM_ROWS    = 5'd0;
                NUM_COLS    = 5'd0;
            end
        endcase
    end

    // RGB logic
    reg [3:0] draw_r_reg, draw_g_reg, draw_b_reg;
    assign draw_r = draw_r_reg;
    assign draw_g = draw_g_reg;
    assign draw_b = draw_b_reg;

    always @(*) begin
        // Background = blue
        draw_r_reg = 4'd0;
        draw_g_reg = 4'd0;
        draw_b_reg = 4'd15;

        // Maze wall = red
        if (maze_col < NUM_COLS && maze_row < NUM_ROWS) begin
            if (walls[3] && y_in_tile < WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[2] && y_in_tile >= TILE_H - WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[1] && x_in_tile < WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[0] && x_in_tile >= TILE_W - WALL_MARGIN)
                draw_r_reg = 4'd15;
        end

        // Player block = green
        if ((curr_x >= blkpos_x) && (curr_x < blkpos_x + 10) &&
            (curr_y >= blkpos_y) && (curr_y < blkpos_y + 10)) begin
            draw_r_reg = 4'd0;
            draw_g_reg = 4'd15;
            draw_b_reg = 4'd0;
        end
    end
endmodule
