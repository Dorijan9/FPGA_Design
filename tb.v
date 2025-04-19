module tb_top_game;

    // Inputs
    reg clk;
    reg rst;
    reg [4:0] btn;
    reg [15:0] sw;

    // Outputs
    wire [3:0] pix_r;
    wire [3:0] pix_g;
    wire [3:0] pix_b;
    wire hsync;
    wire vsync;

    // Instantiate the Unit Under Test (UUT)
    top_game uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .sw(sw),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    // Stimulus
    initial begin
        // Initialize Inputs
        rst = 1;
        btn = 5'b00000;
        sw = 16'b0;

        // Hold reset for a few cycles
        #20;
        rst = 0;

        // Wait for FSM to stabilize
        #100;

        // Simulate movement
        btn = 5'b00010; // move left
        #100;
        btn = 5'b00100; // move right
        #100;
        btn = 5'b00001; // move up
        #100;
        btn = 5'b10000; // move down
        #100;

        // Simulate reset
        rst = 1;
        #20;
        rst = 0;

        // Finish
        #500;
        $finish;
    end

endmodule
