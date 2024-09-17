module rd_address_decoder_512 #(
    parameter  P_CNT = 8'd2,
    localparam X_WID = 12,
    localparam Y_WID = 12
) (
    input p_clk,
    input axi_clk,
    input rstn,

    input [X_WID-1:0] x_win,    //1 cnt = 1 pixel
    input [X_WID-1:0] x_start,  //aligned to 4 bytes
    input [Y_WID-1:0] y_win,
    input [Y_WID-1:0] y_start,

    input    in_de,
    input   in_valid,
    input   in_hsync,
    input   in_vsync,
    input [2:0]  in_frame_cnt,

    input         in_0_ar_ready,
    input         in_0_r_valid,
    input [511:0] in_0_r_payload_data,
    input         in_0_r_payload_last,

    output reg        out_0_ar_valid,
    output     [31:0] out_0_ar_addr,
    output reg        out_0_r_ready,

    output       out_de,
    output       out_valid,
    output       out_hsync,
    output       out_vsync,
    output [7:0] out_rd_00,
    output [7:0] out_rd_01,
    output [7:0] out_rd_10,
    output [7:0] out_rd_11
);

//Main states
typedef enum logic [1:0] {
	IDLE = 2'b00,
	READ_ADDR = 2'b01,
	READ = 2'b10
} state_t;


/* Remap video XY to DDR address */
reg r_hs_1P;
reg [X_WID-1:0] r_rd_addr;
reg [X_WID-1:0] r_rd_addr_1P;
reg [X_WID-1:0] r_rd_addr_2P;
reg [X_WID-1:0] r_rd_addr_3P;
reg [1:0] r_line_cnt;
reg r_line_in_1L;
reg r_line_in_2L;
reg r_de_2L_1P;
reg [Y_WID-1:0] r_y_cnt_2L_1P;
reg r_in_de_0L_1P;
reg r_in_de_0L_2P;
state_t states;
reg [Y_WID-1:0] r_rd_ycnt;
reg [Y_WID-1:0] r_axi_ycnt;
reg [X_WID-6-1:0] r_rd_xcnt;
reg r_axi_new_line;
reg r_rd_load;
reg r_axi_de;
reg r_axi_vsync;
reg r_axi_vsync_1P;
reg [7:0] r_out_rd_00;
reg [7:0] r_out_rd_01;
reg [7:0] r_out_rd_10;
reg [7:0] r_out_rd_11;

wire w_de_2L;
wire w_valid_2L;
wire w_hsync_2L;
wire w_vsync_2L;

wire [511:0] w_rd_data;

genvar idx;

assign out_0_ar_addr = {5'b0, in_frame_cnt, r_rd_ycnt + y_start, r_rd_xcnt, 6'b0};

/* Rd count from DDR data valid */
always @(posedge axi_clk) begin
	if (~rstn) begin
		r_in_de_0L_1P <= '0;
		r_in_de_0L_2P <= '0;
		states <= IDLE;
		r_rd_ycnt <= '0;
		r_axi_ycnt <= '0;
		r_rd_xcnt <= '0;
		out_0_ar_valid <= '0;
		out_0_r_ready <= '0;
		r_axi_new_line <= '0;
		r_rd_load <= '0;
		r_axi_de <= '0;
		r_axi_vsync <= '0;
		r_axi_vsync_1P <= '0;
		//out_0_ar_addr	<= '0;
	end else begin
		r_axi_de <= in_de;
		r_axi_vsync <= in_vsync;
		r_axi_vsync_1P <= r_axi_vsync;

		r_in_de_0L_1P <= r_axi_de;
		r_in_de_0L_2P <= r_in_de_0L_1P;

		if (r_in_de_0L_1P && !r_in_de_0L_2P) begin
			r_axi_new_line <= 1;
			//r_rd_ycnt		<= r_axi_ycnt;
		end

		if (!r_in_de_0L_1P && r_in_de_0L_2P) begin
			//if (r_axi_ycnt == y_start + y_win)
			//	r_axi_ycnt	<= y_start;
			//else
			r_axi_ycnt <= r_axi_ycnt + 1'b1;
		end

		if (!r_axi_vsync_1P) r_rd_ycnt <= '0;
		//r_axi_ycnt	<= y_start;

		////////////////////////////////////////////////////////////				
		case (states)
			IDLE: begin
				if (!r_rd_load) begin
					if (r_axi_new_line) begin
						out_0_ar_valid <= 1;
						r_rd_load <= 1;
						r_axi_new_line <= '0;
						r_rd_xcnt <= '0;
						states <= READ_ADDR;
					end
				end
			end

			READ_ADDR: begin
				if (in_0_ar_ready) begin
					out_0_ar_valid <= '0;
					out_0_r_ready <= 1;
					states <= READ;
				end
			end

			READ: begin
				if (in_0_r_valid) begin
					r_rd_xcnt <= r_rd_xcnt + 1'b1;

					if (in_0_r_payload_last) begin
						if (X_WID'(r_rd_xcnt << 6) >= x_win + x_start)	// 6 because AXI width is 512
					begin
							r_rd_load <= '0;
							r_rd_xcnt <= '0;
							out_0_r_ready <= '0;
							out_0_ar_valid <= '0;
							states <= IDLE;

							if (r_rd_ycnt == y_win - 1'b1) r_rd_ycnt <= '0;
							else r_rd_ycnt <= r_rd_ycnt + 1'b1;
						end else begin
							out_0_r_ready <= '0;
							out_0_ar_valid <= 1;
							states <= READ_ADDR;
						end
					end
				end
			end

			default: begin
				r_rd_load <= '0;
				r_rd_xcnt <= '0;
				out_0_r_ready <= '0;
				out_0_ar_valid <= '0;

				states <= IDLE;
			end
		endcase
	end
end

/* Resync RAM data to RGB video */
always @(posedge p_clk) begin
	if (~rstn) begin
		r_hs_1P <= 1;
		r_rd_addr <= x_start;
		r_rd_addr_1P <= '0;
		r_rd_addr_2P <= '0;
		r_rd_addr_3P <= '0;
		r_de_2L_1P <= '0;
		r_y_cnt_2L_1P <= '0;
		r_line_in_1L <= '0;
		r_line_in_2L <= '0;
		r_line_cnt <= '0;
		r_out_rd_00 <= '0;
		r_out_rd_01 <= '0;
		r_out_rd_10 <= '0;
		r_out_rd_11 <= '0;
	end else begin
		r_hs_1P <= in_hsync;
		r_rd_addr_1P <= r_rd_addr;
		r_rd_addr_2P <= r_rd_addr_1P;
		r_rd_addr_3P <= r_rd_addr_2P;
		r_de_2L_1P <= w_de_2L;

		if (!w_de_2L && r_de_2L_1P) begin
			//if (r_y_cnt_2L_1P == y_start + y_win)
			//	r_y_cnt_2L_1P	<= y_start;
			//else
			r_y_cnt_2L_1P <= r_y_cnt_2L_1P + 1'b1;
		end

		if (!w_vsync_2L) r_y_cnt_2L_1P <= '0;

		if (w_de_2L) begin
			if (w_valid_2L)
				r_rd_addr <= r_rd_addr + 3'd4;  //+4 becuase 1 valid = 4 pixel (i.e. p_cnt=4)
		end else r_rd_addr <= x_start;

		if (in_hsync && ~r_hs_1P) r_line_cnt <= r_line_cnt + 1'b1;

		if (r_line_cnt[0]) r_line_in_1L <= 1;

		if (r_line_cnt[1]) r_line_in_2L <= 1;

		r_out_rd_00 <= w_rd_data[r_rd_addr_3P[5:2]*32+0+:8];
		r_out_rd_01 <= w_rd_data[r_rd_addr_3P[5:2]*32+8+:8];
		r_out_rd_10 <= w_rd_data[r_rd_addr_3P[5:2]*32+16+:8];
		r_out_rd_11 <= w_rd_data[r_rd_addr_3P[5:2]*32+24+:8];
	end
end

assign out_rd_00 = r_out_rd_00;
assign out_rd_01 = r_out_rd_01;
assign out_rd_10 = r_out_rd_10;
assign out_rd_11 = r_out_rd_11;

/* Resync RED data from axi_clk to p_clk */
simple_dual_port_ram #(
	.DATA_WIDTH(512),
	.ADDR_WIDTH(8),
	.OUTPUT_REG("TRUE")
) inst_simple_dual_port_ram_00 (
	.wclk (axi_clk),
	.we   (in_0_r_valid),
	.waddr({r_rd_ycnt[1:0], r_rd_xcnt[X_WID-6-1:0]}),
	.wdata(in_0_r_payload_data),

	.rclk (p_clk),
	.re   (r_de_2L_1P),
	.raddr({r_y_cnt_2L_1P[1:0], r_rd_addr_1P[X_WID-1:6]}),
	.rdata(w_rd_data)
);

/* FIFO delay for RGB sync signals */
shift_reg #(
	.D_WIDTH(4),
	.TAPE(4)
) inst_shift_reg_02 (
	.i_arst(~rstn),
	.i_clk (p_clk),
	.i_en  (1'b1),

	.i_d({w_de_2L, w_valid_2L, w_hsync_2L, w_vsync_2L}),
	.o_q({out_de, out_valid, out_hsync, out_vsync})
);

/* 1 line delay for RGB sync signals */
fifo #(
	.DATA_WIDTH(4),
	.ADDR_WIDTH(14)
) fifo_01 (
	.clk   (p_clk ),
	.nrst  (rstn ),
	.we   (r_line_in_1L),
	.re   (r_line_in_2L),
	.data_in  ({in_de, in_valid, in_hsync, in_vsync}   ),
	.data_out ({w_de_2L, w_valid_2L, w_hsync_2L, w_vsync_2L} )
);

endmodule
