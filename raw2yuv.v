/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//
// Description:
// This module convert 8-bit RAW(GbBRGr) data to 8-bit YUV422. Y is LSB.  
//
// Language:  Verilog 2001
//
// ------------------------------------------------------------------------------
// REVISION:
// 1.0 Initial rev
// 
/////////////////////////////////////////////////////////////////////////////////

module raw2yuv #(
)(

    input         clk,
    input         rstn,

    input         in_vsync,
    input         in_hsync,
    input         in_de,
    input         in_valid,
    input [63:0]  in_data,
    
    output        out_vsync,
    output        out_hsync,
    output        out_de,
    output        out_valid,
    output [31:0] out_data,
    output [10:0] out_x,
    output [10:0] out_y
);

reg     [0:0]   r_gain_vs_1P;
reg     [0:0]   r_gain_hs_1P;
reg     [0:0]   r_gain_de_1P;
reg     [0:0]   r_gain_valid_1P;
reg     [31:0]  r_gain_pixel_1P;

wire    [0:0]   w_debayer_lb_hs;
wire    [0:0]   w_debayer_lb_vs;
wire    [0:0]   w_debayer_lb_ah;
wire    [0:0]   w_debayer_lb_de;
wire    [15:0]  w_debayer_lb_p_11;
wire    [15:0]  w_debayer_lb_p_00;
wire    [15:0]  w_debayer_lb_p_01;

line_buffer #(
    .P_DEPTH    (8),
    .X_CNT_WIDTH(10)
) inst_line_buffer_debayer (
    .i_arstn    (rstn),
    .i_pclk     (clk),
    
    .i_vsync    (in_vsync),
    .i_hsync    (in_hsync),
    .i_de       (in_de),
    .i_valid    (in_valid),
    .i_p        ({in_data[12 +: 8], in_data[2 +: 8]}),
    
    .o_vsync    (w_debayer_lb_vs),
    .o_hsync    (w_debayer_lb_hs),
    .o_de       (w_debayer_lb_ah),
    .o_valid    (w_debayer_lb_de),
    .o_p_11     (w_debayer_lb_p_11),
    .o_p_00     (w_debayer_lb_p_00),
    .o_p_01     (w_debayer_lb_p_01)
);

wire    [0:0]   w_debayer_hs;
wire    [0:0]   w_debayer_vs;
wire    [0:0]   w_debayer_de;
wire    [0:0]   w_debayer_valid;
wire    [10:0]  w_debayer_x;
wire    [10:0]  w_debayer_y;
wire    [15:0]  w_debayer_r;
wire    [15:0]  w_debayer_g;
wire    [15:0]  w_debayer_b;

raw_to_rgb #(
    .P_DEPTH    (8),
    .LEGACY     (1'b1)
) inst_raw_to_rgb
(
    .i_arstn    (rstn),
    .i_pclk     (clk),
    
    .i_r_addn   (1'b0),
    .i_r_gain   (8'b0),
    .i_r_shift  (1'b0),
    .i_g_addn   (1'b0),
    .i_g_gain   (8'b0),
    .i_g_shift  (1'b0),
    .i_b_addn   (1'b0),
    .i_b_gain   (8'b0),
    .i_b_shift  (1'b0),
    
    .i_vsync    (w_debayer_lb_vs),
    .i_hsync    (w_debayer_lb_hs),
    .i_de       (w_debayer_lb_ah),
    .i_valid    (w_debayer_lb_de),
    .i_p_11     (w_debayer_lb_p_11),
    .i_p_00     (w_debayer_lb_p_00),
    .i_p_01     (w_debayer_lb_p_01),
    
    .o_dbg_valid            (),
    .o_dbg_bayer_11_01_0P_0 (),
    .o_dbg_bayer_11_01_0P_1 (),
    .o_dbg_bayer_00_01_0P_0 (),
    .o_dbg_bayer_00_01_0P_1 (),
    .o_dbg_bayer_01_01_0P_0 (),
    .o_dbg_bayer_01_01_0P_1 (),
    .o_dbg_bayer_11_00_1P_0 (),
    .o_dbg_bayer_11_00_1P_1 (),
    .o_dbg_bayer_00_00_1P_0 (),
    .o_dbg_bayer_00_00_1P_1 (),
    .o_dbg_bayer_01_00_1P_0 (),
    .o_dbg_bayer_01_00_1P_1 (),
    .o_dbg_bayer_11_11_2P_0 (),
    .o_dbg_bayer_11_11_2P_1 (),
    .o_dbg_bayer_00_11_2P_0 (),
    .o_dbg_bayer_00_11_2P_1 (),
    .o_dbg_bayer_01_11_2P_0 (),
    .o_dbg_bayer_01_11_2P_1 (),
    
    .o_vsync    (w_debayer_vs),
    .o_hsync    (w_debayer_hs),
    .o_de       (w_debayer_de),
    .o_valid    (w_debayer_valid),
    .o_x_cnt    (),
    .o_y_cnt    (),
    .o_r        (w_debayer_r),
    .o_g        (w_debayer_g),
    .o_b        (w_debayer_b)
);

reg [0:0]   r_yuv_hs = 0;
reg [0:0]   r_yuv_vs = 0;
reg [0:0]   r_yuv_de = 0;
reg [0:0]   r_yuv_valid = 0;
reg [10:0]  r_yuv_cnt_x = 0;
reg [10:0]  r_yuv_cnt_y = 0;
reg signed [16:0]  r_yuv_y[1:0];
reg signed [16:0]  r_yuv_u[1:0];
reg signed [16:0]  r_yuv_v[1:0];

reg [0:0]   r2_yuv_hs = 0;
reg [0:0]   r2_yuv_vs = 0;
reg [0:0]   r2_yuv_de = 0;
reg [0:0]   r2_yuv_valid = 0;
reg [10:0]  r2_yuv_cnt_x = 0;
reg [10:0]  r2_yuv_cnt_y = 0;
reg [7:0]   r2_yuv_y[1:0];
reg [7:0]   r2_yuv_u[1:0];
reg [7:0]   r2_yuv_v[1:0];

// reg [0:0]   r3_yuv_hs = 0;
// reg [0:0]   r3_yuv_vs = 0;
// reg [0:0]   r3_yuv_de = 0;
// reg [0:0]   r3_yuv_valid = 0;
// reg [10:0]  r3_yuv_cnt_x = 0;
// reg [10:0]  r3_yuv_cnt_y = 0;
// reg [7:0]   r3_yuv_y[1:0];
// reg [7:0]   r3_yuv_u[1:0];
// reg [7:0]   r3_yuv_v[1:0];

assign out_vsync = r2_yuv_vs;
assign out_hsync = r2_yuv_hs ;
assign out_de = r2_yuv_de;
assign out_valid = r2_yuv_valid;
assign out_data = {r2_yuv_v[1], r2_yuv_y[1], r2_yuv_u[0], r2_yuv_y[0]};
assign out_x = r2_yuv_cnt_x;
assign out_y = r2_yuv_cnt_y;
localparam signed [8:0] Y_R = $rtoi($floor(0.2126*(1<<8)));
localparam signed [8:0] Y_G = $rtoi($floor(0.7152*(1<<8))); 
localparam signed [8:0] Y_B = $rtoi($floor(0.0722*(1<<8)));
localparam signed [8:0] U_R = $rtoi($floor(-0.1146*(1<<8)));
localparam signed [8:0] U_G = $rtoi($floor(-0.3854*(1<<8))); 
localparam signed [8:0] U_B = $rtoi($floor(0.5000*(1<<8)));
localparam signed [8:0] V_R = $rtoi($floor(0.5000*(1<<8)));
localparam signed [8:0] V_G = $rtoi($floor(-0.4542*(1<<8))); 
localparam signed [8:0] V_B = $rtoi($floor(-0.0458*(1<<8)));

function [7:0] right_shift_8bit;
    input signed [16:0] data;
    input [7:0] bias;
    reg signed [8:0] shift;
    reg signed [9:0] temp;

    shift = data >>> 8;
    temp = shift + $signed({1'b0, bias});
    if (temp >= $signed(10'd256))
        right_shift_8bit = 8'hff;
    else if (temp < $signed(10'd0))
        right_shift_8bit = 8'd0;
    else
        right_shift_8bit = temp[0 +: 8]; 
endfunction

wire signed [16:0] w_yuv_yr[1:0];
wire signed [16:0] w_yuv_yg[1:0];
wire signed [16:0] w_yuv_yb[1:0];

wire signed [16:0] w_yuv_ur[1:0];
wire signed [16:0] w_yuv_ug[1:0];
wire signed [16:0] w_yuv_ub[1:0];

wire signed [16:0] w_yuv_vr[1:0];
wire signed [16:0] w_yuv_vg[1:0];
wire signed [16:0] w_yuv_vb[1:0];
genvar idx;
generate
    for(idx=0 ; idx<2 ; idx=idx+1) begin
        assign w_yuv_yr[idx] = $signed({1'b0,w_debayer_r[idx*8+:8]})*Y_R;
        assign w_yuv_yg[idx] = $signed({1'b0,w_debayer_g[idx*8+:8]})*Y_G;
        assign w_yuv_yb[idx] = $signed({1'b0,w_debayer_b[idx*8+:8]})*Y_B;
        
        assign w_yuv_ur[idx] = $signed({1'b0,w_debayer_r[idx*8+:8]})*U_R;
        assign w_yuv_ug[idx] = $signed({1'b0,w_debayer_g[idx*8+:8]})*U_G;
        assign w_yuv_ub[idx] = $signed({1'b0,w_debayer_b[idx*8+:8]})*U_B;
        
        assign w_yuv_vr[idx] = $signed({1'b0,w_debayer_r[idx*8+:8]})*V_R;
        assign w_yuv_vg[idx] = $signed({1'b0,w_debayer_g[idx*8+:8]})*V_G;
        assign w_yuv_vb[idx] = $signed({1'b0,w_debayer_b[idx*8+:8]})*V_B;
    end
endgenerate

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        r_yuv_hs <= 0;
        r_yuv_vs <= 0;
        r_yuv_de <= 0;
        r_yuv_valid <= 0;
        r_yuv_cnt_x <= 0;
        r_yuv_cnt_y <= 0;
        r_yuv_y[0] <= 0;
        r_yuv_u[0] <= 0;
        r_yuv_v[0] <= 0;
        r_yuv_y[1] <= 0;
        r_yuv_u[1] <= 0;
        r_yuv_v[1] <= 0;

        r2_yuv_hs <= 0;
        r2_yuv_vs <= 0;
        r2_yuv_de <= 0;
        r2_yuv_valid <= 0;
        r2_yuv_cnt_x <= 0;
        r2_yuv_cnt_y <= 0;
        r2_yuv_y[0] <= 0;
        r2_yuv_u[0] <= 0;
        r2_yuv_v[0] <= 0;
        r2_yuv_y[1] <= 0;
        r2_yuv_u[1] <= 0;
        r2_yuv_v[1] <= 0;
    end else begin
        r_yuv_hs <= w_debayer_hs;
        r_yuv_vs <= w_debayer_vs;
        r_yuv_de <= w_debayer_de;
        r_yuv_valid <= w_debayer_valid;
        if (r_yuv_hs && !w_debayer_hs)
            r_yuv_cnt_x <= 0;
        else if (w_debayer_de && w_debayer_valid) //cnt_x of the 1st valid pixel is 0 
            r_yuv_cnt_x <= r_yuv_cnt_x + 1;

        if (r_yuv_vs && !w_debayer_vs)
            r_yuv_cnt_y <= 0;
        else if (r_yuv_hs && !w_debayer_hs)
            r_yuv_cnt_y <= r_yuv_cnt_y + 1;

        for(integer i=0 ; i<2 ; i=i+1) begin
            r_yuv_y[i] <= w_yuv_yr[i] + w_yuv_yg[i] + w_yuv_yb[i];
            r_yuv_u[i] <= w_yuv_ur[i] + w_yuv_ug[i] + w_yuv_ub[i];
            r_yuv_v[i] <= w_yuv_vr[i] + w_yuv_vg[i] + w_yuv_vb[i];
        end

        /** 2nd stage */
        r2_yuv_hs <= r_yuv_hs;
        r2_yuv_vs <= r_yuv_vs;
        r2_yuv_de <= r_yuv_de;
        r2_yuv_valid <= r_yuv_valid;
        r2_yuv_cnt_y <= r_yuv_cnt_y;
        r2_yuv_cnt_x <= r_yuv_cnt_x;
        for(integer i=0 ; i<2 ; i=i+1) begin
            r2_yuv_y[i] <= right_shift_8bit(r_yuv_y[i], 8'd0); 
            r2_yuv_u[i] <= right_shift_8bit(r_yuv_u[i], 8'd128); 
            r2_yuv_v[i] <= right_shift_8bit(r_yuv_v[i], 8'd128); 
        end
    end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2022 Efinix Inc. All rights reserved.
//
// This   document  contains  proprietary information  which   is
// protected by  copyright. All rights  are reserved.  This notice
// refers to original work by Efinix, Inc. which may be derivitive
// of other work distributed under license of the authors.  In the
// case of derivative work, nothing in this notice overrides the
// original author's license agreement.  Where applicable, the 
// original license agreement is included in it's original 
// unmodified form immediately below this header.
//
// WARRANTY DISCLAIMER.  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND 
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH 
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES, 
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF 
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR 
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED 
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.
//
// LIMITATION OF LIABILITY.  
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY 
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT 
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY 
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT, 
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY 
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR 
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN 
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER 
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR 
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT 
//     APPLY TO LICENSEE.
//
/////////////////////////////////////////////////////////////////////////////
