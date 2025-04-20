`timescale 1ns / 1ps
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

    parameter BLK_SIZE_X = 100, BLK_SIZE_Y = 100;
    parameter IMG_X = 0;  // image top-left X
    parameter IMG_Y = 0;  // image top-left Y
    parameter IMG_W = 100;
    parameter IMG_H = 100;

    // VGA ROM interface
    reg [13:0] pixel_addr;
    wire [11:0] pixel_block;

    // Draw output registers
    reg [3:0] draw_r_reg, draw_g_reg, draw_b_reg;
    assign draw_r = draw_r_reg;
    assign draw_g = draw_g_reg;
    assign draw_b = draw_b_reg;

    // Maze and tile setup
    reg [9:0] TILE_W, TILE_H, WALL_MARGIN;
    reg [4:0] NUM_ROWS, NUM_COLS;
    reg [3:0] walls;

    wire [4:0] maze_col = curr_x / TILE_W;
    wire [4:0] maze_row = (curr_y - 11'd100) / TILE_H;
    wire [8:0] x_in_tile = curr_x % TILE_W;
    wire [8:0] y_in_tile = (curr_y - 11'd100) % TILE_H;

    // Level-specific values
    wire [3:0] walls_l1, walls_l2, walls_13;
    wire [9:0] TILE_W1, TILE_H1, WALL_MARGIN1;
    wire [4:0] NUM_ROWS1, NUM_COLS1;
    wire [9:0] TILE_W2, TILE_H2, WALL_MARGIN2;
    wire [4:0] NUM_ROWS2, NUM_COLS2;
    wire [9:0] TILE_W3, TILE_H3, WALL_MARGIN3;
    wire [4:0] NUM_ROWS3, NUM_COLS3;
    
    // Stone texture ROM (background for maze)
    reg [13:0] bg_pixel_addr;
    wire [11:0] bg_pixel_block;
    
    stone_rom bg_inst (
        .addra(bg_pixel_addr),
        .clka(clk),
        .douta(bg_pixel_block)
    );


    // Instantiate ROM
    pacman_rom inst (
        .addra(pixel_addr),
        .clka(clk),
        .douta(pixel_block)
    );

    // Level modules
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
    .walls(walls_13),
    .TILE_W(TILE_W3),
    .TILE_H(TILE_H3),
    .NUM_ROWS(NUM_ROWS3),
    .NUM_COLS(NUM_COLS3),
    .WALL_MARGIN(WALL_MARGIN3)
    );

    // Level selection logic
    always @(*) begin
        case (level_select)
            2'd0: begin
                TILE_W = TILE_W1; TILE_H = TILE_H1; WALL_MARGIN = WALL_MARGIN1;
                NUM_ROWS = NUM_ROWS1; NUM_COLS = NUM_COLS1; walls = walls_l1;
            end
            2'd1: begin
                TILE_W = TILE_W2; TILE_H = TILE_H2; WALL_MARGIN = WALL_MARGIN2;
                NUM_ROWS = NUM_ROWS2; NUM_COLS = NUM_COLS2; walls = walls_l2;
            end
            2'd2: begin
                TILE_W = TILE_W3; TILE_H = TILE_H3; WALL_MARGIN = WALL_MARGIN3;
                NUM_ROWS = NUM_ROWS3; NUM_COLS = NUM_COLS3; walls = walls_13;
            end
            default: begin
                TILE_W = 10'd1; TILE_H = 10'd1; WALL_MARGIN = 10'd1;
                NUM_ROWS = 5'd0; NUM_COLS = 5'd0; walls = 4'b0000;
            end
        endcase
    end

    // Main drawing logic
    always @(posedge clk) begin
    if (!rst) begin
        draw_r_reg <= 4'd0;
        draw_g_reg <= 4'd0;
        draw_b_reg <= 4'd0;
        pixel_addr <= 0;
        bg_pixel_addr <= 0;
    end else begin
        // === Player block logic (ROM image displayed at block position) ===
        if ((curr_x >= blkpos_x) && (curr_x < blkpos_x + BLK_SIZE_X) &&
            (curr_y >= blkpos_y) && (curr_y < blkpos_y + BLK_SIZE_Y)) begin
            pixel_addr <= (curr_y - blkpos_y) * BLK_SIZE_X + (curr_x - blkpos_x);
            draw_r_reg <= pixel_block[11:8];
            draw_g_reg <= pixel_block[7:4];
            draw_b_reg <= pixel_block[3:0];

        // === Maze walls (white) ===
        end else if (maze_col < NUM_COLS && maze_row < NUM_ROWS &&
                    ((walls[3] && y_in_tile < WALL_MARGIN) ||
                     (walls[2] && y_in_tile >= TILE_H - WALL_MARGIN) ||
                     (walls[1] && x_in_tile < WALL_MARGIN) ||
                     (walls[0] && x_in_tile >= TILE_W - WALL_MARGIN))) begin
            draw_r_reg <= 4'd15;
            draw_g_reg <= 4'd15;
            draw_b_reg <= 4'd15;

        // Maze background (stone texture)
        end else if (maze_col < NUM_COLS && maze_row < NUM_ROWS) begin
            bg_pixel_addr <= (maze_row * TILE_H + y_in_tile) * (NUM_COLS * TILE_W) +
                             (maze_col * TILE_W + x_in_tile);
        
            draw_r_reg <= bg_pixel_block[11:8];
            draw_g_reg <= bg_pixel_block[7:4];
            draw_b_reg <= bg_pixel_block[3:0];


        end else begin
            draw_r_reg <= 4'd15;
            draw_g_reg <= 4'd05;
            draw_b_reg <= 4'd15;
        end
    end
end

endmodule
