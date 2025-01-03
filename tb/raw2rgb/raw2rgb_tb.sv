
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
parameter PATTERN = "GBRG";

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

reg [PW-1:0] horibar_r;
reg [PW-1:0] horibar_g;
reg [PW-1:0] horibar_b;
reg [PW-1:0] vertbar_r;
reg [PW-1:0] vertbar_g;
reg [PW-1:0] vertbar_b;

reg r_vsync = 0;
int frame_cnt = 0;

always @(posedge clk) begin
    if (!rstn) begin
        frame_cnt <= '0;
        r_vsync <= '0;
    end else begin
        r_vsync <= o_vsync;
        
        if (r_vsync && !o_vsync) begin
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

    default: $finish();

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
    .PATTERN(PATTERN)
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
