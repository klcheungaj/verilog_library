
module trilinear_interpolation #(
    parameter FW = 8,  // fractional part width
    parameter CD = 8   // color depth
) (
    input clk,
    input rstn,


    input               in_valid,
    input [FW-1:0]      frac_r,
    input [FW-1:0]      frac_g,
    input [FW-1:0]      frac_b,
    input [CD*3-1:0]    pt_nbr[7:0],       // {B, G, R}
    output [CD*3-1:0]   out_pt,
    output              out_valid
);

/**
 *                                                   Blue                   
 *           C110______________________  C111         ↑  ↗ Green  
 *              /|         / C11      /|              | /             
 *             / |     C1 /          / |              |/          
 *            /  |       /|         /  |              -----> Red          
 *           /___|______/_|________/   |                                  
 *       C100|   |    C10 |   C101|    |                                          
 *           |   |        |       |    |                                  
 *           |   |      C *       |    |                              
 *           |   |        |       |    |                              
 *           |   |________|_______|____|                                              
 *           |   / C010   |/ C01  |   / C011                                      
 *           |  /      C0 |       |  /                                            
 *           | /         /        | /                                         
 *           |/_________/_________|/                                                  
 *       C000          C00       C001                                         
 *   
 */

// internal color depth. Can be larger than the input color depth to increase the precision 
localparam I_CD = CD + 2;

logic [I_CD*3-1:0] pt_nbr_ext[7:0];   // extended pt_nbr to increase precision;
logic [I_CD-1:0] pt_r_interp        [3:0][2:0];
logic [I_CD-1:0] pt_rg_interp       [1:0][2:0];
logic [I_CD-1:0] pt_rgb_interp           [2:0];
logic [(I_CD+1)-1:0] pt_r_interp_l  [3:0][2:0];
logic [(I_CD+1)-1:0] pt_r_interp_r  [3:0][2:0];
logic [(I_CD+1)-1:0] pt_rg_interp_l [1:0][2:0];
logic [(I_CD+1)-1:0] pt_rg_interp_r [1:0][2:0];
logic [(I_CD+1)-1:0] pt_rgb_interp_l     [2:0];
logic [(I_CD+1)-1:0] pt_rgb_interp_r     [2:0];
logic [FW-1:0] frac_g_r1;
logic [FW-1:0] frac_g_r2;
logic [FW-1:0] frac_b_r1;
logic [FW-1:0] frac_b_r2;
logic [FW-1:0] frac_b_r3;
logic [FW-1:0] frac_b_r4;
logic [ 6-1:0] r_valid;
logic [FW:0] comb_oppo_frac_r;  // one more width as frac could be 0
logic [FW:0] comb_oppo_frac_g;  // one more width as frac could be 0
logic [FW:0] comb_oppo_frac_b;  // one more width as frac could be 0
assign out_pt = {pt_rgb_interp[2][I_CD-1 -: CD], pt_rgb_interp[1][I_CD-1 -: CD], pt_rgb_interp[0][I_CD-1 -: CD]};
assign out_valid = r_valid[5];

genvar idx;
generate
    for (idx=0; idx<8 ; idx=idx+1) begin
        assign pt_nbr_ext[idx][I_CD*0 +: I_CD] = {pt_nbr[idx][CD*0 +: CD], {(I_CD-CD){1'b0}}};
        assign pt_nbr_ext[idx][I_CD*1 +: I_CD] = {pt_nbr[idx][CD*1 +: CD], {(I_CD-CD){1'b0}}};
        assign pt_nbr_ext[idx][I_CD*2 +: I_CD] = {pt_nbr[idx][CD*2 +: CD], {(I_CD-CD){1'b0}}};
    end
endgenerate

function logic [(I_CD+1)-1:0] mul_shift_3ch (
    input [I_CD-1:0] pt,
    input [FW:0]   frac
);
logic [I_CD+FW+1-1:0] temp;
begin
    temp = pt * frac;
    // one more decimal bit each channel for rounding
    mul_shift_3ch = temp[FW-1 +: I_CD+1];
    // mul_shift_3ch = (temp/256) << 1;
end
endfunction

function logic [I_CD-1:0] add_3ch (
    input [(I_CD+1)-1:0] pt0,
    input [(I_CD+1)-1:0] pt1
);
logic [I_CD+2-1:0] temp;
begin
    temp = pt0 + pt1;
    assert(temp[I_CD+1] != 1) else $display("[ERROR] %0t: red pt0: 0x%x, pt1: 0x%x, result: 0x%x", $time, pt0, pt1, temp);
    add_3ch = temp[1 +: I_CD];
end
endfunction

always_comb begin
    comb_oppo_frac_r = (FW+1)'((1<<FW) - frac_r);
    comb_oppo_frac_g = (FW+1)'((1<<FW) - frac_g_r2);
    comb_oppo_frac_b = (FW+1)'((1<<FW) - frac_b_r4);
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // 2d default is not supported in some tools
        pt_r_interp_l[0] <= '{default:'0};
        pt_r_interp_l[1] <= '{default:'0};
        pt_r_interp_l[2] <= '{default:'0};
        pt_r_interp_l[3] <= '{default:'0};
        pt_r_interp_r[0] <= '{default:'0};
        pt_r_interp_r[1] <= '{default:'0};
        pt_r_interp_r[2] <= '{default:'0};
        pt_r_interp_r[3] <= '{default:'0};
    end else begin
        // pt_r_interp[0] <= ((pt_nbr[0] * comb_oppo_frac_r) >> FW) + (pt_nbr[1] * frac_r >> FW);
        // pt_r_interp[1] <= ((pt_nbr[2] * comb_oppo_frac_r) >> FW) + (pt_nbr[3] * frac_r >> FW);
        // pt_r_interp[2] <= ((pt_nbr[4] * comb_oppo_frac_r) >> FW) + (pt_nbr[5] * frac_r >> FW);
        // pt_r_interp[3] <= ((pt_nbr[6] * comb_oppo_frac_r) >> FW) + (pt_nbr[7] * frac_r >> FW);
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_r_interp_l[0][ch] <= mul_shift_3ch(pt_nbr_ext[0][ch*I_CD +: I_CD], comb_oppo_frac_r);
            pt_r_interp_l[1][ch] <= mul_shift_3ch(pt_nbr_ext[2][ch*I_CD +: I_CD], comb_oppo_frac_r);
            pt_r_interp_l[2][ch] <= mul_shift_3ch(pt_nbr_ext[4][ch*I_CD +: I_CD], comb_oppo_frac_r);
            pt_r_interp_l[3][ch] <= mul_shift_3ch(pt_nbr_ext[6][ch*I_CD +: I_CD], comb_oppo_frac_r);
            pt_r_interp_r[0][ch] <= mul_shift_3ch(pt_nbr_ext[1][ch*I_CD +: I_CD], {1'b0, frac_r});
            pt_r_interp_r[1][ch] <= mul_shift_3ch(pt_nbr_ext[3][ch*I_CD +: I_CD], {1'b0, frac_r});
            pt_r_interp_r[2][ch] <= mul_shift_3ch(pt_nbr_ext[5][ch*I_CD +: I_CD], {1'b0, frac_r});
            pt_r_interp_r[3][ch] <= mul_shift_3ch(pt_nbr_ext[7][ch*I_CD +: I_CD], {1'b0, frac_r});
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_r_interp[0] <= '{default:'0};
        pt_r_interp[1] <= '{default:'0};
        pt_r_interp[2] <= '{default:'0};
        pt_r_interp[3] <= '{default:'0};
    end else begin
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_r_interp[0][ch] <= add_3ch(pt_r_interp_l[0][ch], pt_r_interp_r[0][ch]);
            pt_r_interp[1][ch] <= add_3ch(pt_r_interp_l[1][ch], pt_r_interp_r[1][ch]);
            pt_r_interp[2][ch] <= add_3ch(pt_r_interp_l[2][ch], pt_r_interp_r[2][ch]);
            pt_r_interp[3][ch] <= add_3ch(pt_r_interp_l[3][ch], pt_r_interp_r[3][ch]);
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rg_interp_l[0] <= '{default:'0};
        pt_rg_interp_l[1] <= '{default:'0};
        pt_rg_interp_r[0] <= '{default:'0};
        pt_rg_interp_r[1] <= '{default:'0};
    end else begin
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_rg_interp_l[0][ch] <= mul_shift_3ch(pt_r_interp[0][ch], comb_oppo_frac_g); 
            pt_rg_interp_l[1][ch] <= mul_shift_3ch(pt_r_interp[2][ch], comb_oppo_frac_g); 
            pt_rg_interp_r[0][ch] <= mul_shift_3ch(pt_r_interp[1][ch], {1'b0, frac_g_r2});
            pt_rg_interp_r[1][ch] <= mul_shift_3ch(pt_r_interp[3][ch], {1'b0, frac_g_r2});
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rg_interp[0] <= '{default:'0};
        pt_rg_interp[1] <= '{default:'0};
    end else begin
        // pt_rg_interp[0] <= ((pt_r_interp[0] * comb_oppo_frac_g) >> FW) + (pt_r_interp[1] * frac_g_r1 >> FW);
        // pt_rg_interp[1] <= ((pt_r_interp[2] * comb_oppo_frac_g) >> FW) + (pt_r_interp[3] * frac_g_r1 >> FW);
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_rg_interp[0][ch] <= add_3ch(pt_rg_interp_l[0][ch], pt_rg_interp_r[0][ch]);
            pt_rg_interp[1][ch] <= add_3ch(pt_rg_interp_l[1][ch], pt_rg_interp_r[1][ch]);
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rgb_interp_l <= '{default:'0};
        pt_rgb_interp_r <= '{default:'0};
    end else begin
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_rgb_interp_l[ch] <= mul_shift_3ch(pt_rg_interp[0][ch], comb_oppo_frac_b);
            pt_rgb_interp_r[ch] <= mul_shift_3ch(pt_rg_interp[1][ch], {1'b0, frac_b_r4});
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rgb_interp <= '{default:'0};
    end else begin
        // pt_rgb_interp <= ((pt_rg_interp[0] * comb_oppo_frac_b) >> FW) + (pt_rg_interp[1] * frac_b_r2 >> FW);
        for (int ch=0 ; ch<3 ; ch=ch+1) begin
            pt_rgb_interp[ch] <= add_3ch(pt_rgb_interp_l[ch], pt_rgb_interp_r[ch]);
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        frac_g_r1 <= '0;
        frac_g_r2 <= '0;
        frac_b_r1 <= '0;
        frac_b_r2 <= '0;
        frac_b_r3 <= '0;
        frac_b_r4 <= '0;
        r_valid <= '0;
    end else begin
        frac_g_r1 <= frac_g;
        frac_g_r2 <= frac_g_r1;
        frac_b_r1 <= frac_b;
        frac_b_r2 <= frac_b_r1;
        frac_b_r3 <= frac_b_r2;
        frac_b_r4 <= frac_b_r3;
        r_valid <= {r_valid[0 +: 5], in_valid};
    end
end

endmodule
