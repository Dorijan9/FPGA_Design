`timescale 1ns / 1ps
module top_game(
    input clk,
    input rst,
    input [4:0] btn,
    input [15:0] sw,
    output [3:0] pix_r,
    output [3:0] pix_g,
    output [3:0] pix_b,
    output hsync,
    output vsync
);

    // Pixel clock
    wire pixclk;
    clk_wiz_0 pll (.clk_out1(pixclk), .clk_in1(clk));

    // Game clock
    reg [20:0] clk_div;
    reg game_clk;
    always @(posedge clk) begin
        if (!rst) begin
            clk_div <= 0;
            game_clk <= 0;
        end else if (clk_div == 21'd200_000) begin
            clk_div <= 0;
            game_clk <= ~game_clk;
        end else begin
            clk_div <= clk_div + 1;
        end
    end

    reg [1:0] prev_level_select;
    wire level_complete;
    wire [7:0] score;

    // Player state
    reg [10:0] blkpos_x = 11'd394;
    reg [10:0] blkpos_y = 11'd141; // initial Y with infobar offset
    reg [4:0] current_row, current_col, adj_row, adj_col;
    reg [9:0] x_in_tile, y_in_tile;
    reg [1:0] prev_level = 2'd0;

    // FSM
    wire [1:0] level_select;
    game_fsm fsm_inst (
        .clk(game_clk),
        .rst(rst),
        .player_row(current_row),
        .player_col(current_col),
        .level_select(level_select)
    );

    score_counter score_counter_inst (
        .clk(game_clk),
        .rst(rst),
        .level_complete(level_complete),
        .score(score)
    );

    // Level 1
    wire [9:0] TILE_W1, TILE_H1, WALL_MARGIN1;
    wire [4:0] NUM_ROWS1, NUM_COLS1;
    wire [3:0] dummy1;
    level1 l1info (.row(5'd0), .col(5'd0), .walls(dummy1), .TILE_W(TILE_W1), .TILE_H(TILE_H1), .NUM_ROWS(NUM_ROWS1), .NUM_COLS(NUM_COLS1), .WALL_MARGIN(WALL_MARGIN1));

    // Level 2
    wire [9:0] TILE_W2, TILE_H2, WALL_MARGIN2;
    wire [4:0] NUM_ROWS2, NUM_COLS2;
    wire [3:0] dummy2;
    level2 l2info (.row(5'd0), .col(5'd0), .walls(dummy2), .TILE_W(TILE_W2), .TILE_H(TILE_H2), .NUM_ROWS(NUM_ROWS2), .NUM_COLS(NUM_COLS2), .WALL_MARGIN(WALL_MARGIN2));

    // Level 3
    wire [9:0] TILE_W3, TILE_H3, WALL_MARGIN3;
    wire [4:0] NUM_ROWS3, NUM_COLS3;
    wire [3:0] dummy3;
    level3 l3info (.row(5'd0), .col(5'd0), .walls(dummy3), .TILE_W(TILE_W3), .TILE_H(TILE_H3), .NUM_ROWS(NUM_ROWS3), .NUM_COLS(NUM_COLS3), .WALL_MARGIN(WALL_MARGIN3));

    // Maze outputs
    reg [9:0] TILE_W, TILE_H, WALL_MARGIN;
    reg [4:0] NUM_ROWS, NUM_COLS;

    always @(*) begin
        case (level_select)
            2'd0: begin TILE_W = TILE_W1; TILE_H = TILE_H1; NUM_ROWS = NUM_ROWS1; NUM_COLS = NUM_COLS1; WALL_MARGIN = WALL_MARGIN1; end
            2'd1: begin TILE_W = TILE_W2; TILE_H = TILE_H2; NUM_ROWS = NUM_ROWS2; NUM_COLS = NUM_COLS2; WALL_MARGIN = WALL_MARGIN2; end
            2'd2: begin TILE_W = TILE_W3; TILE_H = TILE_H3; NUM_ROWS = NUM_ROWS3; NUM_COLS = NUM_COLS3; WALL_MARGIN = WALL_MARGIN3; end
            default: begin TILE_W = 10'd0; TILE_H = 10'd0; NUM_ROWS = 5'd0; NUM_COLS = 5'd0; WALL_MARGIN = 10'd0; end
        endcase
    end

    wire [3:0] walls_curr_l1, walls_adj_l1, walls_curr_l2, walls_adj_l2, walls_curr_l3, walls_adj_l3;
    level1 l1_cur (.row(current_row), .col(current_col), .walls(walls_curr_l1), .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());
    level1 l1_adj (.row(adj_row),     .col(adj_col),     .walls(walls_adj_l1),  .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());
    level2 l2_cur (.row(current_row), .col(current_col), .walls(walls_curr_l2), .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());
    level2 l2_adj (.row(adj_row),     .col(adj_col),     .walls(walls_adj_l2),  .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());
    level3 l3_cur (.row(current_row), .col(current_col), .walls(walls_curr_l3), .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());
    level3 l3_adj (.row(adj_row),     .col(adj_col),     .walls(walls_adj_l3),  .TILE_W(), .TILE_H(), .NUM_ROWS(), .NUM_COLS(), .WALL_MARGIN());

    reg [3:0] wall_curr_mux, wall_adj_mux;

    always @(*) begin
        case (level_select)
            2'd0: begin wall_curr_mux = walls_curr_l1; wall_adj_mux = walls_adj_l1; end
            2'd1: begin wall_curr_mux = walls_curr_l2; wall_adj_mux = walls_adj_l2; end
            2'd2: begin wall_curr_mux = walls_curr_l3; wall_adj_mux = walls_adj_l3; end
            default: begin wall_curr_mux = 4'd0; wall_adj_mux = 4'd0; end
        endcase
    end

    // Movement + level change logic
    always @(posedge game_clk) begin
        if (level_select != prev_level) begin
            blkpos_x <= 11'd394;
            blkpos_y <= 11'd141;
            prev_level <= level_select;
        end else if (!rst || btn[0]) begin
            blkpos_x <= 11'd394;
            blkpos_y <= 11'd141;
        end else begin
            prev_level <= level_select;

            current_col = blkpos_x / TILE_W;
            current_row = (blkpos_y - 11'd100) / TILE_H;
            x_in_tile   = blkpos_x % TILE_W;
            y_in_tile   = (blkpos_y - 11'd100) % TILE_H;

            adj_col = current_col;
            adj_row = current_row;

            case (btn[4:1])
                4'b0001: if (current_row > 0) adj_row = current_row - 1;
                4'b1000: if (current_row < NUM_ROWS - 1) adj_row = current_row + 1;
                4'b0010: if (current_col > 0) adj_col = current_col - 1;
                4'b0100: if (current_col < NUM_COLS - 1) adj_col = current_col + 1;
            endcase

            case (btn[4:1])
                4'b0001: if (!(wall_curr_mux[3] && y_in_tile <= WALL_MARGIN || wall_adj_mux[2] && y_in_tile <= WALL_MARGIN)) blkpos_y <= blkpos_y - 2;
                4'b1000: if (!(wall_curr_mux[2] && y_in_tile + 10 >= TILE_H - WALL_MARGIN || wall_adj_mux[3] && y_in_tile + 10 >= TILE_H - WALL_MARGIN)) blkpos_y <= blkpos_y + 2;
                4'b0010: if (!(wall_curr_mux[1] && x_in_tile <= WALL_MARGIN || wall_adj_mux[0] && x_in_tile <= WALL_MARGIN)) blkpos_x <= blkpos_x - 2;
                4'b0100: if (!(wall_curr_mux[0] && x_in_tile + 10 >= TILE_W - WALL_MARGIN || wall_adj_mux[1] && x_in_tile + 10 >= TILE_W - WALL_MARGIN)) blkpos_x <= blkpos_x + 2;
            endcase
        end
    end

    always @(posedge game_clk or posedge rst) begin
        if (rst) begin
            prev_level_select <= 2'd0;
        end else begin
            prev_level_select <= level_select;
        end
    end

    assign level_complete = (level_select != prev_level_select);

    // VGA drawing
    wire [3:0] draw_r, draw_g, draw_b;
    wire [10:0] curr_x, curr_y;

    drawcon drawcon_inst (
        .blkpos_x(blkpos_x),
        .blkpos_y(blkpos_y),
        .clk(clk),
        .rst(rst),
        .level_select(level_select),
        .draw_r(draw_r),
        .draw_g(draw_g),
        .draw_b(draw_b),
        .curr_x(curr_x),
        .curr_y(curr_y)
    );

    vga vga_inst (
        .clk(pixclk),
        .rst(rst),
        .draw_r(draw_r),
        .draw_g(draw_g),
        .draw_b(draw_b),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .hsync(hsync),
        .vsync(vsync)
    );

endmodule

