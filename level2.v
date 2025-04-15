module level2(
    input  [2:0] row,
    input  [2:0] col,
    output reg [3:0] walls,       
    output [9:0] TILE_W,
    output [9:0] TILE_H,
    output [2:0] NUM_ROWS,
    output [2:0] NUM_COLS,
    output [9:0] WALL_MARGIN
);
    assign TILE_W = 10'd288;
    assign TILE_H = 10'd130;
    assign NUM_ROWS = 3'd5;
    assign NUM_COLS = 3'd7;
    assign WALL_MARGIN = 10'd3;

    reg [3:0] maze [0:4][0:6];  // FIXED: range [0:6] to match NUM_COLS=7

    initial begin
        // Row 0
        maze[0][0] = 4'b0110;
        maze[0][1] = 4'b1100;
        maze[0][2] = 4'b0000;
        maze[0][3] = 4'b1110;
        maze[0][4] = 4'b1001;
        maze[0][5] = 4'b1111;
        maze[0][6] = 4'b1111;

        // Row 1
        maze[1][0] = 4'b1010;
        maze[1][1] = 4'b1001;
        maze[1][2] = 4'b0110;
        maze[1][3] = 4'b1100;
        maze[1][4] = 4'b0001;
        maze[1][5] = 4'b1111;
        maze[1][6] = 4'b1111;

        // Row 2
        maze[2][0] = 4'b0111;
        maze[2][1] = 4'b0000;
        maze[2][2] = 4'b0000;
        maze[2][3] = 4'b0000;
        maze[2][4] = 4'b0000;
        maze[2][5] = 4'b1100;
        maze[2][6] = 4'b1111;

        // Row 3
        maze[3][0] = 4'b0010;
        maze[3][1] = 4'b0101;
        maze[3][2] = 4'b1100;
        maze[3][3] = 4'b0101;
        maze[3][4] = 4'b0001;
        maze[3][5] = 4'b1111;
        maze[3][6] = 4'b1111;

        // Row 4
        maze[4][0] = 4'b0110;
        maze[4][1] = 4'b0100;
        maze[4][2] = 4'b0001;
        maze[4][3] = 4'b0100;
        maze[4][4] = 4'b0101;
        maze[4][5] = 4'b1111;
        maze[4][6] = 4'b1111;
    end

    // ACTUAL WALL LOOKUP: This was missing in your original module.
    always @(*) begin
        if (row < 5 && col < 7)
            walls = maze[row][col];
        else
            walls = 4'b0000;  // Default no walls if out of bounds
    end
endmodule
