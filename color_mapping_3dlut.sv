
/**
 * 1. using trilinear interpolation
 * 2. i_data must be in RGB format and R is the first subpixel in least 
 * significant bit  
 */
module color_mapping_3dlut #(
    parameter  CD = 8,   // color depth
    parameter  GS = 33,  // Grid Size, either 16, 17, 32, 33, 64 or 65
    parameter  LUT_CD = 8, // color deptth of 3D LUT, typically 8-bit to 16-bit 
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

// wire [CD-1:0] in_r = i_data[0 +: CD];
// wire [CD-1:0] in_g = i_data[CD +: CD];
// wire [CD-1:0] in_b = i_data[CD*2 +: CD];

// -------------------------------------------------------
// -- stage 1
// -------------------------------------------------------
logic [IDX_BIT-1:0] w_map_r[1:0];
logic [IDX_BIT-1:0] w_map_g[1:0];
logic [IDX_BIT-1:0] w_map_b[1:0];
logic [FRAC-1:0] w_map_frac_r[1:0];
logic [FRAC-1:0] w_map_frac_g[1:0];
logic [FRAC-1:0] w_map_frac_b[1:0];
// -------------------------------------------------------
// -- stage 2
// -------------------------------------------------------
logic [FRAC-1:0] map_frac_r_r1[1:0];
logic [FRAC-1:0] map_frac_g_r1[1:0];
logic [FRAC-1:0] map_frac_b_r1[1:0];

// -------------------------------------------------------
// -- stage 3
// -------------------------------------------------------
logic [FRAC-1:0] map_frac_r_r2[1:0];
logic [FRAC-1:0] map_frac_g_r2[1:0];
logic [FRAC-1:0] map_frac_b_r2[1:0];
wire  [LUT_CD*3-1:0] w_pt_nbr[1:0][7:0];
// -------------------------------------------------------
// -- stage 9
// -------------------------------------------------------
wire [CD*3-1:0] w_out_pt[1:0];
logic [8:0] r_hs = '0;
logic [8:0] r_vs = '0;
logic [8:0] r_de = '0;
logic [8:0] r_valid = '0;
// assign o_data[0 +: 3*CD] = {w_out_pt[0][LUT_CD*2+:CD], w_out_pt[0][LUT_CD+:CD], w_out_pt[0][0+:CD]} ;
// assign o_data[3*CD +: 3*CD] = {w_out_pt[1][LUT_CD*2+:CD], w_out_pt[1][LUT_CD+:CD], w_out_pt[1][0+:CD]} ;
assign o_data[0 +: 3*CD] = {w_out_pt[0][CD*2+:CD], w_out_pt[0][CD+:CD], w_out_pt[0][0+:CD]} ;
assign o_data[3*CD +: 3*CD] = {w_out_pt[1][CD*2+:CD], w_out_pt[1][CD+:CD], w_out_pt[1][0+:CD]} ;
assign o_hs = r_hs[8];
assign o_vs = r_vs[8];
assign o_de = r_de[8];
assign o_valid = r_valid[8];

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
        r_hs = { r_hs[0 +: 8], i_hs };
        r_vs = { r_vs[0 +: 8], i_vs };
        r_de = { r_de[0 +: 8], i_de };
        r_valid = { r_valid[0 +: 8], i_valid };
        // for (int i=0 ; i<7 ; i=i+1) begin
        //     lut_pt_r1[i] <= w_lut_pt[i];
        // end
    end
end

generate
    for (genvar idx=0; idx<2 ; idx++) begin
        fractional_multiply #(
            .FACTOR  ($itor(GS - 1) / $itor((1 << CD) - 1)),
            .IN_BIT  (CD),
            .OUT_BIT (IDX_BIT),
            .FRAC_BIT(FRAC),
            .Q_BITS  (16)
        ) u_multiplier_red (
            .clk(p_clk),
            .rstn(p_rstn),
            .din(i_data[CD*3*idx+0 +: CD]),
            .dout(w_map_r[idx]),
            .frac(w_map_frac_r[idx])
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
            .din(i_data[CD*3*idx+CD +: CD]),
            .dout(w_map_g[idx]),
            .frac(w_map_frac_g[idx])
        );

        fractional_multiply #(
            .FACTOR  ($itor(GS - 1) / $itor((1 << CD) - 1)),
            .IN_BIT  (CD),
            .OUT_BIT (IDX_BIT),
            .FRAC_BIT(FRAC),
            .Q_BITS  (16)
        ) u_multiplier_blue (
            .clk(p_clk),
            .rstn(p_rstn),
            .din(i_data[CD*3*idx+CD*2 +: CD]),
            .dout(w_map_b[idx]),
            .frac(w_map_frac_b[idx])
        );

        for (genvar ch=0 ; ch<3 ; ch=ch+1) begin
            trilinear_interpolation #(
                .FW(FRAC),
                .IN_CD(LUT_CD),
                .OUT_CD(CD)
            ) u_trilinear_interpolation_pt0 (
                .clk(p_clk),
                .rstn(p_rstn),

                .in_valid(),
                .frac_x(map_frac_r_r2[idx]),
                .frac_y(map_frac_g_r2[idx]),
                .frac_z(map_frac_b_r2[idx]),

                .out_valid(),
                .pt_nbr('{
                    w_pt_nbr[idx][7][ch*LUT_CD +: LUT_CD], w_pt_nbr[idx][6][ch*LUT_CD +: LUT_CD],
                    w_pt_nbr[idx][5][ch*LUT_CD +: LUT_CD], w_pt_nbr[idx][4][ch*LUT_CD +: LUT_CD],
                    w_pt_nbr[idx][3][ch*LUT_CD +: LUT_CD], w_pt_nbr[idx][2][ch*LUT_CD +: LUT_CD],
                    w_pt_nbr[idx][1][ch*LUT_CD +: LUT_CD], w_pt_nbr[idx][0][ch*LUT_CD +: LUT_CD]
                }),
                .out_pt(w_out_pt[idx][ch*CD +: CD])
            );
        end
    end
endgenerate


ram_3dlut #(
    .GS(GS),
    .LUT_CD(LUT_CD)
) u_ram_3dlut (
    .clk(p_clk),
    .rstn(p_rstn),
    .i_p0_idx_r(w_map_r[0]),
    .i_p0_idx_g(w_map_g[0]),
    .i_p0_idx_b(w_map_b[0]),
    .o_p0_nbr(w_pt_nbr[0]),
    
    .i_p1_idx_r(w_map_r[1]),
    .i_p1_idx_g(w_map_g[1]),
    .i_p1_idx_b(w_map_b[1]),
    .o_p1_nbr(w_pt_nbr[1]),

    .i_cfg_data(i_cfg_data),
    .i_cfg_valid(i_cfg_valid),
    .i_cfg_last(i_cfg_last)
);

endmodule
