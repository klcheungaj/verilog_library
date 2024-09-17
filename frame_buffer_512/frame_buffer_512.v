`timescale 1ps / 1ps
module frame_buffer_512 #(
) (
    input wr_rstn_0,
    input wr_rstn_1,
    input rd_rstn_0,
    input rd_rstn_1,
    input axi_rstn,
    input wr_p_clk_0,
    input wr_p_clk_1,
    input rd_p_clk_0,
    input rd_p_clk_1,
    input axi_clk,

    input [12:0] x_win_wr_0,
    input [12:0] x_win_wr_1,
    input [12:0] x_win_rd_0,
    input [12:0] x_win_rd_1,
    input [12:0] x_start_wr_0,
    input [12:0] x_start_wr_1,
    input [12:0] x_start_rd_0,
    input [12:0] x_start_rd_1,
    input [12:0] y_win_wr_0,
    input [12:0] y_win_wr_1,
    input [12:0] y_win_rd_0,
    input [12:0] y_win_rd_1,
    input [12:0] y_start_wr_0,
    input [12:0] y_start_wr_1,
    input [12:0] y_start_rd_0,
    input [12:0] y_start_rd_1,

    output [ 5:0] arid,
    output [32:0] araddr,
    output [ 7:0] arlen,
    output [ 2:0] arsize,
    output [ 1:0] arburst,
    output        arlock,
    output        arvalid,
    input         arready,

    output [ 5:0] awid,
    output [32:0] awaddr,
    output [ 7:0] awlen,
    output [ 2:0] awsize,
    output [ 1:0] awburst,
    output        awlock,
    output        awvalid,
    input         awready,

    output [511:0] wdata,
    output [ 63:0] wstrb,
    output         wlast,
    output         wvalid,
    input          wready,

    input  [  5:0] rid,
    input  [511:0] rdata,
    input          rlast,
    input          rvalid,
    output         rready,

    input  [5:0] bid,
    input        bvalid,
    output       bready,

    input [12:0]   in_0_x_wr,
    input [12:0]   in_0_y_wr,
    input    in_0_wr_en,
    input    in_0_hs,
    input    in_0_vs,
    input [7:0]   in_0_wr_00,
    input [7:0]   in_0_wr_01,
    input [7:0]   in_0_wr_10,
    input [7:0]   in_0_wr_11,

    input [12:0]   in_1_x_wr,
    input [12:0]   in_1_y_wr,
    input    in_1_wr_en,
    input    in_1_hs,
    input    in_1_vs,
    input [7:0]   in_1_wr_00,
    input [7:0]   in_1_wr_01,
    input [7:0]   in_1_wr_10,
    input [7:0]   in_1_wr_11,

    input in_0_de,
    input in_0_valid,
    input in_0_hsync,
    input in_0_vsync,

    input in_1_de,
    input in_1_valid,
    input in_1_hsync,
    input in_1_vsync,

    output       out_0_de,
    output       out_0_valid,
    output       out_0_hsync,
    output       out_0_vsync,
    output [7:0] out_0_rd_00,
    output [7:0] out_0_rd_01,
    output [7:0] out_0_rd_10,
    output [7:0] out_0_rd_11,

    output       out_1_de,
    output       out_1_valid,
    output       out_1_hsync,
    output       out_1_vsync,
    output [7:0] out_1_rd_00,
    output [7:0] out_1_rd_01,
    output [7:0] out_1_rd_10,
    output [7:0] out_1_rd_11
);

wire         out_0_aw_valid;
wire         out_1_aw_valid;
wire         out_0_ar_valid;
wire         out_1_ar_valid;
wire         w_0_aw_valid;
wire         w_0_aw_ready;
wire [ 31:0] w_0_aw_payload_addr;
wire         w_0_w_valid;
wire         w_0_w_ready;
wire [511:0] w_0_w_payload_data;
wire         w_0_w_payload_last;
wire         w_0_b_valid;
wire         w_0_b_ready;
wire [  3:0] w_0_b_payload_id;
wire [  1:0] w_0_b_payload_resp;
wire         w_1_aw_valid;
wire         w_1_aw_ready;
wire [ 31:0] w_1_aw_payload_addr;
wire         w_1_w_valid;
wire         w_1_w_ready;
wire [511:0] w_1_w_payload_data;
wire         w_1_w_payload_last;
wire         w_1_b_valid;
wire         w_1_b_ready;
wire [  3:0] w_1_b_payload_id;
wire [  1:0] w_1_b_payload_resp;
wire         w_0_ar_valid;
wire         w_0_ar_ready;
wire [ 31:0] w_0_ar_payload_addr;
wire         w_0_r_valid;
wire         w_0_r_ready;
wire [511:0] w_0_r_payload_data;
wire [  3:0] w_0_r_payload_id;
wire [  1:0] w_0_r_payload_resp;
wire         w_0_r_payload_last;
wire         w_1_ar_valid;
wire         w_1_ar_ready;
wire [ 31:0] w_1_ar_payload_addr;
wire         w_1_r_valid;
wire         w_1_r_ready;
wire [511:0] w_1_r_payload_data;
wire [  3:0] w_1_r_payload_id;
wire [  1:0] w_1_r_payload_resp;
wire         w_1_r_payload_last;
wire [  7:0] w_arid;
wire [  7:0] w_awid;
wire [  5:0] w_rid;
wire [  5:0] w_bid;

reg  [ 12:0] r_x_win_wr_0;
reg  [ 12:0] r_x_win_wr_1;
reg  [ 12:0] r_x_win_rd_0;
reg  [ 12:0] r_x_win_rd_1;
reg  [ 12:0] r_x_start_wr_0;
reg  [ 12:0] r_x_start_wr_1;
reg  [ 12:0] r_x_start_rd_0;
reg  [ 12:0] r_x_start_rd_1;
reg  [ 12:0] r_y_win_wr_0;
reg  [ 12:0] r_y_win_wr_1;
reg  [ 12:0] r_y_win_rd_0;
reg  [ 12:0] r_y_win_rd_1;
reg  [ 12:0] r_y_start_wr_0;
reg  [ 12:0] r_y_start_wr_1;
reg  [ 12:0] r_y_start_rd_0;
reg  [ 12:0] r_y_start_rd_1;

wire [  1:0] w_wr_vs_cnt_0;
wire [  1:0] w_rd_vs_cnt_0;
wire [  1:0] w_wr_vs_cnt_1;
wire [  1:0] w_rd_vs_cnt_1;
wire         valid_wr_frame_0;
wire         valid_wr_frame_1;

/* 
RAM read address decoder and repack data
32bit address and data
*/
always @(negedge rd_rstn_0 or posedge rd_p_clk_0) begin
	if (~rd_rstn_0 || ~in_0_vsync) begin
		r_x_win_rd_0   <= x_win_rd_0;
		r_x_start_rd_0 <= x_start_rd_0;
		r_y_win_rd_0   <= y_win_rd_0;
		r_y_start_rd_0 <= y_start_rd_0;
	end
end

frame_buffer_sel u0_frame_buffer_sel (
	.rd_clk (rd_p_clk_0),
	.wr_clk (wr_p_clk_0),
	.rd_rstn(rd_rstn_0),
	.wr_rstn(wr_rstn_0),

	.wr_vsync(in_0_vs),
	.rd_vsync(in_0_vsync),

	.wr_frame_idx  (w_wr_vs_cnt_0),
	.valid_wr_frame(valid_wr_frame_0),
	.rd_frame_idx  (w_rd_vs_cnt_0)
);

frame_buffer_sel u1_frame_buffer_sel (
	.rd_clk (rd_p_clk_1),
	.wr_clk (wr_p_clk_1),
	.rd_rstn(rd_rstn_1),
	.wr_rstn(wr_rstn_1),

	.wr_vsync(),
	.rd_vsync(in_1_vsync),

	.wr_frame_idx  (w_wr_vs_cnt_1),
	.valid_wr_frame(valid_wr_frame_1),
	.rd_frame_idx  (w_rd_vs_cnt_1)
);

rd_address_decoder_512 #() inst_rd_address_decoder_0 (
	.rstn   (rd_rstn_0),
	.p_clk  (rd_p_clk_0),
	.axi_clk(axi_clk),

	.x_win  (r_x_win_rd_0),
	.x_start(r_x_start_rd_0),
	.y_win  (r_y_win_rd_0),
	.y_start(r_y_start_rd_0),

	.in_de       (in_0_de),
	.in_valid    (in_0_valid),
	.in_hsync    (in_0_hsync),
	.in_vsync    (in_0_vsync),
	.in_frame_cnt({1'b0, w_rd_vs_cnt_0}),

	.in_0_ar_ready(w_0_ar_ready),
	.in_0_r_valid(w_0_r_valid),
	.in_0_r_payload_data(w_0_r_payload_data),
	.in_0_r_payload_last(w_0_r_payload_last),

	.out_0_ar_valid(out_0_ar_valid),
	.out_0_ar_addr (w_0_ar_payload_addr),
	.out_0_r_ready (w_0_r_ready),

	.out_de   (out_0_de),
	.out_valid(out_0_valid),
	.out_hsync(out_0_hsync),
	.out_vsync(out_0_vsync),
	.out_rd_00(out_0_rd_00),
	.out_rd_01(out_0_rd_01),
	.out_rd_10(out_0_rd_10),
	.out_rd_11(out_0_rd_11)
);

always @(negedge rd_rstn_1 or posedge rd_p_clk_1) begin
	if (~rd_rstn_1 || ~in_1_vsync) begin
		r_x_win_rd_1   <= x_win_rd_1;
		r_x_start_rd_1 <= x_start_rd_1;
		r_y_win_rd_1   <= y_win_rd_1;
		r_y_start_rd_1 <= y_start_rd_1;
	end
end

rd_address_decoder_512 #() inst_rd_address_decoder_1 (
	.rstn   (rd_rstn_1),
	.p_clk  (rd_p_clk_1),
	.axi_clk(axi_clk),

	.x_win  (r_x_win_rd_1),
	.x_start(r_x_start_rd_1),
	.y_win  (r_y_win_rd_1),
	.y_start(r_y_start_rd_1),

	.in_de       (in_1_de),
	.in_valid    (in_1_valid),
	.in_hsync    (in_1_hsync),
	.in_vsync    (in_1_vsync),
	.in_frame_cnt({1'b1, w_rd_vs_cnt_1}),

	.in_0_ar_ready(w_1_ar_ready),
	.in_0_r_valid(w_1_r_valid),
	.in_0_r_payload_data(w_1_r_payload_data),
	.in_0_r_payload_last(w_1_r_payload_last),

	.out_0_ar_valid(out_1_ar_valid),
	.out_0_ar_addr (w_1_ar_payload_addr),
	.out_0_r_ready (w_1_r_ready),

	.out_de   (out_1_de),
	.out_valid(out_1_valid),
	.out_hsync(out_1_hsync),
	.out_vsync(out_1_vsync),
	.out_rd_00(out_1_rd_00),
	.out_rd_01(out_1_rd_01),
	.out_rd_10(out_1_rd_10),
	.out_rd_11(out_1_rd_11)
);

/* 
RAM write address decoder and repack data
32bit address and data
*/
/* Even frame */
always @(negedge wr_rstn_0 or posedge wr_p_clk_0) begin
	if (~wr_rstn_0 || (r_x_win_wr_0 == x_win_wr_0 && r_y_win_wr_0 == y_win_wr_0)) begin
		r_x_win_wr_0   <= x_win_wr_0;
		r_x_start_wr_0 <= x_start_wr_0;
		r_y_win_wr_0   <= y_win_wr_0;
		r_y_start_wr_0 <= y_start_wr_0;
	end
end

wr_address_decoder_512 #() inst_wr_address_decoder_0 (
	.rstn   (wr_rstn_0 ),
	.p_clk   (wr_p_clk_0 ),
	.axi_clk  (axi_clk ),

	.x_win  (x_win_wr_0),
	.x_start(x_start_wr_0),
	.y_win  (y_win_wr_0),
	.y_start(y_start_wr_0),

	.in_x_wr  (valid_wr_frame_0 ? in_0_x_wr : 0 ),
	.in_y_wr  (valid_wr_frame_0 ? in_0_y_wr : 0 ),
	.in_wr_en  (in_0_wr_en && valid_wr_frame_0),
	.in_hs   (in_0_hs && valid_wr_frame_0 ),
	.in_frame_cnt ({1'b0, w_wr_vs_cnt_0}),

	.in_wr_00(in_0_wr_00),
	.in_wr_01(in_0_wr_01),
	.in_wr_10(in_0_wr_10),
	.in_wr_11(in_0_wr_11),

	.in_wr_aready(w_0_aw_ready),
	.in_wr_ready (w_0_w_ready),
	.in_wr_bvalid(w_0_b_valid),

	.out_wr_avalid(out_0_aw_valid),
	.out_wr_valid (w_0_w_valid),
	.out_wr_bready(w_0_b_ready),
	.out_wr_last  (w_0_w_payload_last),
	.out_wr_addr  (w_0_aw_payload_addr),
	.out_wr_data  (w_0_w_payload_data)
);

always @(negedge wr_rstn_1 or posedge wr_p_clk_1) begin
	if (~wr_rstn_1 || (r_x_win_wr_1 == x_win_wr_1 && r_y_win_wr_1 == y_win_wr_1)) begin
		r_x_win_wr_1   <= x_win_wr_1;
		r_x_start_wr_1 <= x_start_wr_1;
		r_y_win_wr_1   <= y_win_wr_1;
		r_y_start_wr_1 <= y_start_wr_1;
	end
end

wr_address_decoder_512 #() inst_wr_address_decoder_1 (
	.rstn   (wr_rstn_1 ),
	.p_clk   (wr_p_clk_1 ),
	.axi_clk  (axi_clk ),

	.x_win  (x_win_wr_1),
	.x_start(x_start_wr_1),
	.y_win  (y_win_wr_1),
	.y_start(y_start_wr_1),

	.in_x_wr  (valid_wr_frame_1 ? in_1_x_wr : 0 ),
	.in_y_wr  (valid_wr_frame_1 ? in_1_y_wr : 0 ),
	.in_wr_en  (in_1_wr_en && valid_wr_frame_1),
	.in_hs   (in_1_hs && valid_wr_frame_1 ),
	.in_frame_cnt ({1'b1, w_wr_vs_cnt_1}),

	.in_wr_00(in_1_wr_00),
	.in_wr_01(in_1_wr_01),
	.in_wr_10(in_1_wr_10),
	.in_wr_11(in_1_wr_11),

	.in_wr_aready(w_1_aw_ready),
	.in_wr_ready (w_1_w_ready),
	.in_wr_bvalid(w_1_b_valid),

	.out_wr_avalid(out_1_aw_valid),
	.out_wr_valid (w_1_w_valid),
	.out_wr_bready(w_1_b_ready),
	.out_wr_last  (w_1_w_payload_last),
	.out_wr_addr  (w_1_aw_payload_addr),
	.out_wr_data  (w_1_w_payload_data)
);

/* Axicrossbar 2x512 in, 1x512 out */
/* Chip Select [32], Row [31:15], Bank [14:12], Column [11:2], Datapath [1:0] */
Axi4_2x512_1x512 #() inst_Axi4_2x512_1x512_00 (
	.io_axis_0_aw_valid        (w_0_aw_valid),
	.io_axis_0_aw_ready        (w_0_aw_ready),
	.io_axis_0_aw_payload_addr (w_0_aw_payload_addr),
	.io_axis_0_aw_payload_id   (4'b0),
	.io_axis_0_aw_payload_len  (8'd31),
	.io_axis_0_aw_payload_size (3'b110),
	.io_axis_0_aw_payload_burst(2'b01),
	.io_axis_0_aw_payload_lock (1'b0),
	.io_axis_0_aw_payload_cache(4'b0),
	.io_axis_0_aw_payload_qos  (4'b0),
	.io_axis_0_w_valid         (w_0_w_valid),
	.io_axis_0_w_ready         (w_0_w_ready),
	.io_axis_0_w_payload_data  (w_0_w_payload_data),
	.io_axis_0_w_payload_strb  (64'hFFFFFFFFFFFFFFFF),
	.io_axis_0_w_payload_last  (w_0_w_payload_last),
	.io_axis_0_b_valid         (w_0_b_valid),
	.io_axis_0_b_ready         (w_0_b_ready),
	.io_axis_0_b_payload_id    (w_0_b_payload_id),
	.io_axis_0_b_payload_resp  (w_0_b_payload_resp),
	//
	.io_axis_0_ar_valid        (w_0_ar_valid),
	.io_axis_0_ar_ready        (w_0_ar_ready),
	.io_axis_0_ar_payload_addr (w_0_ar_payload_addr),
	.io_axis_0_ar_payload_id   (4'b0),
	.io_axis_0_ar_payload_len  (8'd31),
	.io_axis_0_ar_payload_size (3'b110),
	.io_axis_0_ar_payload_burst(2'b01),
	.io_axis_0_ar_payload_lock (1'b0),
	.io_axis_0_ar_payload_cache(4'b0),
	.io_axis_0_ar_payload_qos  (4'b0),
	.io_axis_0_r_valid         (w_0_r_valid),
	.io_axis_0_r_ready         (w_0_r_ready),
	.io_axis_0_r_payload_data  (w_0_r_payload_data),
	.io_axis_0_r_payload_id    (w_0_r_payload_id),
	.io_axis_0_r_payload_resp  (w_0_r_payload_resp),
	.io_axis_0_r_payload_last  (w_0_r_payload_last),
	//
	.io_axis_1_aw_valid        (w_1_aw_valid),
	.io_axis_1_aw_ready        (w_1_aw_ready),
	.io_axis_1_aw_payload_addr (w_1_aw_payload_addr),
	.io_axis_1_aw_payload_id   (4'b1000),
	.io_axis_1_aw_payload_len  (8'd31),
	.io_axis_1_aw_payload_size (3'b110),
	.io_axis_1_aw_payload_burst(2'b01),
	.io_axis_1_aw_payload_lock (1'b0),
	.io_axis_1_aw_payload_cache(4'b0),
	.io_axis_1_aw_payload_qos  (4'b0),
	.io_axis_1_w_valid         (w_1_w_valid),
	.io_axis_1_w_ready         (w_1_w_ready),
	.io_axis_1_w_payload_data  (w_1_w_payload_data),
	.io_axis_1_w_payload_strb  (64'hFFFFFFFFFFFFFFFF),
	.io_axis_1_w_payload_last  (w_1_w_payload_last),
	.io_axis_1_b_valid         (w_1_b_valid),
	.io_axis_1_b_ready         (w_1_b_ready),
	.io_axis_1_b_payload_id    (w_1_b_payload_id),
	.io_axis_1_b_payload_resp  (w_1_b_payload_resp),
	//
	.io_axis_1_ar_valid        (w_1_ar_valid),
	.io_axis_1_ar_ready        (w_1_ar_ready),
	.io_axis_1_ar_payload_addr (w_1_ar_payload_addr),
	.io_axis_1_ar_payload_id   (4'b1000),
	.io_axis_1_ar_payload_len  (8'd31),
	.io_axis_1_ar_payload_size (3'b110),
	.io_axis_1_ar_payload_burst(2'b01),
	.io_axis_1_ar_payload_lock (1'b0),
	.io_axis_1_ar_payload_cache(4'b0),
	.io_axis_1_ar_payload_qos  (4'b0),
	.io_axis_1_r_valid         (w_1_r_valid),
	.io_axis_1_r_ready         (w_1_r_ready),
	.io_axis_1_r_payload_data  (w_1_r_payload_data),
	.io_axis_1_r_payload_id    (w_1_r_payload_id),
	.io_axis_1_r_payload_resp  (w_1_r_payload_resp),
	.io_axis_1_r_payload_last  (w_1_r_payload_last),
	//
	.io_axim_aw_valid          (awvalid),
	.io_axim_aw_ready          (awready),
	.io_axim_aw_payload_addr   (awaddr[31:0]),
	.io_axim_aw_payload_id     (w_awid),
	.io_axim_aw_payload_len    (awlen),
	.io_axim_aw_payload_size   (awsize),
	.io_axim_aw_payload_burst  (awburst),
	.io_axim_aw_payload_lock   (awlock),
	.io_axim_aw_payload_cache  (),
	.io_axim_aw_payload_qos    (),
	//
	.io_axim_ar_valid          (arvalid),
	.io_axim_ar_ready          (arready),
	.io_axim_ar_payload_addr   (araddr[31:0]),
	.io_axim_ar_payload_id     (w_arid),
	.io_axim_ar_payload_len    (arlen),
	.io_axim_ar_payload_size   (arsize),
	.io_axim_ar_payload_burst  (arburst),
	.io_axim_ar_payload_lock   (arlock),
	.io_axim_ar_payload_cache  (),
	.io_axim_ar_payload_qos    (),
	//
	.io_axim_w_valid           (wvalid),
	.io_axim_w_ready           (wready),
	.io_axim_w_payload_data    (wdata),
	.io_axim_w_payload_strb    (wstrb),
	.io_axim_w_payload_last    (wlast),
	.io_axim_b_valid           (bvalid),
	.io_axim_b_ready           (bready),
	.io_axim_b_payload_id      ({2'b0, w_bid}),
	.io_axim_b_payload_resp    (2'b0),
	//
	.io_axim_r_valid           (rvalid),
	.io_axim_r_ready           (rready),
	.io_axim_r_payload_data    (rdata),
	.io_axim_r_payload_id      ({2'b0, w_rid}),
	.io_axim_r_payload_resp    (2'b0),
	.io_axim_r_payload_last    (rlast),
	//
	.clk                       (axi_clk),
	.reset                     (~axi_rstn)
);

assign w_0_aw_valid = out_0_aw_valid;
assign w_1_aw_valid = out_1_aw_valid;
assign w_0_ar_valid = out_0_ar_valid;
assign w_1_ar_valid = out_1_ar_valid;

assign arid = w_arid[5:0];
assign awid = w_awid[5:0];
assign w_rid[5:0] = rid;
assign w_bid[5:0] = bid;
assign awaddr[32] = 1'b0;
assign araddr[32] = 1'b0;

endmodule
