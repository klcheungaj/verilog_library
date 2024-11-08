
module axis_align_tb ();

parameter PERIOD = 10;
parameter AXIS_DW = 64;
localparam AXIS_KW = ((AXIS_DW-1)>>3)+1;
logic clk = 0;
logic rst = 1;

logic                 s_axis_tvalid = '0;  
logic                 s_axis_tready;
logic   [AXIS_DW-1:0] s_axis_tdata = '0;
logic   [AXIS_KW-1:0] s_axis_tkeep = '0;
logic                 s_axis_tlast = '0;

logic                 m_axis_tready;

logic                 m_axis_tvalid;
logic   [AXIS_DW-1:0] m_axis_tdata;
logic   [AXIS_KW-1:0] m_axis_tkeep;
logic                 m_axis_tlast;

always #(PERIOD/2) clk = !clk;

axis_align #(
    .AXIS_DW(AXIS_DW)
) u_axis_align (
    .clk(clk),
    .rst(rst),
    .s_axis_tvalid(s_axis_tvalid),  
    .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tkeep(s_axis_tkeep),
    .s_axis_tlast(s_axis_tlast),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tlast(m_axis_tlast)
);

initial begin
    #50
    rst = 0;
    #50
    @(negedge clk)
    s_axis_tdata = {$urandom(), $urandom()};
    s_axis_tvalid = 1;
    s_axis_tkeep = 8'hC0;
    forever @(negedge clk) begin
        if (s_axis_tready) begin
            s_axis_tdata = {$urandom(), $urandom()};
            s_axis_tvalid = 1;
            s_axis_tkeep = 8'hFF;
            break;
        end
    end
    forever @(negedge clk) begin
        if (s_axis_tready) begin
            s_axis_tdata = {$urandom(), $urandom()};
            s_axis_tvalid = 1;
            s_axis_tkeep = 8'hFF;
            break;
        end
    end
    forever @(negedge clk) begin
        if (s_axis_tready) begin
            s_axis_tdata = {$urandom(), $urandom()};
            s_axis_tvalid = 1;
            s_axis_tkeep = 8'h03;
            s_axis_tlast = 1;
            break;
        end
    end
    forever @(negedge clk) begin
        if (s_axis_tready) begin
            s_axis_tdata = '0;
            s_axis_tvalid ='0;
            s_axis_tkeep = '0;
            s_axis_tlast = '0;
            break;
        end
    end
    $stop;
end

always_ff @(posedge clk) begin
    if (rst) begin
        m_axis_tready <= 0;
    end else begin
        m_axis_tready <= $urandom();
    end
end

endmodule
