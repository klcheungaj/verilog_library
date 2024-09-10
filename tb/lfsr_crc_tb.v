
module lfsr_crc_tb ();

reg clk = 1;
always clk <= #1 ~clk;


reg         rst = 0;
reg [32:0]  addr = '0;
reg         addr_valid = 0;
reg [1:0]   state = 0;
wire [511:0] data;

lfsr_crc #(
    .LFSR_WIDTH(512),
    .DATA_WIDTH(33)
) u_lfsr_crc (
    .clk(clk),
    .rst(rst),
    .data_in(addr),
    .data_in_valid(addr_valid),
    .crc_out(data)
);

always @(posedge clk) begin
    case (state)
    0: begin
        addr <= addr + 1;
        addr_valid <= 0;
    end
    1: addr_valid <= 1;
    default: ;
    endcase

    state <= state + 1;
end

initial begin
    rst = 1;
    #100
    @(posedge clk)
        rst = 0;
end

endmodule
