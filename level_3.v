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
    reg [4:0] maze [0:25][0:25];
    assign TILE_W = 10'd32;
    assign TILE_H = 10'd32;
    assign NUM_ROWS = 5'd25;
    assign NUM_COLS = 5'd25;
    assign WALL_MARGIN = 10'd3;
initial begin
// Row 0
maze[0][0]  = 4'b0000;  maze[0][1]  = 4'b0100;  maze[0][2]  = 4'b0000;  maze[0][3]  = 4'b0000;  maze[0][4]  = 4'b0000;
maze[0][5]  = 4'b0100;  maze[0][6]  = 4'b0100;  maze[0][7]  = 4'b0100;  maze[0][8]  = 4'b0100;  maze[0][9]  = 4'b0100;
maze[0][10] = 4'b0100;  maze[0][11] = 4'b0100;  maze[0][12] = 4'b0100;  maze[0][13] = 4'b0100;  maze[0][14] = 4'b0100;
maze[0][15] = 4'b0100;  maze[0][16] = 4'b0000;  maze[0][17] = 4'b0000;  maze[0][18] = 4'b0000;  maze[0][19] = 4'b0000;
maze[0][20] = 4'b0100;  maze[0][21] = 4'b0100;  maze[0][22] = 4'b0100;  maze[0][23] = 4'b0100;  maze[0][24] = 4'b0000;

// Row 1
maze[1][0]  = 4'b0000;  maze[1][1]  = 4'b1110;  maze[1][2]  = 4'b1100;  maze[1][3]  = 4'b1100;  maze[1][4]  = 4'b1100;
maze[1][5]  = 4'b1100;  maze[1][6]  = 4'b1100;  maze[1][7]  = 4'b1001;  maze[1][8]  = 4'b1000;  maze[1][9]  = 4'b1100;
maze[1][10] = 4'b1100;  maze[1][11] = 4'b1100;  maze[1][12] = 4'b1100;  maze[1][13] = 4'b1100;  maze[1][14] = 4'b1100;
maze[1][15] = 4'b1100;  maze[1][16] = 4'b1100;  maze[1][17] = 4'b1110;  maze[1][18] = 4'b1100;  maze[1][19] = 4'b1100;
maze[1][20] = 4'b1100;  maze[1][21] = 4'b1100;  maze[1][22] = 4'b1100;  maze[1][23] = 4'b1101;  maze[1][24] = 4'b0000;

// Row 2
maze[2][0]  = 4'b0000;  maze[2][1]  = 4'b1110;  maze[2][2]  = 4'b1010;  maze[2][3]  = 4'b1100;  maze[2][4]  = 4'b1100;
maze[2][5]  = 4'b1100;  maze[2][6]  = 4'b1100;  maze[2][7]  = 4'b0101;  maze[2][8]  = 4'b0001;  maze[2][9]  = 4'b1100;
maze[2][10] = 4'b1100;  maze[2][11] = 4'b1100;  maze[2][12] = 4'b1100;  maze[2][13] = 4'b1100;  maze[2][14] = 4'b1100;
maze[2][15] = 4'b1100;  maze[2][16] = 4'b1110;  maze[2][17] = 4'b1110;  maze[2][18] = 4'b1100;  maze[2][19] = 4'b1100;
maze[2][20] = 4'b1100;  maze[2][21] = 4'b1100;  maze[2][22] = 4'b1001;  maze[2][23] = 4'b1101;  maze[2][24] = 4'b0000;

// Row 3
maze[3][0]  = 4'b0000;  maze[3][1]  = 4'b1110;  maze[3][2]  = 4'b0110;  maze[3][3]  = 4'b0100;  maze[3][4]  = 4'b0100;
maze[3][5]  = 4'b0100;  maze[3][6]  = 4'b0100;  maze[3][7]  = 4'b0100;  maze[3][8]  = 4'b0101;  maze[3][9]  = 4'b1101;
maze[3][10] = 4'b1101;  maze[3][11] = 4'b1101;  maze[3][12] = 4'b1101;  maze[3][13] = 4'b1101;  maze[3][14] = 4'b1101;
maze[3][15] = 4'b1110;  maze[3][16] = 4'b1110;  maze[3][17] = 4'b0100;  maze[3][18] = 4'b0100;  maze[3][19] = 4'b0100;
maze[3][20] = 4'b0100;  maze[3][21] = 4'b0001;  maze[3][22] = 4'b0001;  maze[3][23] = 4'b1101;  maze[3][24] = 4'b0000;

// Row 4
maze[4][0]  = 4'b0000;  maze[4][1]  = 4'b1110;  maze[4][2]  = 4'b0010;  maze[4][3]  = 4'b0111;  maze[4][4]  = 4'b0111;
maze[4][5]  = 4'b0111;  maze[4][6]  = 4'b0111;  maze[4][7]  = 4'b0111;  maze[4][8]  = 4'b0111;  maze[4][9]  = 4'b1111;
maze[4][10] = 4'b1111;  maze[4][11] = 4'b1111;  maze[4][12] = 4'b1111;  maze[4][13] = 4'b1111;  maze[4][14] = 4'b1111;
maze[4][15] = 4'b1111;  maze[4][16] = 4'b0100;  maze[4][17] = 4'b0101;  maze[4][18] = 4'b0100;  maze[4][19] = 4'b0100;
maze[4][20] = 4'b0100;  maze[4][21] = 4'b0101;  maze[4][22] = 4'b0001;  maze[4][23] = 4'b1101;  maze[4][24] = 4'b0000;

end
always @(*) begin
        if (row < 25 && col < 25)
            walls = maze[row][col];
        else
            walls = 4'b0000; // Default if out of bounds
    end
endmodule
