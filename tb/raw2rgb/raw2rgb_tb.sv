
module raw2rgb_tb #(
    localparam PW = 8,
    localparam IN_PCNT = 4,
    localparam OUT_PCNT = 2,
    localparam MAX_HRES = 3840,
    localparam MAX_VRES = 2160,
    localparam Y_ACT_WID = $clog2(MAX_VRES),
    localparam X_ACT_WID = $clog2(MAX_HRES)
) (
    input                      clk,
    input                      rstn,


    output                        o_vsync,
    output                        o_hsync,
    output                        o_de,
    output                        o_valid,
    output [    X_ACT_WID-1:0]    o_x_cnt,
    output [    X_ACT_WID-1:0]    o_y_cnt,
    output [PW * OUT_PCNT*3 -1:0] o_rgb
);

parameter HRES = 480;
parameter VRES = 270;

wire [            11:0] vga_x;
wire [            11:0] vga_y;
wire                    vga_valid;
wire                    vga_de;
wire                    vga_hs;
wire                    vga_vs;
reg [PW * IN_PCNT-1:0]  vga_raw;

wire [PW * OUT_PCNT*3 -1:0] o_r;
wire [PW * OUT_PCNT*3 -1:0] o_g;
wire [PW * OUT_PCNT*3 -1:0] o_b;

assign o_rgb = {
    o_b[8 +: 8], o_g[8 +: 8], o_r[8 +: 8],
    o_b[0 +: 8], o_g[0 +: 8], o_r[0 +: 8]
};

always_comb begin
    // GBGB
    // RGRG
    case ({vga_y[0], vga_x[0]})
    // all green
    0, 1: begin
        vga_raw = {8'h0, 8'(255-vga_y), 8'h00, 8'(255-vga_y)};
    end

    2, 3: begin
        vga_raw = {8'(255-vga_y), 8'h00, 8'(255-vga_y), 8'h0};
    end

    // all blue
    0, 1: begin
        vga_raw = {8'(255-vga_y), 8'h00, 8'(255-vga_y), 8'h0};
    end

    // 2, 3: begin
    //     vga_raw = '0;
    // end
    
    // // all red
    // 0, 1: begin
    //     vga_raw = '0;
    // end

    // 2, 3: begin
    //     vga_raw = {8'h0, 8'(255-vga_y), 8'h00, 8'(255-vga_y)};
    // end
    endcase
end

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
) u_vga_gen (
    .in_pclk(clk),
    .in_rstn(rstn),

    .out_x(vga_x),
    .out_y(vga_y),
    .out_valid(vga_valid),
    .out_de(vga_de),
    .out_hs(vga_hs),
    .out_vs(vga_vs)
);

raw2rgb #(
    .PW(PW),
    .IN_PCNT(IN_PCNT),
    .OUT_PCNT(OUT_PCNT),
    .MAX_HRES(MAX_HRES),
    .MAX_VRES(MAX_VRES),
    .MAX_HTOTAL(4400),
    .MAX_VTOTAL(2250),
    .PATTERN("GBRG")
) u_raw2rgb (
    .i_pclk(clk),
    .i_rstn(rstn),

    .i_vsync(vga_vs),
    .i_hsync(vga_hs),
    .i_de(vga_de),
    .i_valid(vga_valid),
    .i_raw(vga_raw),

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


endmodule
