module datapack_gen
#(
	parameter PIXEL_BIT		= 24,
    parameter PACK_BIT      = 48,
	parameter FIFO_WIDTH	= 11,
	parameter H_ActivePix	= 1920,
	parameter V_ActivePix	= 1080
)
(
	input	in_pclk,
	input	in_rstn,
	
	input 	[FIFO_WIDTH-1:0]	in_x,	//1 pixel 1 count. each step is PACK_NUM
	input 	[FIFO_WIDTH-1:0]	in_y,
	input 						in_valid,
	input 						in_de,
	input 						in_hs,
	input 						in_vs,
	input	[2:0]				in_pattern,
	
	output 	[FIFO_WIDTH-1:0]	out_x,
	output 	[FIFO_WIDTH-1:0]	out_y,
	output 						out_valid,
	output 						out_de,
	output 						out_hs,
	output 						out_vs,
	output	[          63:0]	out_data
);

localparam PACK_NUM = PACK_BIT / PIXEL_BIT;

/* VGA counter for the output display sync signals generator */
reg [FIFO_WIDTH-1:0]	r_out_x_1P;
reg [FIFO_WIDTH-1:0]	r_out_y_1P;
// reg [		   63:0]	r_out_data_1P;
reg [PACK_NUM-1:0] [PIXEL_BIT-1:0] 	r_out_pixel_1P;
reg						r_out_vs_1P;
reg						r_out_hs_1P;
reg						r_out_de_1P;
reg						r_out_valid_1P;
reg [6:0]				r_frame_cnt;

wire [PIXEL_BIT-1:0] 	w_random_data [PACK_NUM];

genvar idx;

generate
	for (idx=0 ; idx<PACK_NUM ; idx++) begin
		/* VGA counter for the output display sync signals generator */
		/* r_x_cnt for HSYNC and DEN */  
		always @ (posedge in_pclk) begin
			if(~in_rstn) begin
				r_out_x_1P		<= {FIFO_WIDTH{1'b0}};
				r_out_y_1P		<= {FIFO_WIDTH{1'b0}};
				r_out_pixel_1P[idx]	<= '0;
				r_frame_cnt		<= 7'b0;
				r_out_vs_1P		<= 1'b0;
				r_out_hs_1P		<= 1'b0;
				r_out_de_1P		<= 1'b0;
				r_out_valid_1P	<= 1'b0;
			end	else begin		
				r_out_vs_1P		<= in_vs;
				r_out_hs_1P		<= in_hs;
				r_out_de_1P		<= in_de;
				r_out_valid_1P	<= in_valid;
				r_out_x_1P		<= in_x;
				r_out_y_1P		<= in_y;
				
				if (in_pattern == 3'd0) begin
					if (~in_vs && r_out_vs_1P)
						r_frame_cnt	<= r_frame_cnt + 1'b1;
						
					if (r_frame_cnt[6:4] == 8'd0)
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b0}};
					else if (r_frame_cnt[6:4] == 8'd1)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 1;
					else if (r_frame_cnt[6:4] == 8'd2)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 2;
					else if (r_frame_cnt[6:4] == 8'd3)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 3;
					else if (r_frame_cnt[6:4] == 8'd4)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 4;
					else if (r_frame_cnt[6:4] == 8'd5)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 5;
					else if (r_frame_cnt[6:4] == 8'd6)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 6;
					else if (r_frame_cnt[6:4] == 8'd7)
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b1}};
				end
				else if (in_pattern == 3'd1) begin
					if (in_y < (V_ActivePix / 8))
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b0}};
					else if (in_y < (V_ActivePix / 8) * 2)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 1;
					else if (in_y < (V_ActivePix / 8) * 3)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 2;
					else if (in_y < (V_ActivePix / 8) * 4)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 3;
					else if (in_y < (V_ActivePix / 8) * 5)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 4;
					else if (in_y < (V_ActivePix / 8) * 6)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 5;
					else if (in_y < (V_ActivePix / 8) * 7)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 6;
					else if (in_y < V_ActivePix)
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b1}};
				end
				else if (in_pattern == 3'd2) begin
					if (in_x + idx < (H_ActivePix / 8))
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b0}};
					else if (in_x + idx < (H_ActivePix / 8) * 2)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 1;
					else if (in_x + idx < (H_ActivePix / 8) * 3)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 2;
					else if (in_x + idx < (H_ActivePix / 8) * 4)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 3;
					else if (in_x + idx < (H_ActivePix / 8) * 5)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 4;
					else if (in_x + idx < (H_ActivePix / 8) * 6)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 5;
					else if (in_x + idx < (H_ActivePix / 8) * 7)
						r_out_pixel_1P[idx]	<= ({PIXEL_BIT{1'b1}} / 7) * 6;
					else if (in_x + idx < H_ActivePix)
						r_out_pixel_1P[idx]	<= {PIXEL_BIT{1'b1}};
				end
				else if (in_pattern == 3'd3) begin
					r_out_pixel_1P[idx]	<= in_x + idx + in_y;
				end
				else begin
					r_out_pixel_1P[idx]	<= w_random_data[idx];
				end
			end
		end
	end
endgenerate

assign	out_x		= r_out_x_1P;
assign	out_y		= r_out_y_1P;
assign	out_vs		= r_out_vs_1P;
assign	out_hs		= r_out_hs_1P;
assign	out_valid	= r_out_valid_1P;
assign	out_de		= r_out_de_1P;
assign	out_data	= {{(64-PACK_BIT){1'b0}}, r_out_pixel_1P};

generate
    for(idx=0 ; idx<PACK_NUM ; idx=idx+1) begin
        lfsr #(
            .LFSR_WIDTH(PIXEL_BIT),
            .DATA_WIDTH(FIFO_WIDTH*2),
            .LFSR_POLY(32'h04c11db7),
            .LFSR_CONFIG("GALOIS")
        ) lfsr_inst (
            .data_in({in_y, in_x+idx*PACK_NUM}),
            .state_in({{(PIXEL_BIT-FIFO_WIDTH){1'b0}}, in_x+idx*PACK_NUM + in_y}),
            .data_out(),
            .state_out(w_random_data[idx])
        );

    end
endgenerate

endmodule
