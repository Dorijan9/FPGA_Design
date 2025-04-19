`timescale 1ns / 1ps
module drawcon(
    input [10:0] blkpos_x,
    input [10:0] blkpos_y,
    input clk,
    input rst,
    input [1:0] level_select,
    output wire [255:0] pixel_block,  
    output [3:0] draw_r,
    output [3:0] draw_g,
    output [3:0] draw_b,
    input [10:0] curr_x,
    input [10:0] curr_y
);

    // Image drawing parameters
    parameter ID_X_OFFSET = 11'd1350;
    parameter ID_Y_OFFSET = 11'd120;
    parameter ID_WIDTH = 11'd128;
    parameter ID_HEIGHT = 11'd64;

    // Final tile dimensions (selected per level)
    reg [9:0] TILE_W, TILE_H, WALL_MARGIN;
    reg [4:0] NUM_ROWS, NUM_COLS;
    
    //pacman
    reg [9:0] pixel_addr;

    // Common tile position (updated after TILE_W/H assignment)
    wire [4:0] maze_col;
    wire [4:0] maze_row;
    wire [8:0] x_in_tile;
    wire [8:0] y_in_tile;

    assign maze_col = curr_x / TILE_W;
    assign maze_row = (curr_y - 11'd100) / TILE_H;
    assign x_in_tile = curr_x % TILE_W;
    assign y_in_tile = (curr_y - 11'd100) % TILE_H;

    // Level tile outputs
    wire [3:0] walls_l1, walls_l2, walls_13;
    wire [9:0] TILE_W1, TILE_H1, WALL_MARGIN1;
    wire [4:0] NUM_ROWS1, NUM_COLS1;
    wire [9:0] TILE_W2, TILE_H2, WALL_MARGIN2;
    wire [4:0] NUM_ROWS2, NUM_COLS2;
    wire [9:0] TILE_W3, TILE_H3, WALL_MARGIN3;
    wire [4:0] NUM_ROWS3, NUM_COLS3;
    
    pacman_rom pacman_rom_inst (
        .addra(pixel_addr),
        .clka(clk),
        .ena(1'b1),
        .douta(pixel_block)
    );

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

    reg [3:0] walls;
    reg [12:0] id_addr;
    wire [11:0] id_pixel;
    wire [7:0] score;
    
    blk_mem_gen_0 id_image_rom (
         .clka(clk),
         .ena(1'b1),  
         .addra(id_addr),
         .douta(id_pixel)
     );

    always @(*) begin
        case (level_select)
            2'd0: begin
                TILE_W      = TILE_W1;
                TILE_H      = TILE_H1;
                WALL_MARGIN = WALL_MARGIN1;
                NUM_ROWS    = NUM_ROWS1;
                NUM_COLS    = NUM_COLS1;
                walls       = walls_l1;
            end
            2'd1: begin
                TILE_W      = TILE_W2;
                TILE_H      = TILE_H2;
                WALL_MARGIN = WALL_MARGIN2;
                NUM_ROWS    = NUM_ROWS2;
                NUM_COLS    = NUM_COLS2;
                walls       = walls_l2;
            end
            2'd2: begin
                TILE_W      = TILE_W3;
                TILE_H      = TILE_H3;
                WALL_MARGIN = WALL_MARGIN3;
                NUM_ROWS    = NUM_ROWS3;
                NUM_COLS    = NUM_COLS3;
                walls       = walls_13;
             end
            default: begin
                TILE_W      = 10'd1;
                TILE_H      = 10'd1;
                WALL_MARGIN = 10'd1;
                NUM_ROWS    = 5'd0;
                NUM_COLS    = 5'd0;
                walls       = 4'b0000;
            end
        endcase
    end

    // RGB logic
    reg [3:0] draw_r_reg, draw_g_reg, draw_b_reg;
    assign draw_r = draw_r_reg;
    assign draw_g = draw_g_reg;
    assign draw_b = draw_b_reg;

    always @(*) begin
        draw_r_reg = 4'd0;
        draw_g_reg = 4'd0;
        draw_b_reg = 4'd15;

        if ((curr_x >= blkpos_x) && (curr_x < blkpos_x + 8) &&
            (curr_y >= blkpos_y) && (curr_y < blkpos_y + 8)) begin
            pixel_addr = (curr_y - blkpos_y) * 8 + (curr_x - blkpos_x);
            draw_r_reg = 4'h8;
            draw_g_reg = 4'h8;
            draw_b_reg = 4'h0;
                    
         end
         
           id_addr = 13'd0;
 
         if ((curr_x >= ID_X_OFFSET) && (curr_x < ID_X_OFFSET + ID_WIDTH) &&
             (curr_y >= ID_Y_OFFSET) && (curr_y < ID_Y_OFFSET + ID_HEIGHT) ) begin
             draw_r_reg = id_pixel[11:8];
             draw_g_reg = id_pixel[7:4];
             draw_b_reg = id_pixel[3:0];
             if (id_addr == (curr_y - ID_Y_OFFSET) * ID_WIDTH + (curr_x - ID_X_OFFSET))
             id_addr <= 0;
             else 
             id_addr <= id_addr + 1;
        end
        else if (maze_col < NUM_COLS && maze_row < NUM_ROWS) begin
            if (walls[3] && y_in_tile < WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[2] && y_in_tile >= TILE_H - WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[1] && x_in_tile < WALL_MARGIN)
                draw_r_reg = 4'd15;
            else if (walls[0] && x_in_tile >= TILE_W - WALL_MARGIN)
                draw_r_reg = 4'd15;
        end
    end

endmodule
