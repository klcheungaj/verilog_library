
module trilinear_interpolation #(
    parameter FW = 8,  // fractional part width
    parameter IN_CD = 8,   // input color depth
    parameter OUT_CD = IN_CD   // output color depth
) (
    input clk,
    input rstn,

    input               in_valid,
    input  [    FW-1:0] frac_x,
    input  [    FW-1:0] frac_y,
    input  [    FW-1:0] frac_z,
    input  [ IN_CD-1:0] pt_nbr[7:0],
    output [OUT_CD-1:0] out_pt,
    output              out_valid
);

/**
 *                                                    Z    Y               
 *           C110______________________  C111         ↑  ↗   
 *              /|         / C11      /|              | /             
 *             / |     C1 /          / |              |/          
 *            /  |       /|         /  |              -----> X          
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
localparam I_CD = IN_CD + 2;

initial begin
    $display("FW: %d, IN_CD: %d, OUT_CD: %d", FW, IN_CD, OUT_CD);
    assert(I_CD >= IN_CD);
    assert(OUT_CD <= IN_CD);
end

logic [I_CD-1:0] pt_nbr_ext[7:0];   // extended pt_nbr to increase precision;
logic [I_CD-1:0] pt_r_interp        [3:0];
logic [I_CD-1:0] pt_rg_interp       [1:0];
logic [I_CD-1:0] pt_rgb_interp           ;
logic [(I_CD+1)-1:0] pt_r_interp_l  [3:0];
logic [(I_CD+1)-1:0] pt_r_interp_r  [3:0];
logic [(I_CD+1)-1:0] pt_rg_interp_l [1:0];
logic [(I_CD+1)-1:0] pt_rg_interp_r [1:0];
logic [(I_CD+1)-1:0] pt_rgb_interp_l     ;
logic [(I_CD+1)-1:0] pt_rgb_interp_r     ;
logic [FW-1:0] frac_y_r1;
logic [FW-1:0] frac_y_r2;
logic [FW-1:0] frac_z_r1;
logic [FW-1:0] frac_z_r2;
logic [FW-1:0] frac_z_r3;
logic [FW-1:0] frac_z_r4;
logic [ 6-1:0] r_valid;
logic [FW:0] comb_oppo_frac_x;  // one more width as frac could be 0
logic [FW:0] comb_oppo_frac_y;  // one more width as frac could be 0
logic [FW:0] comb_oppo_frac_z;  // one more width as frac could be 0
assign out_pt = pt_rgb_interp[I_CD-1 -: OUT_CD];
assign out_valid = r_valid[5];

genvar idx;
generate
    for (idx=0; idx<8 ; idx=idx+1) begin
        assign pt_nbr_ext[idx] = {pt_nbr[idx], {(I_CD-IN_CD){1'b0}}};
    end
endgenerate

function logic [(I_CD+1)-1:0] mul_shift (
    input [I_CD-1:0] pt,
    input [FW:0]   frac
);
logic [I_CD+FW+1-1:0] temp;
begin
    temp = pt * frac;
    // one more decimal bit each channel for rounding
    mul_shift = temp[FW-1 +: I_CD+1];
end
endfunction

function logic [I_CD-1:0] add (
    input [(I_CD+1)-1:0] pt0,
    input [(I_CD+1)-1:0] pt1
);
logic [I_CD+2-1:0] temp;
begin
    temp = pt0 + pt1;
    assert(temp[I_CD+1] != 1) else $display("[ERROR] %0t: red pt0: 0x%x, pt1: 0x%x, result: 0x%x", $time, pt0, pt1, temp);
    add = temp[1 +: I_CD];
end
endfunction

always_comb begin
    comb_oppo_frac_x = (FW+1)'((1<<FW) - frac_x);
    comb_oppo_frac_y = (FW+1)'((1<<FW) - frac_y_r2);
    comb_oppo_frac_z = (FW+1)'((1<<FW) - frac_z_r4);
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // 2d default is not supported in some tools
        pt_r_interp_l <= '{default:'0};
        pt_r_interp_r <= '{default:'0};
    end else begin
        pt_r_interp_l[0] <= mul_shift(pt_nbr_ext[0], comb_oppo_frac_x);
        pt_r_interp_l[1] <= mul_shift(pt_nbr_ext[2], comb_oppo_frac_x);
        pt_r_interp_l[2] <= mul_shift(pt_nbr_ext[4], comb_oppo_frac_x);
        pt_r_interp_l[3] <= mul_shift(pt_nbr_ext[6], comb_oppo_frac_x);
        pt_r_interp_r[0] <= mul_shift(pt_nbr_ext[1], {1'b0, frac_x});
        pt_r_interp_r[1] <= mul_shift(pt_nbr_ext[3], {1'b0, frac_x});
        pt_r_interp_r[2] <= mul_shift(pt_nbr_ext[5], {1'b0, frac_x});
        pt_r_interp_r[3] <= mul_shift(pt_nbr_ext[7], {1'b0, frac_x});
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_r_interp <= '{default:'0};
    end else begin
        pt_r_interp[0] <= add(pt_r_interp_l[0], pt_r_interp_r[0]);
        pt_r_interp[1] <= add(pt_r_interp_l[1], pt_r_interp_r[1]);
        pt_r_interp[2] <= add(pt_r_interp_l[2], pt_r_interp_r[2]);
        pt_r_interp[3] <= add(pt_r_interp_l[3], pt_r_interp_r[3]);
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rg_interp_l <= '{default:'0};
        pt_rg_interp_r <= '{default:'0};
    end else begin
        pt_rg_interp_l[0] <= mul_shift(pt_r_interp[0], comb_oppo_frac_y); 
        pt_rg_interp_l[1] <= mul_shift(pt_r_interp[2], comb_oppo_frac_y); 
        pt_rg_interp_r[0] <= mul_shift(pt_r_interp[1], {1'b0, frac_y_r2});
        pt_rg_interp_r[1] <= mul_shift(pt_r_interp[3], {1'b0, frac_y_r2});
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rg_interp <= '{default:'0};
    end else begin
        pt_rg_interp[0] <= add(pt_rg_interp_l[0], pt_rg_interp_r[0]);
        pt_rg_interp[1] <= add(pt_rg_interp_l[1], pt_rg_interp_r[1]);
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rgb_interp_l <= '0;
        pt_rgb_interp_r <= '0;
    end else begin
        pt_rgb_interp_l <= mul_shift(pt_rg_interp[0], comb_oppo_frac_z);
        pt_rgb_interp_r <= mul_shift(pt_rg_interp[1], {1'b0, frac_z_r4});
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        pt_rgb_interp <= '0;
    end else begin
        pt_rgb_interp <= add(pt_rgb_interp_l, pt_rgb_interp_r);
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        frac_y_r1 <= '0;
        frac_y_r2 <= '0;
        frac_z_r1 <= '0;
        frac_z_r2 <= '0;
        frac_z_r3 <= '0;
        frac_z_r4 <= '0;
        r_valid <= '0;
    end else begin
        frac_y_r1 <= frac_y;
        frac_y_r2 <= frac_y_r1;
        frac_z_r1 <= frac_z;
        frac_z_r2 <= frac_z_r1;
        frac_z_r3 <= frac_z_r2;
        frac_z_r4 <= frac_z_r3;
        r_valid <= {r_valid[0 +: 5], in_valid};
    end
end

endmodule
