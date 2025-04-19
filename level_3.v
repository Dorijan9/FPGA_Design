`timescale 1ns / 1ps

module level3(
    input  [2:0] row,
    input  [2:0] col,
    output reg [3:0] walls,
    output [9:0] TILE_W,
    output [9:0] TILE_H,
    output [4:0] NUM_ROWS,
    output [4:0] NUM_COLS,
    output [9:0] WALL_MARGIN
);
    // Maze configuration: [row][col] = 4'b[T, B, L, R]
    reg [3:0] maze [0:5][0:10];
    assign TILE_W = 10'd288;
    assign TILE_H = 10'd130;
    assign NUM_ROWS = 5'd5;
    assign NUM_COLS = 5'd10;
    assign WALL_MARGIN = 10'd3;
initial begin
// Row 0
    maze[0][0] = 4'b1110;
    maze[0][1] = 4'b1100;
    maze[0][2] = 4'b1001;
    maze[0][3] = 4'b1010;
    maze[0][4] = 4'b1100;
    maze[0][5] = 4'b1000;
    maze[0][6] = 4'b1100;
    maze[0][7] = 4'b1000;
    maze[0][8] = 4'b1100;
    maze[0][9] = 4'b1101;
    // Row 1
    maze[1][0] = 4'b1010;
    maze[1][1] = 4'b1100;
    maze[1][2] = 4'b0101;
    maze[1][3] = 4'b0010;
    maze[1][4] = 4'b1101;
    maze[1][5] = 4'b0110;
    maze[1][6] = 4'b1001;
    maze[1][7] = 4'b0111;
    maze[1][8] = 4'b1010;
    maze[1][9] = 4'b1001;
    // Row 2
    maze[2][0] = 4'b0110;
    maze[2][1] = 4'b1001;
    maze[2][2] = 4'b1110;
    maze[2][3] = 4'b0001;
    maze[2][4] = 4'b1010;
    maze[2][5] = 4'b1001;
    maze[2][6] = 4'b0110;
    maze[2][7] = 4'b1100;
    maze[2][8] = 4'b0101;
    maze[2][9] = 4'b0011;
    // Row 3
    maze[3][0] = 4'b1011;
    maze[3][1] = 4'b0110;
    maze[3][2] = 4'b1000;
    maze[3][3] = 4'b0101;
    maze[3][4] = 4'b0011;
    maze[3][5] = 4'b0110;
    maze[3][6] = 4'b1100;
    maze[3][7] = 4'b1001;
    maze[3][8] = 4'b1010;
    maze[3][9] = 4'b0001;
    // Row 4
    maze[4][0] = 4'b0110;
    maze[4][1] = 4'b1100;
    maze[4][2] = 4'b0100;
    maze[4][3] = 4'b1100;
    maze[4][4] = 4'b0101;
    maze[4][5] = 4'b1110;
    maze[4][6] = 4'b1100;
    maze[4][7] = 4'b0100;
    maze[4][8] = 4'b0101;
    maze[4][9] = 4'b0110;
end
always @(*) begin
        if (row < 5 && col < 10)
            walls = maze[row][col];
        else
            walls = 4'b0000; // Default if out of bounds
    end
endmodule
