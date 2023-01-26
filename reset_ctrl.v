
module reset_ctrl
#(
	parameter	NUM_RST			= 1,
	parameter	CYCLE			= 1,
	parameter	IN_RST_ACTIVE	= 1'b1,
	parameter	OUT_RST_ACTIVE	= 1'b1
)
(
	input	[NUM_RST-1:0]	i_arst,
	input	[NUM_RST-1:0]	i_clk,
	output	[NUM_RST-1:0]	o_srst
);

genvar i;
generate
	for (i=0; i<NUM_RST; i=i+1)
	begin
		if (IN_RST_ACTIVE & (1'b1 << i))
		begin
			if (OUT_RST_ACTIVE & (1'b1 << i))
			begin
				reset
				#(
					.IN_RST_ACTIVE	("HIGH"),
					.OUT_RST_ACTIVE	("HIGH"),
					.CYCLE			(CYCLE)
				)
				inst_sysclk_rstn
				(
					.i_arst	(i_arst[i]),
					.i_clk	(i_clk[i]),
					.o_srst	(o_srst[i])
				);
			end
			else
			begin
				reset
				#(
					.IN_RST_ACTIVE	("HIGH"),
					.OUT_RST_ACTIVE	("LOW"),
					.CYCLE			(CYCLE)
				)
				inst_sysclk_rstn
				(
					.i_arst	(i_arst[i]),
					.i_clk	(i_clk[i]),
					.o_srst	(o_srst[i])
				);
			end
		end
		else
		begin
			if (OUT_RST_ACTIVE & (1'b1 << i))
			begin
				reset
				#(
					.IN_RST_ACTIVE	("LOW"),
					.OUT_RST_ACTIVE	("HIGH"),
					.CYCLE			(CYCLE)
				)
				inst_sysclk_rstn
				(
					.i_arst	(i_arst[i]),
					.i_clk	(i_clk[i]),
					.o_srst	(o_srst[i])
				);
			end
			else
			begin
				reset
				#(
					.IN_RST_ACTIVE	("LOW"),
					.OUT_RST_ACTIVE	("LOW"),
					.CYCLE			(CYCLE)
				)
				inst_sysclk_rstn
				(
					.i_arst	(i_arst[i]),
					.i_clk	(i_clk[i]),
					.o_srst	(o_srst[i])
				);
			end
		end
	end
endgenerate

endmodule

