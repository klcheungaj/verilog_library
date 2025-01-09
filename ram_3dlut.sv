
`define Q_DLY #0.5

module ram_3dlut #(
    parameter GS = 33,  // Grid Size, either 17, 33 or 65
    parameter LUT_CD = 10,    // color depth of LUT. e.g. 8-bit
    localparam IDX_BIT = $clog2(GS)
) (
    input                 clk,
    input                 rstn,

    input                 i_valid,
    output                o_valid,
    input  [ IDX_BIT-1:0] i_p0_idx_r,
    input  [ IDX_BIT-1:0] i_p0_idx_g,
    input  [ IDX_BIT-1:0] i_p0_idx_b,
    output [LUT_CD*3-1:0] o_p0_nbr  [7:0],

    input  [ IDX_BIT-1:0] i_p1_idx_r,
    input  [ IDX_BIT-1:0] i_p1_idx_g,
    input  [ IDX_BIT-1:0] i_p1_idx_b,
    output [LUT_CD*3-1:0] o_p1_nbr  [7:0],

    input [LUT_CD*3-1:0]  i_cfg_data,
    input                 i_cfg_valid,
    input                 i_cfg_last
);

localparam GSM1W = $clog2(GS-1);    // bit width of (Grid size minus 1)

initial begin
    assert(2**(GSM1W) == GS-1)
    else
        $error("Grid size minus 1 must be a power of 2\n");
    assert(GSM1W + 1 == IDX_BIT);
end
// -------------------------------------------------------
// -- stage 1
// -------------------------------------------------------
logic [IDX_BIT-1:0] r1_p0_idx_r;
logic [IDX_BIT-1:0] r1_p0_idx_g;
logic [IDX_BIT-1:0] r1_p0_idx_b;
logic [IDX_BIT-1:0] r1_p1_idx_r;
logic [IDX_BIT-1:0] r1_p1_idx_g;
logic [IDX_BIT-1:0] r1_p1_idx_b;
logic               r1_valid;
logic [LUT_CD*3-1:0] w_p0_p0_lut_pt[7:0]; // {B[0],G[0],R[0]}. Subpixel with smaller index has smaller value
logic [LUT_CD*3-1:0] w_p0_p1_lut_pt[7:0];

// -------------------------------------------------------
// -- stage 2
// -------------------------------------------------------
logic [LUT_CD*3-1:0] r2_p0_lut_pt[7:0]; // {B[0],G[0],R[0]}. Subpixel with smaller index has smaller value
logic [LUT_CD*3-1:0] r2_p1_lut_pt[7:0];
logic                r2_valid;
assign o_p0_nbr = r2_p0_lut_pt;
assign o_p1_nbr = r2_p1_lut_pt;
assign o_valid = r2_valid;

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        r1_p0_idx_r <= `Q_DLY '0;
        r1_p0_idx_g <= `Q_DLY '0;
        r1_p0_idx_b <= `Q_DLY '0;
        r1_p1_idx_r <= `Q_DLY '0;
        r1_p1_idx_g <= `Q_DLY '0;
        r1_p1_idx_b <= `Q_DLY '0;
        r2_p0_lut_pt <= `Q_DLY '{default:'0}; 
        r2_p1_lut_pt <= `Q_DLY '{default:'0}; 
        r1_valid <= `Q_DLY '0;
        r2_valid <= `Q_DLY '0;
    end else begin
        r1_p0_idx_r <= `Q_DLY i_p0_idx_r;
        r1_p0_idx_g <= `Q_DLY i_p0_idx_g;
        r1_p0_idx_b <= `Q_DLY i_p0_idx_b;
        r1_p1_idx_r <= `Q_DLY i_p1_idx_r;
        r1_p1_idx_g <= `Q_DLY i_p1_idx_g;
        r1_p1_idx_b <= `Q_DLY i_p1_idx_b;
        r2_p0_lut_pt <= `Q_DLY w_p0_p0_lut_pt;
        r2_p1_lut_pt <= `Q_DLY w_p0_p1_lut_pt;
        r1_valid <= `Q_DLY i_valid;
        r2_valid <= `Q_DLY r1_valid;
    end
end

logic r_gssub1_sel;
logic [2:0] r_rgbmax;
logic r_rmax_sel;
logic r_gmax_sel;
logic r_bmax_sel;
logic [IDX_BIT-1:0] cfg_count_3d[2:0];
logic [(GSM1W-1)*3-1:0] cfg_addr_gssub1;
logic [IDX_BIT*2-2-1-1:0] cfg_addr_rmax;
logic [IDX_BIT*2-2-1-1:0] cfg_addr_gmax;
logic [IDX_BIT*2-2-1-1:0] cfg_addr_bmax;
// logic [IDX_BIT-1:0] cfg_count_1d;
// logic [2:0] cfg_rgb_max;
logic [LUT_CD*3-1:0] allmax_value = 0;

cfg_last_valid: assert property (@(posedge clk) i_cfg_last |-> i_cfg_valid) $display("cfg_last_valid assertion success");
cfg_addr_rmax_sel: assert property (@(posedge clk) r_rmax_sel |-> cfg_count_3d[0] == GS - 1);
cfg_addr_gmax_sel: assert property (@(posedge clk) r_gmax_sel |-> cfg_count_3d[1] == GS - 1);
cfg_addr_bmax_sel: assert property (@(posedge clk) r_bmax_sel |-> cfg_count_3d[2] == GS - 1);
cfg_addr_gssub1_sel: assert property (@(posedge clk) r_gssub1_sel |-> 
    (cfg_count_3d[0] != GS - 1 && cfg_count_3d[1] != GS - 1 && cfg_count_3d[2] != GS - 1));
cfg_exclusive_sel: assert property (@(posedge clk) r_gssub1_sel + r_rmax_sel + r_gmax_sel + r_bmax_sel <= 1)
    else $display("[ERROR] Assertion Failed. r_gssub1_sel: %d, r_rmax_sel: %d, r_gmax_sel: %d, r_bmax_sel: %d ",
                    r_gssub1_sel, r_rmax_sel, r_gmax_sel, r_bmax_sel);

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        cfg_count_3d <= `Q_DLY '{default:'0};
    end else begin
        if (i_cfg_last) begin
            cfg_count_3d <= `Q_DLY '{default:'0};
            allmax_value <= `Q_DLY i_cfg_data;
            assert(cfg_count_3d[0] == GS-1 && cfg_count_3d[1] == GS-1 && cfg_count_3d[2] == GS-1);
        end else if (i_cfg_valid) begin
            if (cfg_count_3d[0] == GS - 1) begin
                cfg_count_3d[0] <= `Q_DLY '0;                
                if (cfg_count_3d[1] == GS - 1) begin
                    cfg_count_3d[1] <= `Q_DLY '0;
                    cfg_count_3d[2] <= `Q_DLY cfg_count_3d[2] + 1;
                end else begin
                    cfg_count_3d[1] <= `Q_DLY cfg_count_3d[1] + 1;
                end

            end else begin
                cfg_count_3d[0] <= `Q_DLY cfg_count_3d[0] + 1;
            end
        end
    end
end

always_comb begin
    r_rgbmax = {cfg_count_3d[2][IDX_BIT-1], cfg_count_3d[1][IDX_BIT-1], cfg_count_3d[0][IDX_BIT-1]};
    r_rmax_sel = i_cfg_valid && (r_rgbmax == 3'b001 || r_rgbmax == 3'b101);
    r_gmax_sel = i_cfg_valid && (r_rgbmax == 3'b010 || r_rgbmax == 3'b011);
    r_bmax_sel = i_cfg_valid && (r_rgbmax == 3'b100 || r_rgbmax == 3'b110);
    r_gssub1_sel = i_cfg_valid && (r_rgbmax == 3'b000);

    cfg_addr_gssub1 = {cfg_count_3d[2][1 +: IDX_BIT-2], cfg_count_3d[1][1 +: IDX_BIT-2], cfg_count_3d[0][1 +: IDX_BIT-2]};
    cfg_addr_rmax = {cfg_count_3d[2][1 +: IDX_BIT-1], cfg_count_3d[1][1 +: IDX_BIT-2]};
    cfg_addr_gmax = {cfg_count_3d[0][1 +: IDX_BIT-1], cfg_count_3d[2][1 +: IDX_BIT-2]};
    cfg_addr_bmax = {cfg_count_3d[1][1 +: IDX_BIT-1], cfg_count_3d[0][1 +: IDX_BIT-2]};
end

logic [LUT_CD*3-1:0] w_p0_gssub1_dout[7:0];  // subpixel with smaller index may be larger
logic [LUT_CD*3-1:0] w_p0_redmax_dout[3:0];
logic [LUT_CD*3-1:0] w_p0_greenmax_dout[3:0];
logic [LUT_CD*3-1:0] w_p0_bluemax_dout[3:0];
logic [LUT_CD*3-1:0] w_p1_gssub1_dout[7:0];
logic [LUT_CD*3-1:0] w_p1_redmax_dout[3:0];
logic [LUT_CD*3-1:0] w_p1_greenmax_dout[3:0];
logic [LUT_CD*3-1:0] w_p1_bluemax_dout[3:0];

logic [LUT_CD*3-1:0] w_p0_gssub1_pt[7:0];    // subpixel with smaller index must be smaller
logic [LUT_CD*3-1:0] w_p0_redmax_pt[3:0];
logic [LUT_CD*3-1:0] w_p0_greenmax_pt[3:0];
logic [LUT_CD*3-1:0] w_p0_bluemax_pt[3:0];
logic [LUT_CD*3-1:0] w_p1_gssub1_pt[7:0];
logic [LUT_CD*3-1:0] w_p1_redmax_pt[3:0];
logic [LUT_CD*3-1:0] w_p1_greenmax_pt[3:0];
logic [LUT_CD*3-1:0] w_p1_bluemax_pt[3:0];

genvar idx;
generate
    /**
     * pt0 = MAX ? MAX_RAM : NORM_RAM[0];
     * pt1 = MAX ? MAX_RAM : NORM_RAM[1];
     * 
     * {pt1=MAX, pt0=MAX} == 00 ? NORM_RAM[1], NORM_RAM[0]  -> with fraction
     * {pt1=MAX, pt0=MAX} == 01 ? NORM_RAM[1], MAX_RAM      -> invalid
     * {pt1=MAX, pt0=MAX} == 10 ? MAX_RAM, NORM_RAM[0]      -> with fraction
     * {pt1=MAX, pt0=MAX} == 11 ? MAX_RAM(invalid), MAX_RAM -> without fraction
     */

    for (idx=0 ; idx<8 ; idx=idx+1) begin : assigning_pt_output
        logic r = idx[0];
        logic g = idx[1];
        logic b = idx[2];
        logic [IDX_BIT-1:0] comb_p0_idx_r_add;
        logic [IDX_BIT-1:0] comb_p0_idx_g_add;
        logic [IDX_BIT-1:0] comb_p0_idx_b_add;
        logic [IDX_BIT-1:0] comb_p1_idx_r_add;
        logic [IDX_BIT-1:0] comb_p1_idx_g_add;
        logic [IDX_BIT-1:0] comb_p1_idx_b_add;

        always_comb begin
            comb_p0_idx_r_add = r1_p0_idx_r + r;
            comb_p0_idx_g_add = r1_p0_idx_g + g;
            comb_p0_idx_b_add = r1_p0_idx_b + b;
            comb_p1_idx_r_add = r1_p1_idx_r + r;
            comb_p1_idx_g_add = r1_p1_idx_g + g;
            comb_p1_idx_b_add = r1_p1_idx_b + b;
        end

        assign w_p0_p0_lut_pt[idx] = 
            comb_p0_idx_b_add[IDX_BIT-1] == 1 ? 
                (comb_p0_idx_g_add[IDX_BIT-1] == 1 ? 
                    (comb_p0_idx_r_add[IDX_BIT-1] == 1 ? allmax_value : w_p0_bluemax_pt[{g, r}]): 
                    (comb_p0_idx_r_add[IDX_BIT-1] == 1 ? w_p0_redmax_pt[{b, g}] : w_p0_bluemax_pt[{g, r}])): 
                (comb_p0_idx_g_add[IDX_BIT-1] == 1 ? 
                    (comb_p0_idx_r_add[IDX_BIT-1] == 1 ? w_p0_greenmax_pt[{r, b}] : w_p0_greenmax_pt[{r, b}]): 
                    (comb_p0_idx_r_add[IDX_BIT-1] == 1 ? w_p0_redmax_pt[{b, g}] : w_p0_gssub1_pt[idx]));

        assign w_p0_p1_lut_pt[idx] = 
            comb_p1_idx_b_add[IDX_BIT-1] == 1 ? 
                (comb_p1_idx_g_add[IDX_BIT-1] == 1 ? 
                    (comb_p1_idx_r_add[IDX_BIT-1] == 1 ? allmax_value : w_p1_bluemax_pt[{g, r}]): 
                    (comb_p1_idx_r_add[IDX_BIT-1] == 1 ? w_p1_redmax_pt[{b, g}] : w_p1_bluemax_pt[{g, r}])): 
                (comb_p1_idx_g_add[IDX_BIT-1] == 1 ? 
                    (comb_p1_idx_r_add[IDX_BIT-1] == 1 ? w_p1_greenmax_pt[{r, b}] : w_p1_greenmax_pt[{r, b}]): 
                    (comb_p1_idx_r_add[IDX_BIT-1] == 1 ? w_p1_redmax_pt[{b, g}] : w_p1_gssub1_pt[idx]));
    end

    for (idx=0 ; idx<8 ; idx=idx+1) begin : gen_3dram_GSsub1
        logic [2:0] ram_idx = idx;
        wire [IDX_BIT-2-1:0]  w_p0_r_sel = i_p0_idx_r[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p0_idx_r[0]);
        wire [IDX_BIT-2-1:0]  w_p0_g_sel = i_p0_idx_g[1 +: IDX_BIT-2] + (~ram_idx[1] & i_p0_idx_g[0]);
        wire [IDX_BIT-2-1:0]  w_p0_b_sel = i_p0_idx_b[1 +: IDX_BIT-2] + (~ram_idx[2] & i_p0_idx_b[0]);
        assign w_p0_gssub1_pt[idx] = w_p0_gssub1_dout[(3'(idx)) ^ {r1_p0_idx_b[0], r1_p0_idx_g[0], r1_p0_idx_r[0]}];
        wire [IDX_BIT-2-1:0]  w_p1_r_sel = i_p1_idx_r[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p1_idx_r[0]);
        wire [IDX_BIT-2-1:0]  w_p1_g_sel = i_p1_idx_g[1 +: IDX_BIT-2] + (~ram_idx[1] & i_p1_idx_g[0]);
        wire [IDX_BIT-2-1:0]  w_p1_b_sel = i_p1_idx_b[1 +: IDX_BIT-2] + (~ram_idx[2] & i_p1_idx_b[0]);
        assign w_p1_gssub1_pt[idx] = w_p1_gssub1_dout[(3'(idx)) ^ {r1_p1_idx_b[0], r1_p1_idx_g[0], r1_p1_idx_r[0]}];
        true_dual_port_ram #(
            .DATA_WIDTH(LUT_CD*3),
            .ADDR_WIDTH((IDX_BIT-2)*3),
            .WRITE_MODE_1("READ_FIRST"),
            .WRITE_MODE_2("READ_FIRST"),
            .OUTPUT_REG_1("FALSE"),
            .OUTPUT_REG_2("FALSE")
        ) u_ramlut (
            .clka   (clk), 
            .we1    (0), 
            .din1   (), 
            .addr1  ({
                w_p0_b_sel[0 +: IDX_BIT-2], w_p0_g_sel[0 +: IDX_BIT-2], w_p0_r_sel[0 +: IDX_BIT-2]
            }), 
            .dout1  (w_p0_gssub1_dout[idx]), 
            
            .clkb   (clk),
            .we2    (r_gssub1_sel && (
                {cfg_count_3d[2][0], cfg_count_3d[1][0], cfg_count_3d[0][0]} == ram_idx)
            ),
            .din2   (i_cfg_data),
            .addr2  (
                i_cfg_valid ? cfg_addr_gssub1 : 
                {w_p1_b_sel[0 +: IDX_BIT-2], w_p1_g_sel[0 +: IDX_BIT-2], w_p1_r_sel[0 +: IDX_BIT-2]}
            ),
            .dout2  (w_p1_gssub1_dout[idx])
        );
    end
    
    for (idx=0 ; idx<4 ; idx=idx+1) begin : gen_3dram_red_MAX
        logic [1:0] ram_idx = idx;
        wire [IDX_BIT-2-1:0]  w_p0_g_sel = i_p0_idx_g[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p0_idx_g[0]);
        wire [IDX_BIT-1-1:0]  w_p0_b_sel = {i_p0_idx_b[1 +: IDX_BIT-1]} + (~ram_idx[1] & i_p0_idx_b[0]);
        assign w_p0_redmax_pt[idx] = w_p0_redmax_dout[(2'(idx)) ^ {r1_p0_idx_b[0], r1_p0_idx_g[0]}];
        wire [IDX_BIT-2-1:0]  w_p1_g_sel = i_p1_idx_g[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p1_idx_g[0]);
        wire [IDX_BIT-1-1:0]  w_p1_b_sel = {i_p1_idx_b[1 +: IDX_BIT-1]} + (~ram_idx[1] & i_p1_idx_b[0]);
        assign w_p1_redmax_pt[idx] = w_p1_redmax_dout[(2'(idx)) ^ {r1_p1_idx_b[0], r1_p1_idx_g[0]}];
        true_dual_port_ram #(
            .DATA_WIDTH(LUT_CD*3),
            .ADDR_WIDTH(IDX_BIT-1+IDX_BIT-2),
            .WRITE_MODE_1("READ_FIRST"),
            .WRITE_MODE_2("READ_FIRST"),
            .OUTPUT_REG_1("FALSE"),
            .OUTPUT_REG_2("FALSE")
        ) u_ramlut_red_max (
            .clka   (clk), 
            .we1    (0), 
            .din1   (), 
            .addr1  ({w_p0_b_sel, w_p0_g_sel}), 
            .dout1  (w_p0_redmax_dout[idx]), 
            
            .clkb   (clk),
            .we2    (r_rmax_sel && ({cfg_count_3d[2][0], cfg_count_3d[1][0]} == ram_idx)), 
            .din2   (i_cfg_data),
            .addr2  (i_cfg_valid ? cfg_addr_rmax : {w_p1_b_sel, w_p1_g_sel}),
            .dout2  (w_p1_redmax_dout[idx])
        );
    end
        
    for (idx=0 ; idx<4 ; idx=idx+1) begin : gen_3dram_green_MAX
        logic [1:0] ram_idx = idx;
        wire [IDX_BIT-2-1:0]  w_p0_b_sel = {i_p0_idx_b[1 +: IDX_BIT-2]} + (~ram_idx[0] & i_p0_idx_b[0]);
        wire [IDX_BIT-1-1:0]  w_p0_r_sel = {i_p0_idx_r[1 +: IDX_BIT-1]} + (~ram_idx[1] & i_p0_idx_r[0]);
        assign w_p0_greenmax_pt[idx] = w_p0_greenmax_dout[(2'(idx)) ^ {r1_p0_idx_r[0], r1_p0_idx_b[0]}];
        wire [IDX_BIT-2-1:0]  w_p1_b_sel = {i_p1_idx_b[1 +: IDX_BIT-2]} + (~ram_idx[0] & i_p1_idx_b[0]);
        wire [IDX_BIT-1-1:0]  w_p1_r_sel = {i_p1_idx_r[1 +: IDX_BIT-1]} + (~ram_idx[1] & i_p1_idx_r[0]);
        assign w_p1_greenmax_pt[idx] = w_p1_greenmax_dout[(2'(idx)) ^ {r1_p1_idx_r[0], r1_p1_idx_b[0]}];
        true_dual_port_ram #(
            .DATA_WIDTH(LUT_CD*3),
            .ADDR_WIDTH(IDX_BIT-1+IDX_BIT-2),
            .WRITE_MODE_1("READ_FIRST"),
            .WRITE_MODE_2("READ_FIRST"),
            .OUTPUT_REG_1("FALSE"),
            .OUTPUT_REG_2("FALSE")
        ) u_ramlut_green_max (
            .clka   (clk), 
            .we1    (0), 
            .din1   (), 
            .addr1  ({w_p0_r_sel, w_p0_b_sel}), 
            .dout1  (w_p0_greenmax_dout[idx]), 
            
            .clkb   (clk),
            .we2    (r_gmax_sel && ({cfg_count_3d[0][0], cfg_count_3d[2][0]} == ram_idx)),  
            .din2   (i_cfg_data),
            .addr2  (i_cfg_valid ? cfg_addr_gmax : {w_p1_r_sel, w_p1_b_sel}),
            .dout2  (w_p1_greenmax_dout[idx])
        );
    end
        
    for (idx=0 ; idx<4 ; idx=idx+1) begin : gen_3dram_blue_MAX
        logic [1:0] ram_idx = idx;
        wire [IDX_BIT-2-1:0]  w_p0_r_sel = i_p0_idx_r[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p0_idx_r[0]);
        wire [IDX_BIT-1-1:0]  w_p0_g_sel = {i_p0_idx_g[1 +: IDX_BIT-1]} + (!ram_idx[1] & i_p0_idx_g[0]);
        assign w_p0_bluemax_pt[idx] = w_p0_bluemax_dout[(2'(idx)) ^ {r1_p0_idx_g[0], r1_p0_idx_r[0]}];
        wire [IDX_BIT-2-1:0]  w_p1_r_sel = i_p1_idx_r[1 +: IDX_BIT-2] + (~ram_idx[0] & i_p1_idx_r[0]);
        wire [IDX_BIT-1-1:0]  w_p1_g_sel = {i_p1_idx_g[1 +: IDX_BIT-1]} + (!ram_idx[1] & i_p1_idx_g[0]);
        assign w_p1_bluemax_pt[idx] = w_p1_bluemax_dout[(2'(idx)) ^ {r1_p1_idx_g[0], r1_p1_idx_r[0]}];
        true_dual_port_ram #(
            .DATA_WIDTH(LUT_CD*3),
            .ADDR_WIDTH(IDX_BIT-1+IDX_BIT-2),
            .WRITE_MODE_1("READ_FIRST"),
            .WRITE_MODE_2("READ_FIRST"),
            .OUTPUT_REG_1("FALSE"),
            .OUTPUT_REG_2("FALSE")
        ) u_ramlut_blue_max (
            .clka   (clk), 
            .we1    (0), 
            .din1   (), 
            .addr1  ({w_p0_g_sel, w_p0_r_sel}), 
            .dout1  (w_p0_bluemax_dout[idx]), 
            
            .clkb   (clk),
            .we2    (r_bmax_sel && ({cfg_count_3d[1][0], cfg_count_3d[0][0]} == ram_idx)),
            .din2   (i_cfg_data),
            .addr2  (i_cfg_valid ? cfg_addr_bmax : {w_p1_g_sel, w_p1_r_sel}),
            .dout2  (w_p1_bluemax_dout[idx])
        );
    end
endgenerate

endmodule
