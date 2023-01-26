
module color_bar (
    input               i_arstn,
    input               pll_locked,
    output              o_pixel_rstn,
    output              o_lcd_rstn,
    output              o_global_rstn,
    output [8:0]        o_frame_cnt,

    input               i_fb_clk,
    input               i_sysclk,

    output              o_vs,
    output              o_hs,
    output              o_valid,
    output [15:0]       o_r,
    output [15:0]       o_g,
    output [15:0]       o_b,

	input		        i_axi_awready,
	input		        i_axi_wready,
	input		        i_axi_bvalid,
	output [6:0]        o_axi_awaddr,
	output              o_axi_awvalid,
	output [31:0]       o_axi_wdata,
	output   	        o_axi_wvalid,
	output   	        o_axi_bready,
	
	input		        i_axi_arready,
	input		[31:0]  i_axi_rdata,
	input		        i_axi_rvalid,
	output 	[6:0]       o_axi_araddr,
	output 	            o_axi_arvalid,
	output 	            o_axi_rready
);

localparam MAX_HRES = 11'd1080;
localparam MAX_VRES = 11'd1920;
localparam HSP = 10'd100;
localparam HBP = 10'd100;
localparam HFP = 10'd250;
localparam VSP = 10'd3;
localparam VBP = 10'd5;
localparam VFP = 11'd6;

localparam P_CNT = 3'd2;
localparam VC_HRES = 16'd270;
localparam DATATYPE = 6'h2B;
localparam HRES_WIDTH = $clog2(MAX_HRES);
localparam VRES_WIDTH = $clog2(MAX_VRES);

localparam RESET_COUNT          = 26;
localparam RESET_LCD            = 26'd6250000;
localparam RELEASE_RESET_LCD    = 26'd12500000;
localparam RELEASE_RESET_ALL    = 26'd25000000;


reg         r_rstn_video = 0;
reg  [10:0] r_hs_cnt = 0;
reg  [ 8:0] r_frame_cnt = 0;
reg  [25:0] r_rst_cnt = 0;
reg         r_lcd_rstn = 1;
reg         r_cam_rstn = 1;
reg         r_lcd_init = 0;
reg         global_rstn = 0;
wire        w_confdone;

////////////////////////////////////////////////////////////////
// System & Debugger
wire       w_cam_arstn;
wire       w_cam_arst;
wire       w_sysclk_arstn;
wire       w_sysclk_arst;
wire       w_sysclkdiv2_arstn;
wire       w_sysclkdiv2_arst;
wire       w_fb_clk_arstn;
wire       w_fb_clk_arst;
////////////////////////////////////////////////////////////////
// Debayer & RGB gain
wire                  w_debayer_valid; 
wire                  w_debayer_hs;
wire                  w_debayer_vs;
wire                  w_debayer_de;
wire [          10:0] w_debayer_x;
wire [          10:0] w_debayer_y;
wire [          15:0] w_debayer_r;
wire [          15:0] w_debayer_g;
wire [          15:0] w_debayer_b;

reg                   r_debayer_vs_1P = 0;
reg                   r_debayer_hs_1P = 0;
reg                   r_debayer_valid_1P;
reg                   r_debayer_de_1P;
reg  [          10:0] r_debayer_x_1P = 0;
reg  [          10:0] r_debayer_y_1P = 0;
reg  [          15:0] r_debayer_r_1P = 0;
reg  [          15:0] r_debayer_g_1P = 0;
reg  [          15:0] r_debayer_b_1P = 0;

assign o_frame_cnt = r_frame_cnt;
assign o_global_rstn = global_rstn;
assign o_pixel_rstn = r_rstn_video;
assign o_lcd_rstn = r_lcd_rstn;
assign o_r = r_debayer_r_1P;
assign o_g = r_debayer_g_1P;
assign o_b = r_debayer_b_1P;
assign o_valid = r_debayer_valid_1P;
assign o_vs = r_debayer_vs_1P;
assign o_hs = r_debayer_hs_1P;

reset_ctrl #(
    .NUM_RST       (4),
    .CYCLE         (2),
    .IN_RST_ACTIVE (4'b0000),
    .OUT_RST_ACTIVE(4'b1010)
) inst_reset_ctrl (
    .i_arst({4{global_rstn}}),
    .i_clk({
        {2{i_sysclk}}, {2{i_fb_clk}}
    }),
    .o_srst({
        w_sysclk_arst,
        w_sysclk_arstn,
        w_fb_clk_arst,
        w_fb_clk_arstn
    })
);

////////////////////////////////////////////////////////////////
// Debayer
vga_gen #(
    .H_SyncPulse (HSP),
    .H_BackPorch (HBP+270),
    .H_ActivePix (MAX_HRES/2),
    .H_FrontPorch(HFP+270),
    .V_SyncPulse (VSP),
    .V_BackPorch (VBP),
    .V_ActivePix (MAX_VRES),
    .V_FrontPorch(VFP),
    .P_Cnt       (3'd1)
) inst_rx_vga_gen (
    .in_pclk  (i_sysclk),
    .in_rstn  (w_confdone),

    .out_x    (w_debayer_x),
    .out_y    (w_debayer_y),
    .out_valid(w_debayer_valid),
    .out_de   (w_debayer_de),
    .out_hs   (w_debayer_hs),
    .out_vs   (w_debayer_vs)
);

reg [10:0] pattern_sel;
always @(*) begin
    // pattern_sel = w_debayer_x + r_frame_cnt;
    pattern_sel = w_debayer_x + r_frame_cnt;
end

always @(negedge w_sysclk_arstn or posedge i_sysclk) begin
    if (~w_sysclk_arstn) begin
        r_debayer_vs_1P <= 1'b0;
        r_debayer_hs_1P <= 1'b0;
        r_debayer_valid_1P <= 1'b0;
        r_debayer_de_1P <= 1'b0;
        r_debayer_x_1P  <= {11{1'b0}};
        r_debayer_y_1P  <= {11{1'b0}};
        r_debayer_r_1P  <= {16{1'b0}};
        r_debayer_g_1P  <= {16{1'b0}};
        r_debayer_b_1P  <= {16{1'b0}};

        r_rstn_video    <= 1'b0;
        r_hs_cnt        <= {11{1'b0}};
        r_frame_cnt     <= {9{1'b0}};
        r_lcd_init      <= 1'b0;
    end else begin
        r_debayer_vs_1P <= w_debayer_vs;
        r_debayer_hs_1P <= w_debayer_hs;
        r_debayer_de_1P <= w_debayer_de;
        r_debayer_valid_1P <= w_debayer_valid;

        if (r_debayer_vs_1P && ~w_debayer_vs) begin
            r_debayer_x_1P <= 0;
            r_debayer_y_1P <= 0;
            r_frame_cnt <= r_frame_cnt + 1'b1;
        end else if (r_debayer_de_1P && ~w_debayer_de) begin
            r_debayer_x_1P <= 0;
            r_debayer_y_1P <= r_debayer_y_1P + 1;
        end else if (w_debayer_vs && w_debayer_hs && w_debayer_de && w_debayer_valid) begin
            r_debayer_x_1P <= r_debayer_x_1P + 1;
        end

        if (~r_lcd_init) begin
            r_debayer_r_1P  <= 0;
            r_debayer_g_1P  <= 0;
            r_debayer_b_1P  <= 0;
            if (r_frame_cnt > 120)
                r_lcd_init <= 1'b1; 
        end else begin
            r_debayer_r_1P  <= pattern_sel[7] ? 16'hFFFF : 0;
            r_debayer_g_1P  <= pattern_sel[8] ? 16'hFFFF : 0;
            r_debayer_b_1P  <= pattern_sel[9] ? 16'hFFFF : 0;
        end

        if (~w_debayer_hs && r_debayer_hs_1P) r_hs_cnt <= r_hs_cnt + 1'b1;

        if (r_frame_cnt == VFP) r_rstn_video <= 1'b1;
    end
end

always @(negedge i_arstn or posedge i_fb_clk) begin
    if (~i_arstn) begin
        r_rst_cnt   <= {RESET_COUNT{1'b0}};
        r_lcd_rstn  <= 1'b1;
        r_cam_rstn  <= 1'b1;
        global_rstn <= 1'b0;
    end else begin
        if (pll_locked) begin
            if (r_rst_cnt != {RESET_COUNT{1'b1}}) begin
                r_rst_cnt <= r_rst_cnt + 1'b1;
                if (r_rst_cnt == RESET_LCD) begin
                    r_lcd_rstn <= 1'b0;
                    r_cam_rstn   <= 1'b0;
                end else if (r_rst_cnt == RELEASE_RESET_LCD) begin
                    r_lcd_rstn <= 1'b1;
                    r_cam_rstn <= 1'b1;
                end else if (r_rst_cnt == RELEASE_RESET_ALL) begin
                    global_rstn <= 1'b1;
                end
            end
        end else begin
            r_rst_cnt   <= {RESET_COUNT{1'b0}};
            global_rstn <= 1'b0;
            r_lcd_rstn  <= 1'b1;
            r_cam_rstn  <= 1'b1;
        end
    end
end


// Panel driver initialization
panel_config #(
    .INITIAL_CODE("../rtl/panel/IPhone_7p_1080p_reg.mem"),
    .REG_DEPTH   (9'd15)
) inst_panel_config (
    .i_axi_clk(i_fb_clk),
    .i_restn  (w_fb_clk_arstn),

    .i_axi_awready(i_axi_awready),
    .i_axi_wready (i_axi_wready),
    .i_axi_bvalid (i_axi_bvalid),
    .o_axi_awaddr (o_axi_awaddr),
    .o_axi_awvalid(o_axi_awvalid),
    .o_axi_wdata  (o_axi_wdata),
    .o_axi_wvalid (o_axi_wvalid),
    .o_axi_bready (o_axi_bready),

    .i_axi_arready(i_axi_arready),
    .i_axi_rdata  (i_axi_rdata),
    .i_axi_rvalid (i_axi_rvalid),
    .o_axi_araddr (o_axi_araddr),
    .o_axi_arvalid(o_axi_arvalid),
    .o_axi_rready (o_axi_rready),

    .o_addr_cnt(),
    .o_state   (),
    .o_confdone(w_confdone),

    .i_dbg_we      (0),
    .i_dbg_din     (0),
    .i_dbg_addr    (0),
    .o_dbg_dout    (),
    .i_dbg_reconfig(0)
);


endmodule
