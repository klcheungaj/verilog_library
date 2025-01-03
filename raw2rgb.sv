
/**
 * assmuing:
 * 1. hsync is HIGH in vertical porch
 * 2. de is LOW in vertical porch
 * 3. vsync, hsync and de must be continuous
 * 4. valid can be discontinuous
 * 5. if valid is HIGH, de must also be HIGH
 * 6. if de is HIGH, hsync must also be HIGH
 * 7. if hsync is HIGH, vsync must also be HIGH
 * 8. porch much be larger than 1. No matter veritcal or horizontaol, front or back
 * 12. when PCNT is larger than 1, the first pixel is in low byte side. i.e. PIXEl1 - PIXEL 0
 * 
 * behavior:
 * 1. input sync signals are delayed by 2 lines + 2 clock cycles
 * 
 * TODO:
 * 1. first/last line & pixel should be all 0
 */
module raw2rgb #(
    parameter PW = 8,           // pixel data width
    parameter IN_PCNT = 4,      // number of pixel in each input cycle. Must be larger or equal to OUT_PCNT
    parameter OUT_PCNT = 2,     // number of pixel in each output cycle
    parameter MAX_HRES = 1920,  // horizontal resolutoin. same as H_ACTIVE. 
    parameter MAX_VRES = 1080,
    parameter MAX_HTOTAL = 2200,  // including HRES(H_ACTIVE), HSA, HBP and HFP. 
    parameter MAX_VTOTAL = 1125,
    parameter PATTERN = "GBRG",  // bayer filter pattern. RGGB, GRBG, GBRG, BGGR
    localparam Y_ACT_WID = $clog2(MAX_VRES),
    localparam X_ACT_WID = $clog2(MAX_HRES)
) (
    input                           i_pclk,
    input                           i_rstn,

	input	                        i_vsync,
	input	                        i_hsync,
	input	                        i_de,
	input	                        i_valid,
    input   [PW * IN_PCNT-1:0]      i_raw,

	output	                        o_vsync,
	output	                        o_hsync,
	output	                        o_de,
	output	                        o_valid,
    output  [X_ACT_WID-1:0]         o_x_cnt,
    output  [X_ACT_WID-1:0]         o_y_cnt,
    output  [PW * OUT_PCNT-1:0]     o_r,
    output  [PW * OUT_PCNT-1:0]     o_g,
    output  [PW * OUT_PCNT-1:0]     o_b

    // input [1:0]                     pattern 
);

/**
 *  GBRG (from top left corner): 
 *      0 1 2 3
 *      - - - -
 *  0 | G B G B 
 *  1 | R G R G
 *  2 | G B G B
 *  3 | R G R G
 * 
 *  where G is the first data (LSB) in the i_raw signal
 *  the same for other patterns (RGGB, GRBG, BGGR)
 */

localparam WR_AW = $clog2(MAX_HRES / IN_PCNT);   // each address may contain multiple pixels
localparam RD_AW = $clog2(MAX_HRES / OUT_PCNT);   // each address may contain multiple pixels
genvar idx;
// input
reg [WR_AW-1:0] in_xcnt;
reg          hsync_r1;
reg          de_r1;
reg	[1:0]	 r_line_cnt;
reg			 r_line_in_1L;
reg [1:0]    wr_lb_sel = 0; //line buffer sel
reg          wr_region_sel = 0;//avoid overwriting the data being read 
// output
logic [Y_ACT_WID-1:0] y_active_cnt;
logic [X_ACT_WID-1:0] x_active_cnt; // 1 count 1 pixel
logic [Y_ACT_WID-1:0] y_active_cnt_r1;
logic [X_ACT_WID-1:0] x_active_cnt_r1; // 1 count 1 pixel
logic [Y_ACT_WID-1:0] y_active_cnt_r2;
logic [X_ACT_WID-1:0] x_active_cnt_r2; // 1 count 1 pixel
logic [1:0] pixel_pos;
logic [1:0] rd_lb_sel = 0;    //line buffer sel
logic [2:0] valid_cnt = 0;
logic       rd_region_sel_line1 = 0;
logic       rd_region_sel_line2 = 0;
logic       rd_region_sel_line3 = 1;
logic       r_line_in_2L;
logic	    w_de_2L;
logic	    w_valid_2L;
logic	    w_hsync_2L;
logic	    w_vsync_2L;
logic	    de_2L_r1;
logic	    valid_2L_r1;
logic	    hsync_2L_r1;
logic	    vsync_2L_r1;
logic	    de_2L_r2;
logic	    valid_2L_r2;
logic	    hsync_2L_r2;
logic	    vsync_2L_r2;
logic	    de_2L_r3;
logic	    valid_2L_r3;
logic	    hsync_2L_r3;
logic	    vsync_2L_r3;
logic	    de_2L_r4;
logic	    valid_2L_r4;
logic	    hsync_2L_r4;
logic	    vsync_2L_r4;
logic	    de_2L_r5;
logic	    valid_2L_r5;
logic	    hsync_2L_r5;
logic	    vsync_2L_r5;
logic [PW * OUT_PCNT-1:0] dout_line3_r1;
logic [PW * OUT_PCNT-1:0] dout_line1_r1;
logic [PW * OUT_PCNT-1:0] dout_line2_r1;
logic [PW-1:0]           dout_line3_r2;
logic [PW-1:0]           dout_line1_r2;
logic [PW-1:0]           dout_line2_r2;
wire [PW * OUT_PCNT-1:0] w_dout_line1;
wire [PW * OUT_PCNT-1:0] w_dout_line2;
wire [PW * OUT_PCNT-1:0] w_dout_line3;
wire [PW * OUT_PCNT-1:0] w_dout1;
wire [PW * OUT_PCNT-1:0] w_dout2;
wire [PW * OUT_PCNT-1:0] w_dout3;
wire [PW * OUT_PCNT * 2 + PW-1:0] w_raw_line1_cat;
wire [PW * OUT_PCNT * 2 + PW-1:0] w_raw_line2_cat;
wire [PW * OUT_PCNT * 2 + PW-1:0] w_raw_line3_cat;

logic [PW+3-1:0] r_r[OUT_PCNT]; // + 3 because add up to 5 pixel 
logic [PW+3-1:0] r_g[OUT_PCNT];
logic [PW+3-1:0] r_b[OUT_PCNT];
logic [PW * OUT_PCNT-1:0] r_r_clamp;
logic [PW * OUT_PCNT-1:0] r_g_clamp;
logic [PW * OUT_PCNT-1:0] r_b_clamp;
assign o_vsync = vsync_2L_r5;
assign o_hsync = hsync_2L_r5;
assign o_de = de_2L_r5;
assign o_valid = valid_2L_r5; 
assign o_r = r_r_clamp;
assign o_g = r_g_clamp;
assign o_b = r_b_clamp;
assign o_y_cnt = y_active_cnt_r2;
assign o_x_cnt = x_active_cnt_r2;

assign w_dout_line1 = y_active_cnt == 0 ? '0 : rd_lb_sel == 0 ? w_dout3 : rd_lb_sel == 1 ? w_dout1 : w_dout2; 
assign w_dout_line2 = rd_lb_sel == 0 ? w_dout1 : rd_lb_sel == 1 ? w_dout2 : w_dout3; 
assign w_dout_line3 = rd_lb_sel == 0 ? w_dout2 : rd_lb_sel == 1 ? w_dout3 : w_dout1; 
assign w_raw_line1_cat = {w_dout_line1, dout_line1_r1, dout_line1_r2};  // {3, 2, 1, 0, -1}
assign w_raw_line2_cat = {w_dout_line2, dout_line2_r1, dout_line2_r2};
assign w_raw_line3_cat = {w_dout_line3, dout_line3_r1, dout_line3_r2};


always_ff @(posedge i_pclk or negedge i_rstn) begin : pipelining
    if (!i_rstn) begin
        hsync_r1 <= '0;
        de_r1 <= '0;
        valid_2L_r1 <= '0;
        de_2L_r1 <= '0;
        hsync_2L_r1 <= '0;
        vsync_2L_r1 <= '0;
        de_2L_r2 <= '0;
        valid_2L_r2 <= '0;
        hsync_2L_r2 <= '0;
        vsync_2L_r2 <= '0;
        de_2L_r3 <= '0;
        valid_2L_r3 <= '0;
        hsync_2L_r3 <= '0;
        vsync_2L_r3 <= '0;
        de_2L_r4 <= '0;
        valid_2L_r4 <= '0;
        hsync_2L_r4 <= '0;
        vsync_2L_r4 <= '0;
        de_2L_r5 <= '0;
        valid_2L_r5 <= '0;
        hsync_2L_r5 <= '0;
        vsync_2L_r5 <= '0;
        dout_line1_r1 <= '0;
        dout_line2_r1 <= '0;
        dout_line3_r1 <= '0;
        dout_line1_r2 <= '0;
        dout_line2_r2 <= '0;
        dout_line3_r2 <= '0;
        y_active_cnt_r1 <= '0;
        x_active_cnt_r1 <= '0;
        y_active_cnt_r2 <= '0;
        x_active_cnt_r2 <= '0;
        valid_cnt <= '0;
    end else begin
        hsync_r1 <= i_hsync;
        de_r1 <= i_de;
        
        // -----------------------------------------------------------------------------
        // -- adjust valid duty cycle
        // -----------------------------------------------------------------------------
        //TODO: support other IN_PCNT and OUT_PCNT values
        if (!w_valid_2L) begin
            valid_cnt <= valid_cnt + 1;
            if (w_de_2L && (valid_cnt + 1 < (IN_PCNT / OUT_PCNT)))
                valid_2L_r1 <= 1;
            else
                valid_2L_r1 <= 0;
        end else begin
            valid_cnt <= 0;
            valid_2L_r1 <= 1;
        end
        de_2L_r1 <= w_de_2L;        
        hsync_2L_r1 <= w_hsync_2L;
        vsync_2L_r1 <= w_vsync_2L;
        
        // -------------------------------------------------------
        // -- delay by 1 cycle before Counting x_active and y_active and debayer stage
        // -------------------------------------------------------
        de_2L_r2 <= de_2L_r1;
        valid_2L_r2 <= valid_2L_r1;
        hsync_2L_r2 <= hsync_2L_r1;
        vsync_2L_r2 <= vsync_2L_r1;

        // -------------------------------------------------------
        // -- clamp stage
        // -------------------------------------------------------
        de_2L_r3 <= de_2L_r2;
        valid_2L_r3 <= valid_2L_r2;
        hsync_2L_r3 <= hsync_2L_r2;
        vsync_2L_r3 <= vsync_2L_r2;
        // -------------------------------------------------------
        // -- output stage
        // -------------------------------------------------------
        de_2L_r4 <= de_2L_r3;
        valid_2L_r4 <= valid_2L_r3;
        hsync_2L_r4 <= hsync_2L_r3;
        vsync_2L_r4 <= vsync_2L_r3;

        de_2L_r5 <= de_2L_r4;
        valid_2L_r5 <= valid_2L_r4;
        hsync_2L_r5 <= hsync_2L_r4;
        vsync_2L_r5 <= vsync_2L_r4;

        if (de_2L_r1 && valid_2L_r1) begin
            dout_line1_r1 <= w_dout_line1;
            dout_line2_r1 <= w_dout_line2;
            dout_line3_r1 <= w_dout_line3;
            dout_line1_r2 <= dout_line1_r1[PW * (OUT_PCNT-1) +: PW];
            dout_line2_r2 <= dout_line2_r1[PW * (OUT_PCNT-1) +: PW];
            dout_line3_r2 <= dout_line3_r1[PW * (OUT_PCNT-1) +: PW];
        end

        y_active_cnt_r1 <= y_active_cnt;
        x_active_cnt_r1 <= x_active_cnt;
        y_active_cnt_r2 <= y_active_cnt_r1;
        x_active_cnt_r2 <= x_active_cnt_r1;
    end
end

always_ff @(posedge i_pclk or negedge i_rstn) begin : write_control
    if (!i_rstn) begin
        in_xcnt <= '0;
        wr_lb_sel <= '0;
        wr_region_sel <= '0;
        r_line_cnt <= '0;
        r_line_in_1L <= '0;
        r_line_in_2L <= '0;
    end else begin
        if (~i_hsync) begin
            in_xcnt <= '0;
        end else if (i_de && i_valid) begin
            in_xcnt <= in_xcnt + 1;
        end
        
        if (~i_vsync) begin
            wr_lb_sel <= '0;
            wr_region_sel <= '0;
        end else if (de_r1 && !i_de) begin
            if (wr_lb_sel == 2) begin
                wr_lb_sel <= '0;
                wr_region_sel <= wr_region_sel + 1;
            end else begin
                wr_lb_sel <= wr_lb_sel + 1;
            end
        end

		if (i_hsync && !hsync_r1)
			r_line_cnt	<= r_line_cnt + 1'b1;
		
		if (r_line_cnt == 1)
			r_line_in_1L	<= 1'b1;
		
		if (r_line_cnt == 2)
			r_line_in_2L	<= 1'b1;
    end
end

always_ff @(posedge i_pclk or negedge i_rstn) begin : read_control
    if (!i_rstn) begin
        y_active_cnt <= '0;
        x_active_cnt <= '0;
        rd_lb_sel <= '0;
        rd_region_sel_line1 <= '0;
        rd_region_sel_line2 <= '0;
        rd_region_sel_line3 <= 1;
    end else begin
        if (!vsync_2L_r1) begin
            y_active_cnt <= '0;
        end else if (de_2L_r3 && ~de_2L_r2) begin
            y_active_cnt <= y_active_cnt + 1;
        end

        if (!hsync_2L_r1) begin
            x_active_cnt <= '0;
        end else if (valid_2L_r1 && de_2L_r1) begin
            x_active_cnt <= x_active_cnt + OUT_PCNT;
        end
        
        if (!vsync_2L_r1) begin
            rd_lb_sel <= '0;
            rd_region_sel_line1 <= '0;
            rd_region_sel_line2 <= '0;
            rd_region_sel_line3 <= 1;
        end else if (de_2L_r3 && ~de_2L_r2) begin
            case (rd_lb_sel)
                0: begin
                    rd_lb_sel <= 1;
                    rd_region_sel_line3 <= !rd_region_sel_line3;
                end
                1: begin
                    rd_lb_sel <= 2;
                    rd_region_sel_line1 <= !rd_region_sel_line1;
                end
                2: begin
                    rd_lb_sel <= 0;
                    rd_region_sel_line2 <= !rd_region_sel_line2;
                end
                default: rd_lb_sel <= 0;
            endcase
        end
    end
end

generate
    for (idx=0 ; idx<OUT_PCNT ; idx=idx+1) begin : debayer
        logic [X_ACT_WID-1:0] x_active_cnt_tmp;
        logic [Y_ACT_WID-1:0] y_active_cnt_tmp;
        if (PATTERN == "RGGB") begin
            // shift y by 1 compared to the default GBRG
            always_comb begin
                x_active_cnt_tmp = x_active_cnt + idx;
                y_active_cnt_tmp = y_active_cnt + 1;
            end
        end else if (PATTERN == "GRBG") begin
            // shift y and x by 1 compared to the default GBRG
            always_comb begin
                x_active_cnt_tmp = x_active_cnt + idx + 1;
                y_active_cnt_tmp = y_active_cnt + 1;
            end
        end else if (PATTERN == "BGGR") begin
            // shift x by 1 compared to the default GBRG
            always_comb begin
                x_active_cnt_tmp = x_active_cnt + idx + 1;
                y_active_cnt_tmp = y_active_cnt + 0;
            end
        end else begin  // PATTERN == "GBRG" by default
            always_comb begin
                x_active_cnt_tmp = x_active_cnt + idx;
                y_active_cnt_tmp = y_active_cnt + 0;
            end
        end

        always_ff @(posedge i_pclk or negedge i_rstn) begin
            if (!i_rstn) begin
                r_g[idx] <= '0;
                r_b[idx] <= '0;
                r_r[idx] <= '0;
            end else begin
                case ({y_active_cnt_tmp[0], x_active_cnt_tmp[0]})
                0: begin
                    r_g[idx] <= (w_raw_line1_cat[idx*PW +: PW] + w_raw_line1_cat[(idx+2)*PW +: PW] + 
                                w_raw_line2_cat[(idx+1)*PW +: PW] + 
                                w_raw_line3_cat[idx*PW +: PW] + w_raw_line3_cat[(idx+2)*PW +: PW]) / 5;
                    r_b[idx] <= (w_raw_line2_cat[(idx)*PW +: PW] + w_raw_line2_cat[(idx+2)*PW +: PW]) / 2;
                    r_r[idx] <= (w_raw_line1_cat[(idx+1)*PW +: PW] + w_raw_line3_cat[(idx+1)*PW +: PW]) / 2;
                end

                1: begin
                    r_g[idx] <= ((w_raw_line1_cat[(idx+1)*PW +: PW]) + w_raw_line2_cat[(idx)*PW +: PW] + 
                                w_raw_line2_cat[(idx+2)*PW +: PW] + w_raw_line3_cat[(idx+1)*PW +: PW]) / 4;
                    r_b[idx] <= w_raw_line2_cat[(idx+1)*PW +: PW];
                    r_r[idx] <= (w_raw_line1_cat[idx*PW +: PW] + w_raw_line1_cat[(idx+2)*PW +: PW] + 
                                w_raw_line3_cat[idx*PW +: PW] + w_raw_line3_cat[(idx+2)*PW +: PW]) / 4;
                end

                2: begin
                    r_g[idx] <= ((w_raw_line1_cat[(idx+1)*PW +: PW]) + w_raw_line2_cat[(idx)*PW +: PW] + 
                                w_raw_line2_cat[(idx+2)*PW +: PW] + w_raw_line3_cat[(idx+1)*PW +: PW]) / 4;
                    r_b[idx] <= (w_raw_line1_cat[idx*PW +: PW] + w_raw_line1_cat[(idx+2)*PW +: PW] + 
                                w_raw_line3_cat[idx*PW +: PW] + w_raw_line3_cat[(idx+2)*PW +: PW]) / 4;
                    r_r[idx] <= w_raw_line2_cat[(idx+1)*PW +: PW];
                end

                3: begin
                    r_g[idx] <= (w_raw_line1_cat[idx*PW +: PW] + w_raw_line1_cat[(idx+2)*PW +: PW] + 
                                w_raw_line2_cat[(idx+1)*PW +: PW] + 
                                w_raw_line3_cat[idx*PW +: PW] + w_raw_line3_cat[(idx+2)*PW +: PW]) / 5;
                    r_b[idx] <= (w_raw_line1_cat[(idx+1)*PW +: PW] + w_raw_line3_cat[(idx+1)*PW +: PW]) / 2;
                    r_r[idx] <= (w_raw_line2_cat[(idx)*PW +: PW] + w_raw_line2_cat[(idx+2)*PW +: PW]) / 2;
                end
                endcase
            end
        end

        
        always_ff @(posedge i_pclk or negedge i_rstn) begin
            if (!i_rstn) begin
                r_g_clamp[idx*PW +: PW] <= '0;
                r_b_clamp[idx*PW +: PW] <= '0;
                r_r_clamp[idx*PW +: PW] <= '0;
            end else begin
                r_g_clamp[idx*PW +: PW] <= r_g[idx] >= 64'd255 ? 8'd255 : r_g[idx][0 +: PW];
                r_b_clamp[idx*PW +: PW] <= r_b[idx] >= 64'd255 ? 8'd255 : r_b[idx][0 +: PW];
                r_r_clamp[idx*PW +: PW] <= r_r[idx] >= 64'd255 ? 8'd255 : r_r[idx][0 +: PW];
            end
        end
    end
endgenerate


//TODO: use generate for loop
simple_dual_port_ram_asym #(
	.WR_DATA_WIDTH(PW * IN_PCNT),
	.WR_ADDR_WIDTH(WR_AW+1),
	.RD_DATA_WIDTH(PW * OUT_PCNT),
	.RD_ADDR_WIDTH(RD_AW+1),
	.OUTPUT_REG("FALSE"),
	.RAM_INIT_FILE("")
) inst_line_buffer_1 (
    .wdata(i_raw),
    .waddr({wr_region_sel, in_xcnt}), 
    .wclk(i_pclk), 
    .we(wr_lb_sel == 0 && i_de && i_valid), 
    
    .rclk(i_pclk),
    .raddr({rd_region_sel_line1, x_active_cnt[X_ACT_WID-1:$clog2(OUT_PCNT)]}),
    .re(de_2L_r1 && valid_2L_r1), 
    .rdata(w_dout1)
);

simple_dual_port_ram_asym #(
	.WR_DATA_WIDTH(PW * IN_PCNT),
	.WR_ADDR_WIDTH(WR_AW+1),
	.RD_DATA_WIDTH(PW * OUT_PCNT),
	.RD_ADDR_WIDTH(RD_AW+1),
	.OUTPUT_REG("FALSE"),
	.RAM_INIT_FILE("")
) inst_line_buffer_2 (
    .wdata(i_raw),
    .waddr({wr_region_sel, in_xcnt}), 
    .wclk(i_pclk), 
    .we(wr_lb_sel == 1 && i_de && i_valid), 
    
    .rclk(i_pclk),
    .raddr({rd_region_sel_line2, x_active_cnt[X_ACT_WID-1:$clog2(OUT_PCNT)]}),
    .re(de_2L_r1 && valid_2L_r1), 
    .rdata(w_dout2)
);

simple_dual_port_ram_asym #(
	.WR_DATA_WIDTH(PW * IN_PCNT),
	.WR_ADDR_WIDTH(WR_AW+1),
	.RD_DATA_WIDTH(PW * OUT_PCNT),
	.RD_ADDR_WIDTH(RD_AW+1),
	.OUTPUT_REG("FALSE"),
	.RAM_INIT_FILE("")
) inst_line_buffer_3 (
    .wdata(i_raw),
    .waddr({wr_region_sel, in_xcnt}), 
    .wclk(i_pclk), 
    .we(wr_lb_sel == 2 && i_de && i_valid), 
    
    .rclk(i_pclk),
    .raddr({rd_region_sel_line3, x_active_cnt[X_ACT_WID-1:$clog2(OUT_PCNT)]}),
    .re(de_2L_r1 && valid_2L_r1), 
    .rdata(w_dout3)
);


		
/* 1 line delay for RGB sync signals */
fifo #(
	.DATA_WIDTH(4),
    .ADDR_WIDTH($clog2(MAX_HTOTAL * 2))
) fifo_01 (
  .clk 		(i_pclk	),
  .nrst 	(i_rstn	),
  .we 		(r_line_in_1L),
  .re 		(r_line_in_2L),
  .data_in 	({i_de, i_valid, i_hsync, i_vsync}			),
  .data_out ({w_de_2L, w_valid_2L, w_hsync_2L, w_vsync_2L}	)
);

endmodule
