module ram512x8_sp(wdata, addr, rclk, re, wclk, we, rdata);
    parameter AWIDTH = 9;
    parameter DWIDTH = 8;
    localparam DEPTH = 1 << AWIDTH;
    localparam MAX_DATA = (1<<DWIDTH)-1;
    input [DWIDTH-1:0] wdata;
    input [AWIDTH-1:0] addr;
    input rclk, re, wclk, we;
    output reg [DWIDTH-1:0] rdata;
    reg [DWIDTH-1:0] mem [DEPTH-1:0];
    // different read and write clock, forces READ_UNKNOWN mode
    always@(posedge wclk) begin
    if (we) begin
    mem[addr] = wdata;
    end
    end
    always@(posedge rclk) begin
    if (re) begin
    rdata = mem[addr];
    end
    end
endmodule