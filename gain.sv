

/**
 * @brief gain after debayer
 */

module gain
#(
	parameter SUBPIXEL_WIDTH = 8,
    parameter PIXEL_CNT = 2,
    localparam DATA_WIDTH = SUBPIXEL_WIDTH * PIXEL_CNT
) (
	input                   i_pclk,
	input                   i_arstn,
	
    input [9:0]             blue_gain,  // 0.0 - 4.0. 0 to 255 = 0.0 to 1.0
    input [9:0]             green_gain, // 0.0 - 4.0. 0 to 255 = 0.0 to 1.0
    input [9:0]             red_gain,   // 0.0 - 4.0. 0 to 255 = 0.0 to 1.0
    input [7:0]             blue_offset,
    input [7:0]             green_offset,
    input [7:0]             red_offset,

	input 		            i_hs,
	input                   i_vs,
	input				    i_de,
	input				    i_valid,
	input [          12:0]  i_x,
	input [          12:0]  i_y,
	input [DATA_WIDTH-1:0]  i_r,
	input [DATA_WIDTH-1:0]  i_g,
	input [DATA_WIDTH-1:0]  i_b,
	
	output 		            o_hs,
	output                  o_vs,
	output				    o_de,
	output				    o_valid,
	output [          12:0] o_x,
	output [          12:0] o_y,
	output [DATA_WIDTH-1:0] o_r,
	output [DATA_WIDTH-1:0] o_g,
	output [DATA_WIDTH-1:0] o_b
);

reg 		                hs_r1;
reg                         vs_r1;
reg				            de_r1;
reg				            valid_r1;
reg  [                12:0] x_r1;
reg  [                12:0] y_r1;
reg [SUBPIXEL_WIDTH+10-1:0] r_r1[PIXEL_CNT];
reg [SUBPIXEL_WIDTH+10-1:0] g_r1[PIXEL_CNT];
reg [SUBPIXEL_WIDTH+10-1:0] b_r1[PIXEL_CNT];

reg 		                hs_r2;
reg                         vs_r2;
reg				            de_r2;
reg				            valid_r2;
reg  [                12:0] x_r2;
reg  [                12:0] y_r2;
reg [SUBPIXEL_WIDTH-1:0]    r_r2[PIXEL_CNT];
reg [SUBPIXEL_WIDTH-1:0]    g_r2[PIXEL_CNT];
reg [SUBPIXEL_WIDTH-1:0]    b_r2[PIXEL_CNT];

genvar idx;

assign o_hs = hs_r2;
assign o_vs = vs_r2;
assign o_de = de_r2;
assign o_valid = valid_r2;
assign o_x = x_r2;
assign o_y = y_r2;
assign o_r = {r_r2[1], r_r2[0]};
assign o_g = {g_r2[1], g_r2[0]};
assign o_b = {b_r2[1], b_r2[0]};

always @(posedge i_pclk) begin
    hs_r1 <= i_hs;
    vs_r1 <= i_vs;
    de_r1 <= i_de;
    valid_r1 <= i_valid;
    x_r1 <= i_x;
    y_r1 <= i_y;
    hs_r2 <= hs_r1;
    vs_r2 <= vs_r1;
    de_r2 <= de_r1;
    valid_r2 <= valid_r1;
    x_r2 <= x_r1;
    y_r2 <= y_r1;
end

generate
    for (idx=0 ; idx<PIXEL_CNT ; idx=idx+1) begin
        always @(posedge i_pclk or negedge i_arstn) begin
            if (!i_arstn) begin
                r_r1[idx] <= '0;
                g_r1[idx] <= '0;
                b_r1[idx] <= '0;
                r_r2[idx] <= '0;
                g_r2[idx] <= '0;
                b_r2[idx] <= '0;
            end else begin
                r_r1[idx] <= (i_r[idx*SUBPIXEL_WIDTH +: SUBPIXEL_WIDTH] * red_gain) >> 8 + red_offset;
                g_r1[idx] <= (i_g[idx*SUBPIXEL_WIDTH +: SUBPIXEL_WIDTH] * green_gain) >> 8 + green_offset;
                b_r1[idx] <= (i_b[idx*SUBPIXEL_WIDTH +: SUBPIXEL_WIDTH] * blue_gain) >> 8 + blue_offset;
                r_r2[idx] <= r_r1[idx] > {10'd0, {SUBPIXEL_WIDTH{1'b1}}} ? {SUBPIXEL_WIDTH{1'b1}} : r_r1[idx][0 +: SUBPIXEL_WIDTH];
                g_r2[idx] <= g_r1[idx] > {10'd0, {SUBPIXEL_WIDTH{1'b1}}} ? {SUBPIXEL_WIDTH{1'b1}} : g_r1[idx][0 +: SUBPIXEL_WIDTH];
                b_r2[idx] <= b_r1[idx] > {10'd0, {SUBPIXEL_WIDTH{1'b1}}} ? {SUBPIXEL_WIDTH{1'b1}} : b_r1[idx][0 +: SUBPIXEL_WIDTH];
            end
        end
    end
endgenerate

endmodule
