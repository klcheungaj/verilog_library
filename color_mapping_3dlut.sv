
/**
 * 1. using trilinear interpolation
 * 2. i_data must be in RGB format and R is the first subpixel in least 
 * significant bit  
 */
module color_mapping_3dlut #(
    parameter CD = 8,   // color depth
    parameter GS = 33,  // Grid Size, either 17, 33 or 65
    parameter LUT_CD = 10, // color deptth of 3D LUT, typically 8-bit to 16-bit 
    localparam IN_PCNT = 2 // number of input pixel per cycle
) (

    input p_clk,    // pixel clock
    input p_rstn,   // pixel clock reset_n

    // apb3iface.slv apb3, // apb3 interface including APB clock and reset 

    input                     i_hs,
    input                     i_vs,
    input                     i_de,
    input                     i_valid,
    input [CD*3*IN_PCNT-1:0]  i_data,

    output                    o_hs,
    output                    o_vs,
    output                    o_de,
    output                    o_valid,
    output [CD*3*IN_PCNT-1:0] o_data,
    
    input [LUT_CD*3-1:0]      i_cfg_data,
    input                     i_cfg_valid,
    input                     i_cfg_last
);

localparam FRAC = 8;
localparam IDX_BIT = $clog2(GS);

wire [CD-1:0] in_r = i_data[0 +: CD];
wire [CD-1:0] in_g = i_data[CD +: CD];
wire [CD-1:0] in_b = i_data[CD*2 +: CD];

// -------------------------------------------------------
// -- stage 1
// -------------------------------------------------------
logic [IDX_BIT-1:0] w_map_r;
logic [IDX_BIT-1:0] w_map_g;
logic [IDX_BIT-1:0] w_map_b;
logic [FRAC-1:0] w_map_frac_r;
logic [FRAC-1:0] w_map_frac_g;
logic [FRAC-1:0] w_map_frac_b;
// -------------------------------------------------------
// -- stage 2
// -------------------------------------------------------
logic [FRAC-1:0] map_frac_r_r1;
logic [FRAC-1:0] map_frac_g_r1;
logic [FRAC-1:0] map_frac_b_r1;

// -------------------------------------------------------
// -- stage 3
// -------------------------------------------------------
logic [FRAC-1:0] map_frac_r_r2;
logic [FRAC-1:0] map_frac_g_r2;
logic [FRAC-1:0] map_frac_b_r2;
wire  [LUT_CD*3-1:0] w_p0_nbr[7:0];
// -------------------------------------------------------
// -- stage 9
// -------------------------------------------------------
wire [LUT_CD*3-1:0] w_out_pt;
assign o_data[0 +: 3*CD] = {w_out_pt[LUT_CD*2+:CD], w_out_pt[LUT_CD+:CD], w_out_pt[0+:CD]} ;

always_ff @(posedge p_clk or negedge p_rstn) begin
    if (!p_rstn) begin

    end else begin
        // map_r_r1 <= map_r;
        // map_g_r1 <= map_g;
        // map_b_r1 <= map_b;
        map_frac_r_r1 <= w_map_frac_r;
        map_frac_g_r1 <= w_map_frac_g;
        map_frac_b_r1 <= w_map_frac_b;
        map_frac_r_r2 <= map_frac_r_r1;
        map_frac_g_r2 <= map_frac_g_r1;
        map_frac_b_r2 <= map_frac_b_r1;
        // for (int i=0 ; i<7 ; i=i+1) begin
        //     lut_pt_r1[i] <= w_lut_pt[i];
        // end
    end
end


fractional_multiply #(
    .FACTOR  ($itor(GS - 1) / $itor((1 << CD) - 1)),
    .IN_BIT  (CD),
    .OUT_BIT (IDX_BIT),
    .FRAC_BIT(FRAC),
    .Q_BITS  (16)
) u_multiplier_red (
    .clk(p_clk),
    .rstn(p_rstn),
    .din(in_r),
    .dout(w_map_r),
    .frac(w_map_frac_r)
);

fractional_multiply #(
    .FACTOR  ($itor(GS - 1) / $itor((1 << CD) - 1)),
    .IN_BIT  (CD),
    .OUT_BIT (IDX_BIT),
    .FRAC_BIT(FRAC),
    .Q_BITS  (16)
) u_multiplier_green (
    .clk(p_clk),
    .rstn(p_rstn),
    .din(in_g),
    .dout(w_map_g),
    .frac(w_map_frac_g)
);

fractional_multiply #(
    .FACTOR  ($itor(GS - 1) / $itor((1 << CD) - 1)),
    .IN_BIT  (CD),
    .OUT_BIT (IDX_BIT),
    .FRAC_BIT(FRAC),
    .Q_BITS  (16)
) u_multiplier_blue (
    .clk(p_rstn),
    .rstn(p_rstn),
    .din(in_b),
    .dout(w_map_b),
    .frac(w_map_frac_b)
);

trilinear_interpolation #(
    .FW(FRAC),
    .CD(LUT_CD)
) u_trilinear_interpolation_pt0 (
    .clk(p_clk),
    .rstn(p_rstn),

    .frac_r(map_frac_r_r2),
    .frac_g(map_frac_g_r2),
    .frac_b(map_frac_b_r2),

    .pt_nbr(w_p0_nbr),
    .out_pt(w_out_pt)
);

ram_3dlut #(
    .GS(GS),
    .LUT_CD(LUT_CD)
) u_ram_3dlut (
    .clk(p_clk),
    .rstn(p_rstn),
    .i_p0_idx_r(w_map_r),
    .i_p0_idx_g(w_map_g),
    .i_p0_idx_b(w_map_b),
    .o_p0_nbr(w_p0_nbr),
    
    .i_cfg_data(i_cfg_data),
    .i_cfg_valid(i_cfg_valid),
    .i_cfg_last(i_cfg_last)
);

endmodule
