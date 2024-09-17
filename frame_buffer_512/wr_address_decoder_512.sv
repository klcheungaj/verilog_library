module wr_address_decoder_512
#(	
	localparam X_WID = 12,
	localparam Y_WID = 12
)
(
input 			p_clk,
input 			axi_clk,
input 			rstn,

input [X_WID-1:0]		x_win,
input [X_WID-1:0]		x_start,	//1 pixel = 1 cnt. Step is 4 bytes = 4 pixels when using RAW8 type
input [Y_WID-1:0]		y_win,
input [Y_WID-1:0]		y_start,
	
input [X_WID-1:0] 		in_x_wr,	//1 pixel = 1 cnt. if 1 pixel = 1byte, increased by 4 in each cycle since width of data is 4bytes
input [Y_WID-1:0] 		in_y_wr,
input				in_wr_en,
input				in_hs,
input [2:0]			in_frame_cnt,
	
input [7:0]			in_wr_00,
input [7:0]			in_wr_01,
input [7:0]			in_wr_10,
input [7:0]			in_wr_11,
	
input				in_wr_aready,
input				in_wr_ready,
input				in_wr_bvalid,

output	reg			out_wr_avalid,
output	reg			out_wr_valid,
output	reg			out_wr_bready,
output	reg			out_wr_last,
output	reg			[31:0]		out_wr_addr,
output	[511:0]		out_wr_data
);

//Main states
typedef enum logic [2:0] {
	IDLE 		= 3'b000, 
	WRITE_ADDR 	= 3'b001,
	PRE_WRITE 	= 3'b010,
	WRITE 		= 3'b011,
	POST_WRITE 	= 3'b100
} state_t;

/* Remap video XY to DDR address */
state_t		states;
reg	[4:0]	r_x_rd;
reg			r_pclk_new_line;
reg	[X_WID-12+1:0] write_cycle;	// for 1 more bit to store an extra cycle
reg	[Y_WID-1:0]	r_wr_y;
reg	[Y_WID-1:0]	r_wr_y_temp;
reg	[Y_WID-1:0]	r_y_wr_1P;
reg			r_wr_load;
reg			r_wr_load_1P;
reg	[4:0]	r_burst_cnt;
reg			r_rd_en;
reg	[Y_WID-1:0]	r_axi_wr_y_temp;
reg			r_axi_new_line;
reg			r_axi_start;
reg	[Y_WID-1:0]	r_y_cnt;

wire[511:0]	w_wr_data_axi;

reg [X_WID-1:0]  in_x_wr_nom;
reg [Y_WID-1:0]  in_y_wr_nom;

always @(*) 
begin
	in_x_wr_nom = in_x_wr - x_start;
	in_y_wr_nom = in_y_wr - y_start;
end

/* New line for write */
always @(posedge p_clk)
begin
    if (~rstn) 
	begin
		r_wr_y_temp		<= '0;
		r_pclk_new_line	<= '0;
		r_wr_load_1P	<= '0;
		r_y_wr_1P		<= '0;
	end
	else
	begin
		r_y_wr_1P	<= in_y_wr_nom;
		r_wr_load_1P<= r_axi_start;
		
		if (in_x_wr_nom == x_win - 'd4)
		begin
			r_pclk_new_line	<= 1;
			r_wr_y_temp		<= r_y_wr_1P;
		end
		
		if (r_wr_load_1P == 1)
		begin
			r_pclk_new_line	<= '0;
			// r_wr_y_temp		<= '0;
		end
	end
end
		
/* Axi4 write 32bit */
always @(posedge axi_clk)
begin
    if (~rstn) 
	begin
		states			<= IDLE;
		out_wr_valid	<= '0;
		out_wr_bready	<= '0;
		out_wr_last		<= '0;
		out_wr_avalid	<= '0;
		r_x_rd			<= '0;
		write_cycle		<= '0;
		r_wr_y			<= '0;
		r_wr_load		<= '0;
		r_burst_cnt		<= '0;
		r_rd_en			<= '0;
		r_axi_wr_y_temp	<= '0;
		r_axi_new_line	<= '0;
		r_axi_start		<= '0;
		out_wr_addr		<= '0;
		r_y_cnt			<= '0;
	end
	else
	begin
		out_wr_addr	<= {5'b0, in_frame_cnt, r_wr_y, write_cycle[0 +: X_WID-11], 11'b0};
		
		if (r_axi_new_line && ~r_wr_load)
		begin
			r_axi_wr_y_temp	<= r_wr_y_temp;
			r_axi_start		<= 1;
		end
		
		if (r_wr_load)
			r_axi_start		<= '0;
						
		r_axi_new_line	<= r_pclk_new_line;
				
		if (in_x_wr == '0 && in_y_wr_nom == '0 && in_wr_en)
			r_y_cnt	<= '0;
			
		if (in_wr_aready)
			out_wr_avalid	<= '0;
			
		case (states)
			IDLE:
			begin
				r_rd_en <= '0;
				if (~r_wr_load && r_axi_start)
				begin
					write_cycle	<= '0;
					r_wr_y		<= r_axi_wr_y_temp;
					out_wr_avalid	<= 1;
					r_wr_load		<= 1;
					states			<= WRITE_ADDR;
					r_rd_en			<= 1;
					r_x_rd			<= '0;
				end
			end
			
			WRITE_ADDR:
			begin
				out_wr_valid	<= 1;
				out_wr_bready	<= 1;
				states			<= WRITE;
			end
			
			WRITE:
			begin
				if (in_wr_ready)				
				begin
					r_burst_cnt	<= r_burst_cnt + 1'b1;
					r_x_rd		<= r_x_rd + 1'b1;
					
					if (out_wr_last)
					begin
						out_wr_last		<= '0;
						out_wr_valid	<= '0;
						r_burst_cnt		<= '0;
						states			<= POST_WRITE;						
					end
					else if (r_burst_cnt == 5'd30)
					begin
						out_wr_last	<= 1;
						write_cycle	<= write_cycle + 1'b1;
					end
				end
			end
			
			POST_WRITE:
			begin
				if (in_wr_bvalid)
					out_wr_bready <= '0;
					
				if (!out_wr_bready && !out_wr_avalid)
				begin
					out_wr_last		<= '0;
					out_wr_valid	<= '0;
					r_burst_cnt		<= '0;
					
					if (write_cycle > x_win[X_WID-1:11])
					begin					
						states			<= IDLE;					
						write_cycle 	<= '0;		
						out_wr_bready	<= '0;
						out_wr_avalid	<= '0;
						r_wr_load		<= '0;	
						r_wr_y			<= '0;
						r_rd_en			<= '0;
						
						if (r_y_cnt == y_win - 1)
							r_y_cnt	<= '0;
						else
							r_y_cnt	<= r_y_cnt + 1'b1;
					end			
					else
					begin			
						out_wr_bready	<= '0;		
						out_wr_avalid	<= 1;
						states			<= WRITE_ADDR;
					end
				end
			end
			
			default:
			begin
				write_cycle 	<= '0;
				out_wr_valid	<= '0;					
				out_wr_bready	<= '0;
				out_wr_avalid	<= '0;
				r_wr_load		<= '0;
				out_wr_last		<= '0;
				r_rd_en			<= '0;
				r_burst_cnt		<= '0;
				r_wr_y			<= '0;
				states			<= IDLE;
			end
		endcase
	end
end

genvar idx;
generate 
/* Resync from p_clk to axi_clk */
	for(idx=0 ; idx<16 ; idx=idx+1) begin
		simple_dual_port_ram
		#(
			.DATA_WIDTH(32),
			.ADDR_WIDTH(7),
			.OUTPUT_REG("FALSE")
		)
		inst_pclk_to_axi_buffer
		(
			.wclk	(p_clk),
			.we		(in_wr_en && (in_x_wr_nom[5:2] == idx)),
			.waddr	({in_y_wr_nom[0], in_x_wr_nom[X_WID-1:6]}),
			.wdata	({in_wr_11, in_wr_10, in_wr_01, in_wr_00}),
				
			.rclk	(axi_clk),
			.re		(r_rd_en),
			.raddr	({r_y_cnt[0], write_cycle[0 +: X_WID-11], r_x_rd} + (out_wr_valid & in_wr_ready)),
			.rdata	(w_wr_data_axi[idx*32 +: 32])
		);
	end
endgenerate 

assign	out_wr_data = w_wr_data_axi;

endmodule
