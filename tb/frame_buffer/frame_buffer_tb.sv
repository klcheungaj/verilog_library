
module frame_buffer_tb #(
    // HRES, VRES may be override by cmake
    parameter HRES = 1920,
    parameter VRES = 1080,
    localparam PW = 8,
    localparam IN_PCNT = 4,
    localparam OUT_PCNT = 2,
    localparam MAX_HRES = 3840,
    localparam MAX_VRES = 2160,
    localparam Y_ACT_WID = $clog2(MAX_VRES),
    localparam X_ACT_WID = $clog2(MAX_HRES)
) (
    input                         clk_wr,
    input                         clk_rd,
    input                         rstn,

    output [            11:0]     ref_x,
    output [            11:0]     ref_y,
    output                        ref_valid,
    output                        ref_de,
    output                        ref_hs,
    output                        ref_vs,
    output [PW * IN_PCNT-1:0]     ref_raw,

    output                        o_vsync,
    output                        o_hsync,
    output                        o_de,
    output                        o_valid,
    output [    X_ACT_WID-1:0]    o_x_cnt,
    output [    X_ACT_WID-1:0]    o_y_cnt,
    output [PW * OUT_PCNT*3 -1:0] o_rgb
);

parameter PATTERN = "GBRG";

wire  [  5:0]           axi_AWID;
wire  [ 32:0]           axi_AWADDR;
wire  [  7:0]           axi_AWLEN;
wire  [  2:0]           axi_AWSIZE;
wire  [  1:0]           axi_AWBURST;
wire                    axi_AWVALID;
wire  [  3:0]           axi_AWCACHE = 0;
wire                    axi_AWLOCK;
wire  [  5:0]           axi_ARID;
wire  [ 32:0]           axi_ARADDR;
wire  [  7:0]           axi_ARLEN;
wire  [  2:0]           axi_ARSIZE;
wire  [  1:0]           axi_ARBURST;
wire                    axi_ARVALID;
wire                    axi_ARLOCK;
wire                    axi_WLAST;
wire                    axi_WVALID;
wire  [511:0]           axi_WDATA;
wire  [ 63:0]           axi_WSTRB;
wire                    axi_BREADY;
wire                    axi_RREADY;
wire                    axi_AWREADY;
wire                    axi_ARREADY;
wire                    axi_WREADY;
wire  [  5:0]           axi_BID;
wire  [  1:0]           axi_BRESP;
wire                    axi_BVALID;
wire  [  5:0]           axi_RID;
wire                    axi_RLAST;
wire                    axi_RVALID;
wire  [511:0]           axi_RDATA;
wire  [  1:0]           axi_RRESP;
    
wire [            11:0] vga_x;
wire [            11:0] vga_y;
wire                    vga_valid;
wire                    vga_de;
wire                    vga_hs;
wire                    vga_vs;
reg [PW * IN_PCNT-1:0]  vga_raw;

wire [            11:0] read_x;
wire [            11:0] read_y;
wire                    read_valid;
wire                    read_de;
wire                    read_hs;
wire                    read_vs;

wire [            11:0] out_x;
wire [            11:0] out_y;
wire                    out_valid;
wire                    out_de;
wire                    out_hs;
wire                    out_vs;
reg [PW * IN_PCNT-1:0]  out_raw;

wire [PW * OUT_PCNT*3 -1:0] o_r;
wire [PW * OUT_PCNT*3 -1:0] o_g;
wire [PW * OUT_PCNT*3 -1:0] o_b;

reg [PW-1:0] horibar_r;
reg [PW-1:0] horibar_g;
reg [PW-1:0] horibar_b;
reg [PW-1:0] vertbar_r;
reg [PW-1:0] vertbar_g;
reg [PW-1:0] vertbar_b;

reg r_vsync = 0;
int frame_cnt = 0;

assign ref_x = vga_x; 
assign ref_y = vga_y; 
assign ref_valid = vga_valid; 
assign ref_de = vga_de; 
assign ref_hs = vga_hs; 
assign ref_vs = vga_vs; 
assign ref_raw = vga_raw; 
always @(posedge clk_wr) begin
    if (!rstn) begin
        frame_cnt <= '0;
        r_vsync <= '0;
    end else begin
        r_vsync <= vga_vs;
        
        if (r_vsync && !vga_vs) begin
            frame_cnt <= frame_cnt + 1;
        end
    end
end

assign o_rgb = {
    o_b[8 +: 8], o_g[8 +: 8], o_r[8 +: 8],
    o_b[0 +: 8], o_g[0 +: 8], o_r[0 +: 8]
};

always_comb begin
    case (vga_x[4 +: 3])
    0: begin
        horibar_r = '1;
        horibar_g = '1;
        horibar_b = '1;
    end

    1: begin
        horibar_r = '1;
        horibar_g = '1;
        horibar_b = '0;
    end

    2: begin
        horibar_r = '0;
        horibar_g = '1;
        horibar_b = '1;
    end

    3: begin
        horibar_r = '0;
        horibar_g = '1;
        horibar_b = '0;
    end

    4: begin
        horibar_r = '1;
        horibar_g = '0;
        horibar_b = '1;
    end

    5: begin
        horibar_r = '1;
        horibar_g = '0;
        horibar_b = '0;
    end

    6: begin
        horibar_r = '0;
        horibar_g = '0;
        horibar_b = '1;
    end

    7: begin
        horibar_r = '0;
        horibar_g = '0;
        horibar_b = '0;
    end
    endcase
end

always_comb begin
    case (vga_y[5 +: 3])
    0: begin
        vertbar_r = '1;
        vertbar_g = '1;
        vertbar_b = '1;
    end

    1: begin
        vertbar_r = '1;
        vertbar_g = '1;
        vertbar_b = '0;
    end

    2: begin
        vertbar_r = '0;
        vertbar_g = '1;
        vertbar_b = '1;
    end

    3: begin
        vertbar_r = '0;
        vertbar_g = '1;
        vertbar_b = '0;
    end

    4: begin
        vertbar_r = '1;
        vertbar_g = '0;
        vertbar_b = '1;
    end

    5: begin
        vertbar_r = '1;
        vertbar_g = '0;
        vertbar_b = '0;
    end

    6: begin
        vertbar_r = '0;
        vertbar_g = '0;
        vertbar_b = '1;
    end

    7: begin
        vertbar_r = '0;
        vertbar_g = '0;
        vertbar_b = '0;
    end
    endcase
end

always_comb begin
    case (frame_cnt)
    0: begin
        case (PATTERN)
            "RGGB": begin
                if (vga_y[0] == 0)
                    vga_raw = {horibar_g, horibar_r, horibar_g, horibar_r};
                else
                    vga_raw = {horibar_b, horibar_g, horibar_b, horibar_g};
            end
            "GRBG": begin
                if (vga_y[0] == 0)
                    vga_raw = {horibar_r, horibar_g, horibar_r, horibar_g};
                else
                    vga_raw = {horibar_g, horibar_b, horibar_g, horibar_b};
            end
            "GBRG": begin
                if (vga_y[0] == 0)
                    vga_raw = {horibar_b, horibar_g, horibar_b, horibar_g};
                else
                    vga_raw = {horibar_g, horibar_r, horibar_g, horibar_r};
            end
            "BGGR": begin
                if (vga_y[0] == 0)
                    vga_raw = {horibar_g, horibar_b, horibar_g, horibar_b};
                else
                    vga_raw = {horibar_r, horibar_g, horibar_r, horibar_g};
            end
            default: begin
                $error("Unexpected Bayer filter pattern\n");
                $stop;
            end
        endcase
    end

    1: begin
        case (PATTERN)
            "RGGB": begin
                if (vga_y[0] == 0)
                    vga_raw = {vertbar_g, vertbar_r, vertbar_g, vertbar_r};
                else
                    vga_raw = {vertbar_b, vertbar_g, vertbar_b, vertbar_g};
            end
            "GRBG": begin
                if (vga_y[0] == 0)
                    vga_raw = {vertbar_r, vertbar_g, vertbar_r, vertbar_g};
                else
                    vga_raw = {vertbar_g, vertbar_b, vertbar_g, vertbar_b};
            end
            "GBRG": begin
                if (vga_y[0] == 0)
                    vga_raw = {vertbar_b, vertbar_g, vertbar_b, vertbar_g};
                else
                    vga_raw = {vertbar_g, vertbar_r, vertbar_g, vertbar_r};
            end
            "BGGR": begin
                if (vga_y[0] == 0)
                    vga_raw = {vertbar_g, vertbar_b, vertbar_g, vertbar_b};
                else
                    vga_raw = {vertbar_r, vertbar_g, vertbar_r, vertbar_g};
            end
            default: begin
                $error("Unexpected Bayer filter pattern\n");
                $stop;
            end
        endcase
    end

    // default: $finish();

    endcase
end

vga_gen #(
    .H_SyncPulse(44),
    .H_BackPorch(148),
    .H_ActivePix(HRES/4),
    .H_FrontPorch(88),
    .V_SyncPulse(5),
    .V_BackPorch(36),
    .V_ActivePix(VRES),
    .V_FrontPorch(4),
    .FIFO_WIDTH(12),
    .P_Cnt(1)
) u1_vga_gen (
    .in_pclk(clk_wr),
    .in_rstn(rstn),

    .out_x(vga_x),
    .out_y(vga_y),
    .out_valid(vga_valid),
    .out_de(vga_de),
    .out_hs(vga_hs),
    .out_vs(vga_vs)
);

vga_gen #(
    .H_SyncPulse(44),
    .H_BackPorch(148),
    .H_ActivePix(HRES/2),
    .H_FrontPorch(88),
    .V_SyncPulse(5),
    .V_BackPorch(36),
    .V_ActivePix(VRES),
    .V_FrontPorch(4),
    .FIFO_WIDTH(12),
    .P_Cnt(1)
) u2_vga_gen (
    .in_pclk(clk_rd),
    .in_rstn(rstn),

    .out_x      (read_x),
    .out_y      (read_y),
    .out_valid  (read_valid),
    .out_de     (read_de),
    .out_hs     (read_hs),
    .out_vs     (read_vs)
);

axi_ram #(
    .DATA_WIDTH(512),
    .ADDR_WIDTH(28),
    .PIPELINE_OUTPUT(0)
) u_axi_ram (
    .clk(clk_wr),
    .rst(~rstn),

    .s_axi_awid(axi_AWID),
    .s_axi_awaddr(axi_AWADDR),
    .s_axi_awlen(axi_AWLEN),
    .s_axi_awsize(axi_AWSIZE),
    .s_axi_awburst(axi_AWBURST),
    .s_axi_awlock(axi_AWLOCK),
    .s_axi_awcache(axi_AWCACHE),
    .s_axi_awprot(axi_AWPROT),
    .s_axi_awvalid(axi_AWVALID),
    .s_axi_awready(axi_AWREADY),
    .s_axi_wdata(axi_WDATA),
    .s_axi_wstrb(axi_WSTRB),
    .s_axi_wlast(axi_WLAST),
    .s_axi_wvalid(axi_WVALID),
    .s_axi_wready(axi_WREADY),
    .s_axi_bid(axi_BID),
    .s_axi_bresp(axi_BRESP),
    .s_axi_bvalid(axi_BVALID),
    .s_axi_bready(axi_BREADY),
    .s_axi_arid(axi_ARID),
    .s_axi_araddr(axi_ARADDR),
    .s_axi_arlen(axi_ARLEN),
    .s_axi_arsize(axi_ARSIZE),
    .s_axi_arburst(axi_ARBURST),
    .s_axi_arlock(axi_ARLOCK),
    .s_axi_arcache(axi_ARCACHE),
    .s_axi_arprot(axi_ARPROT),
    .s_axi_arvalid(axi_ARVALID),
    .s_axi_arready(axi_ARREADY),
    .s_axi_rid(axi_RID),
    .s_axi_rdata(axi_RDATA),
    .s_axi_rresp(axi_RRESP),
    .s_axi_rlast(axi_RLAST),
    .s_axi_rvalid(axi_RVALID),
    .s_axi_rready(axi_RREADY)
);

frame_buffer_512 inst_frame_buffer_512 (
    .wr_p_clk_0(clk_wr),
    .wr_p_clk_1(clk_wr),
    .rd_p_clk_0(clk_rd),
    .rd_p_clk_1(clk_rd),
    .axi_clk   (clk_wr),
    .axi_rstn  (rstn),
    .wr_rstn_0 (rstn),
    .wr_rstn_1 (rstn),
    .rd_rstn_0 (rstn),
    .rd_rstn_1 (rstn),

    .x_win_wr_0  (HRES),
    .x_win_wr_1  (HRES),
    .x_win_rd_0  (HRES),
    .x_win_rd_1  (HRES),
    .x_start_wr_0(13'd0),
    .x_start_wr_1(13'd0),
    .x_start_rd_0(13'd0),
    .x_start_rd_1(13'd0),
    .y_win_wr_0  (VRES),
    .y_win_wr_1  (1),
    .y_win_rd_0  (VRES),
    .y_win_rd_1  (VRES),
    .y_start_wr_0(13'd0),
    .y_start_wr_1(13'd0),
    .y_start_rd_0(13'd0),
    .y_start_rd_1(13'd0),

    .arid   (axi_ARID),
    .araddr (axi_ARADDR),
    .arlen  (axi_ARLEN),
    .arsize (axi_ARSIZE),
    .arburst(axi_ARBURST),
    .arlock (axi_ARLOCK),
    .arvalid(axi_ARVALID),
    .arready(axi_ARREADY),
    .awid   (axi_AWID),
    .awaddr (axi_AWADDR),
    .awlen  (axi_AWLEN),
    .awsize (axi_AWSIZE),
    .awburst(axi_AWBURST),
    .awlock (axi_AWLOCK),
    .awvalid(axi_AWVALID),
    .awready(axi_AWREADY),
    .wdata  (axi_WDATA),
    .wstrb  (axi_WSTRB),
    .wlast  (axi_WLAST),
    .wvalid (axi_WVALID),
    .wready (axi_WREADY),
    .rid    (axi_RID),
    .rdata  (axi_RDATA),
    .rlast  (axi_RLAST),
    .rvalid (axi_RVALID),
    .rready (axi_RREADY),
    .bid    (axi_BID),
    .bvalid (axi_BVALID),
    .bready (axi_BREADY),

    .in_0_x_wr (vga_x << 2),
    .in_0_y_wr (vga_y),
    .in_0_wr_en(vga_valid),
    .in_0_hs   (vga_hs),
    .in_0_vs   (vga_vs),
    .in_0_wr_00(vga_raw[0 +: 8]),
    .in_0_wr_01(vga_raw[8 +: 8]),
    .in_0_wr_10(vga_raw[16 +: 8]),
    .in_0_wr_11(vga_raw[24 +: 8]),

    .in_1_x_wr (0),
    .in_1_y_wr (0),
    .in_1_wr_en(0),
    .in_1_hs   (0),
    .in_1_vs   (0),
    .in_1_wr_00(0),
    .in_1_wr_01(0),
    .in_1_wr_10(0),
    .in_1_wr_11(0),

    .in_0_de   (read_de),
    .in_0_valid(read_valid),
    .in_0_hsync(read_hs),
    .in_0_vsync(read_vs),

    .in_1_de   (0),
    .in_1_valid(0),
    .in_1_hsync(0),
    .in_1_vsync(0),

    .out_0_de   (out_de),
    .out_0_valid(out_valid),
    .out_0_hsync(out_hs),
    .out_0_vsync(out_vs),
    .out_0_rd_00(out_raw[7:0]),
    .out_0_rd_01(out_raw[15:8]),
    .out_0_rd_10(out_raw[23:16]),
    .out_0_rd_11(out_raw[31:24]),

    .out_1_de   (),
    .out_1_valid(),
    .out_1_hsync(),
    .out_1_vsync(),
    .out_1_rd_00(),
    .out_1_rd_01(),
    .out_1_rd_10(),
    .out_1_rd_11()
);

raw2rgb #(
    .PW(PW),
    .IN_PCNT(IN_PCNT),
    .OUT_PCNT(OUT_PCNT),
    .MAX_HRES(MAX_HRES),
    .MAX_VRES(MAX_VRES),
    .MAX_HTOTAL(4400),
    .MAX_VTOTAL(2250),
    .PATTERN(PATTERN)
) u_raw2rgb (
    .i_pclk(clk_rd),
    .i_rstn(rstn),

    .i_vsync(out_vs),
    .i_hsync(out_hs),
    .i_de(out_de),
    .i_valid(out_valid),
    .i_raw(out_raw),

    .o_vsync(o_vsync),
    .o_hsync(o_hsync),
    .o_de(o_de),
    .o_valid(o_valid),
    .o_x_cnt(o_x_cnt),
    .o_y_cnt(o_y_cnt),
    .o_r(o_r),
    .o_g(o_g),
    .o_b(o_b)
);


// initial begin
//     forever @(posedge clk_wr) begin
//         if (axi_ARVALID && axi_ARREADY) begin
//             $display("[%t] new read transaction. Address: %x", $time(), axi_ARADDR);
//         end

//         if (axi_AWVALID && axi_AWREADY) begin
//             $display("[%t] new write transaction. Address: %x", $time(), axi_AWADDR);
//         end
//     end
// end

endmodule
