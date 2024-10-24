////////////////////////////////////////////
// revision       : 1.0
// File generated : 1970-01-01 08:00:00
////////////////////////////////////////////
`default_nettype none

module apb3_example (
    output reg  [  0:0] pma_rstn                  ,
    output reg  [  0:0] ddr_cfg_rstn              ,
    output reg  [  0:0] lvds_test_rstn            ,
    output reg  [  0:0] pm_gpio_test_rstn         ,
    output reg  [  0:0] mem_test_rstn             ,
    output reg  [  0:0] gpio_test_rstn            ,
    output reg  [  0:0] mipi_rstn                 ,
    output reg  [  0:0] osc_test_rstn             ,
    output reg  [  0:0] xge_test_start            ,
    output reg  [  0:0] mem_start                 ,
    output reg  [  0:0] mipi_start                ,
    output reg  [  0:0] kr_restart_training       ,
    output reg  [  8:0] led                       ,
    output reg  [ 31:0] mem_run_sec               ,
    input  wire [  1:0] clk_pass                  ,
    input  wire [  1:0] clk_fail                  ,
    input  wire [  0:0] ddr_cfg_done         [1:0],
    input  wire [  0:0] mem_done             [1:0],
    input  wire [ 31:0] mem_wr_bandwidth     [1:0],
    input  wire [ 31:0] mem_rd_bandwidth     [1:0],
    input  wire [ 31:0] mem_error_dq_total   [1:0],
    input  wire [ 11:0] gpio_pass                 ,
    input  wire [ 11:0] gpio_fail                 ,
    input  wire [  0:0] mipi_pass            [3:0],
    input  wire [  0:0] mipi_fail            [3:0],
    input  wire [  0:0] mipi_clk_active      [3:0],
    input  wire [  0:0] mipi_frame_valid     [3:0],
    input  wire [  0:0] lvds0_pass          [14:0],
    input  wire [  7:0] lvds0_target_point  [14:0],
    input  wire [  7:0] lvds0_end_point     [14:0],
    input  wire [  7:0] lvds0_start_point   [14:0],
    input  wire [ 31:0] lvds0_pass_cnt_line [14:0],
    input  wire [ 31:0] lvds0_fail_cnt_line [14:0],
    input  wire [  0:0] lvds1_pass          [14:0],
    input  wire [  7:0] lvds1_target_point  [14:0],
    input  wire [  7:0] lvds1_end_point     [14:0],
    input  wire [  7:0] lvds1_start_point   [14:0],
    input  wire [ 31:0] lvds1_pass_cnt_line [14:0],
    input  wire [ 31:0] lvds1_fail_cnt_line [14:0],
    input  wire [  3:0] xge_init_done             ,

    input  wire         s_apb3_clk                ,
    input  wire         s_apb3_rstn               ,
    input  wire [ 15:0] s_apb3_paddr              ,
    input  wire         s_apb3_psel               ,
    input  wire         s_apb3_penable            ,
    output reg          s_apb3_pready             ,
    input  wire         s_apb3_pwrite             ,
    input  wire [ 31:0] s_apb3_pwdata             ,
    output reg  [ 31:0] s_apb3_prdata             ,
    output wire         s_apb3_pslverror          
);
//-- Following parameters were defined when this RTL file was generated. 
//-- They are not directly used in this file
// localparam NUM_LED = 9;
// localparam NUM_DDR = 2;
// localparam NUM_CLK = 2;
// localparam NUM_MIPI = 4;
// localparam NUM_GPIO = 12;
// localparam NUM_LVDS0 = 15;
// localparam NUM_LVDS1 = 15;
// localparam NUM_XGE = 4;

assign s_apb3_pslverror = 1'b0;
reg [16-3:0] loc_addr;
reg          loc_wr_vld;
reg          loc_rd_vld;

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0)
        loc_addr <= 14'b0;
    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0))
        loc_addr <= s_apb3_paddr[2 +: 14];
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0)
        loc_wr_vld <= 1'b0;
    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b1))
        loc_wr_vld <= 1'b1;
    else
        loc_wr_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0)
        loc_rd_vld <= 1'b0;
    else if((s_apb3_psel == 1'b1) && (s_apb3_penable == 1'b0) && (s_apb3_pwrite == 1'b0))
        loc_rd_vld <= 1'b1;
    else
        loc_rd_vld <= 1'b0;
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0)
        s_apb3_pready <= 1'b0;
    else if((loc_wr_vld == 1'b1) || (loc_rd_vld == 1'b1))
        s_apb3_pready <= 1'b1;
    else
        s_apb3_pready <= 1'b0;
end
always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        {pma_rstn, ddr_cfg_rstn, lvds_test_rstn, pm_gpio_test_rstn, mem_test_rstn, gpio_test_rstn, mipi_rstn, osc_test_rstn} <= 8'b0;
    end else if((loc_wr_vld == 1'b1) && (loc_addr == 14'd0)) begin
        {pma_rstn, ddr_cfg_rstn, lvds_test_rstn, pm_gpio_test_rstn, mem_test_rstn, gpio_test_rstn, mipi_rstn, osc_test_rstn} <= s_apb3_pwdata[0 +: 8];
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        {xge_test_start, mem_start, mipi_start} <= 3'b0;
    end else if((loc_wr_vld == 1'b1) && (loc_addr == 14'd1)) begin
        {xge_test_start, mem_start, mipi_start} <= s_apb3_pwdata[0 +: 3];
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        kr_restart_training <= 1'b0;
    end else if((loc_wr_vld == 1'b1) && (loc_addr == 14'd2)) begin
        kr_restart_training <= s_apb3_pwdata[0 +: 1];
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        led <= 9'b0;
    end else if((loc_wr_vld == 1'b1) && (loc_addr == 14'd3)) begin
        led <= s_apb3_pwdata[0 +: 9];
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        mem_run_sec <= 32'b0;
    end else if((loc_wr_vld == 1'b1) && (loc_addr == 14'd4)) begin
        mem_run_sec <= s_apb3_pwdata[0 +: 32];
    end
end

always @(posedge s_apb3_clk or negedge s_apb3_rstn) begin
    if(s_apb3_rstn == 1'b0) begin
        s_apb3_prdata <= 32'b0;
    end else if(loc_rd_vld == 1'b1) begin
        case (loc_addr)
            14'd0 : s_apb3_prdata <= { 24'b0, {pma_rstn, ddr_cfg_rstn, lvds_test_rstn, pm_gpio_test_rstn, mem_test_rstn, gpio_test_rstn, mipi_rstn, osc_test_rstn} };
            14'd1 : s_apb3_prdata <= { 29'b0, {xge_test_start, mem_start, mipi_start} };
            14'd2 : s_apb3_prdata <= { 31'b0, kr_restart_training };
            14'd3 : s_apb3_prdata <= { 23'b0, led };
            14'd4 : s_apb3_prdata <= mem_run_sec;
            14'd5 : s_apb3_prdata <= { 30'b0, clk_pass };
            14'd6 : s_apb3_prdata <= { 30'b0, clk_fail };
            14'd7 : s_apb3_prdata <= { 31'b0, ddr_cfg_done[0] };
            14'd8 : s_apb3_prdata <= { 31'b0, ddr_cfg_done[1] };
            14'd9 : s_apb3_prdata <= { 31'b0, mem_done[0] };
            14'd10 : s_apb3_prdata <= { 31'b0, mem_done[1] };
            14'd11 : s_apb3_prdata <= mem_wr_bandwidth[0];
            14'd12 : s_apb3_prdata <= mem_wr_bandwidth[1];
            14'd13 : s_apb3_prdata <= mem_rd_bandwidth[0];
            14'd14 : s_apb3_prdata <= mem_rd_bandwidth[1];
            14'd15 : s_apb3_prdata <= mem_error_dq_total[0];
            14'd16 : s_apb3_prdata <= mem_error_dq_total[1];
            14'd17 : s_apb3_prdata <= { 20'b0, gpio_pass };
            14'd18 : s_apb3_prdata <= { 20'b0, gpio_fail };
            14'd19 : s_apb3_prdata <= { 31'b0, mipi_pass[0] };
            14'd20 : s_apb3_prdata <= { 31'b0, mipi_pass[1] };
            14'd21 : s_apb3_prdata <= { 31'b0, mipi_pass[2] };
            14'd22 : s_apb3_prdata <= { 31'b0, mipi_pass[3] };
            14'd23 : s_apb3_prdata <= { 31'b0, mipi_fail[0] };
            14'd24 : s_apb3_prdata <= { 31'b0, mipi_fail[1] };
            14'd25 : s_apb3_prdata <= { 31'b0, mipi_fail[2] };
            14'd26 : s_apb3_prdata <= { 31'b0, mipi_fail[3] };
            14'd27 : s_apb3_prdata <= { 31'b0, mipi_clk_active[0] };
            14'd28 : s_apb3_prdata <= { 31'b0, mipi_clk_active[1] };
            14'd29 : s_apb3_prdata <= { 31'b0, mipi_clk_active[2] };
            14'd30 : s_apb3_prdata <= { 31'b0, mipi_clk_active[3] };
            14'd31 : s_apb3_prdata <= { 31'b0, mipi_frame_valid[0] };
            14'd32 : s_apb3_prdata <= { 31'b0, mipi_frame_valid[1] };
            14'd33 : s_apb3_prdata <= { 31'b0, mipi_frame_valid[2] };
            14'd34 : s_apb3_prdata <= { 31'b0, mipi_frame_valid[3] };
            14'd35 : s_apb3_prdata <= { 31'b0, lvds0_pass[0] };
            14'd36 : s_apb3_prdata <= { 31'b0, lvds0_pass[1] };
            14'd37 : s_apb3_prdata <= { 31'b0, lvds0_pass[2] };
            14'd38 : s_apb3_prdata <= { 31'b0, lvds0_pass[3] };
            14'd39 : s_apb3_prdata <= { 31'b0, lvds0_pass[4] };
            14'd40 : s_apb3_prdata <= { 31'b0, lvds0_pass[5] };
            14'd41 : s_apb3_prdata <= { 31'b0, lvds0_pass[6] };
            14'd42 : s_apb3_prdata <= { 31'b0, lvds0_pass[7] };
            14'd43 : s_apb3_prdata <= { 31'b0, lvds0_pass[8] };
            14'd44 : s_apb3_prdata <= { 31'b0, lvds0_pass[9] };
            14'd45 : s_apb3_prdata <= { 31'b0, lvds0_pass[10] };
            14'd46 : s_apb3_prdata <= { 31'b0, lvds0_pass[11] };
            14'd47 : s_apb3_prdata <= { 31'b0, lvds0_pass[12] };
            14'd48 : s_apb3_prdata <= { 31'b0, lvds0_pass[13] };
            14'd49 : s_apb3_prdata <= { 31'b0, lvds0_pass[14] };
            14'd50 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[0], lvds0_end_point[0], lvds0_start_point[0]} };
            14'd51 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[1], lvds0_end_point[1], lvds0_start_point[1]} };
            14'd52 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[2], lvds0_end_point[2], lvds0_start_point[2]} };
            14'd53 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[3], lvds0_end_point[3], lvds0_start_point[3]} };
            14'd54 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[4], lvds0_end_point[4], lvds0_start_point[4]} };
            14'd55 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[5], lvds0_end_point[5], lvds0_start_point[5]} };
            14'd56 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[6], lvds0_end_point[6], lvds0_start_point[6]} };
            14'd57 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[7], lvds0_end_point[7], lvds0_start_point[7]} };
            14'd58 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[8], lvds0_end_point[8], lvds0_start_point[8]} };
            14'd59 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[9], lvds0_end_point[9], lvds0_start_point[9]} };
            14'd60 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[10], lvds0_end_point[10], lvds0_start_point[10]} };
            14'd61 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[11], lvds0_end_point[11], lvds0_start_point[11]} };
            14'd62 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[12], lvds0_end_point[12], lvds0_start_point[12]} };
            14'd63 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[13], lvds0_end_point[13], lvds0_start_point[13]} };
            14'd64 : s_apb3_prdata <= { 8'b0, {lvds0_target_point[14], lvds0_end_point[14], lvds0_start_point[14]} };
            14'd65 : s_apb3_prdata <= lvds0_pass_cnt_line[0];
            14'd66 : s_apb3_prdata <= lvds0_pass_cnt_line[1];
            14'd67 : s_apb3_prdata <= lvds0_pass_cnt_line[2];
            14'd68 : s_apb3_prdata <= lvds0_pass_cnt_line[3];
            14'd69 : s_apb3_prdata <= lvds0_pass_cnt_line[4];
            14'd70 : s_apb3_prdata <= lvds0_pass_cnt_line[5];
            14'd71 : s_apb3_prdata <= lvds0_pass_cnt_line[6];
            14'd72 : s_apb3_prdata <= lvds0_pass_cnt_line[7];
            14'd73 : s_apb3_prdata <= lvds0_pass_cnt_line[8];
            14'd74 : s_apb3_prdata <= lvds0_pass_cnt_line[9];
            14'd75 : s_apb3_prdata <= lvds0_pass_cnt_line[10];
            14'd76 : s_apb3_prdata <= lvds0_pass_cnt_line[11];
            14'd77 : s_apb3_prdata <= lvds0_pass_cnt_line[12];
            14'd78 : s_apb3_prdata <= lvds0_pass_cnt_line[13];
            14'd79 : s_apb3_prdata <= lvds0_pass_cnt_line[14];
            14'd80 : s_apb3_prdata <= lvds0_fail_cnt_line[0];
            14'd81 : s_apb3_prdata <= lvds0_fail_cnt_line[1];
            14'd82 : s_apb3_prdata <= lvds0_fail_cnt_line[2];
            14'd83 : s_apb3_prdata <= lvds0_fail_cnt_line[3];
            14'd84 : s_apb3_prdata <= lvds0_fail_cnt_line[4];
            14'd85 : s_apb3_prdata <= lvds0_fail_cnt_line[5];
            14'd86 : s_apb3_prdata <= lvds0_fail_cnt_line[6];
            14'd87 : s_apb3_prdata <= lvds0_fail_cnt_line[7];
            14'd88 : s_apb3_prdata <= lvds0_fail_cnt_line[8];
            14'd89 : s_apb3_prdata <= lvds0_fail_cnt_line[9];
            14'd90 : s_apb3_prdata <= lvds0_fail_cnt_line[10];
            14'd91 : s_apb3_prdata <= lvds0_fail_cnt_line[11];
            14'd92 : s_apb3_prdata <= lvds0_fail_cnt_line[12];
            14'd93 : s_apb3_prdata <= lvds0_fail_cnt_line[13];
            14'd94 : s_apb3_prdata <= lvds0_fail_cnt_line[14];
            14'd95 : s_apb3_prdata <= { 31'b0, lvds1_pass[0] };
            14'd96 : s_apb3_prdata <= { 31'b0, lvds1_pass[1] };
            14'd97 : s_apb3_prdata <= { 31'b0, lvds1_pass[2] };
            14'd98 : s_apb3_prdata <= { 31'b0, lvds1_pass[3] };
            14'd99 : s_apb3_prdata <= { 31'b0, lvds1_pass[4] };
            14'd100 : s_apb3_prdata <= { 31'b0, lvds1_pass[5] };
            14'd101 : s_apb3_prdata <= { 31'b0, lvds1_pass[6] };
            14'd102 : s_apb3_prdata <= { 31'b0, lvds1_pass[7] };
            14'd103 : s_apb3_prdata <= { 31'b0, lvds1_pass[8] };
            14'd104 : s_apb3_prdata <= { 31'b0, lvds1_pass[9] };
            14'd105 : s_apb3_prdata <= { 31'b0, lvds1_pass[10] };
            14'd106 : s_apb3_prdata <= { 31'b0, lvds1_pass[11] };
            14'd107 : s_apb3_prdata <= { 31'b0, lvds1_pass[12] };
            14'd108 : s_apb3_prdata <= { 31'b0, lvds1_pass[13] };
            14'd109 : s_apb3_prdata <= { 31'b0, lvds1_pass[14] };
            14'd110 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[0], lvds1_end_point[0], lvds1_start_point[0]} };
            14'd111 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[1], lvds1_end_point[1], lvds1_start_point[1]} };
            14'd112 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[2], lvds1_end_point[2], lvds1_start_point[2]} };
            14'd113 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[3], lvds1_end_point[3], lvds1_start_point[3]} };
            14'd114 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[4], lvds1_end_point[4], lvds1_start_point[4]} };
            14'd115 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[5], lvds1_end_point[5], lvds1_start_point[5]} };
            14'd116 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[6], lvds1_end_point[6], lvds1_start_point[6]} };
            14'd117 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[7], lvds1_end_point[7], lvds1_start_point[7]} };
            14'd118 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[8], lvds1_end_point[8], lvds1_start_point[8]} };
            14'd119 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[9], lvds1_end_point[9], lvds1_start_point[9]} };
            14'd120 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[10], lvds1_end_point[10], lvds1_start_point[10]} };
            14'd121 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[11], lvds1_end_point[11], lvds1_start_point[11]} };
            14'd122 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[12], lvds1_end_point[12], lvds1_start_point[12]} };
            14'd123 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[13], lvds1_end_point[13], lvds1_start_point[13]} };
            14'd124 : s_apb3_prdata <= { 8'b0, {lvds1_target_point[14], lvds1_end_point[14], lvds1_start_point[14]} };
            14'd125 : s_apb3_prdata <= lvds1_pass_cnt_line[0];
            14'd126 : s_apb3_prdata <= lvds1_pass_cnt_line[1];
            14'd127 : s_apb3_prdata <= lvds1_pass_cnt_line[2];
            14'd128 : s_apb3_prdata <= lvds1_pass_cnt_line[3];
            14'd129 : s_apb3_prdata <= lvds1_pass_cnt_line[4];
            14'd130 : s_apb3_prdata <= lvds1_pass_cnt_line[5];
            14'd131 : s_apb3_prdata <= lvds1_pass_cnt_line[6];
            14'd132 : s_apb3_prdata <= lvds1_pass_cnt_line[7];
            14'd133 : s_apb3_prdata <= lvds1_pass_cnt_line[8];
            14'd134 : s_apb3_prdata <= lvds1_pass_cnt_line[9];
            14'd135 : s_apb3_prdata <= lvds1_pass_cnt_line[10];
            14'd136 : s_apb3_prdata <= lvds1_pass_cnt_line[11];
            14'd137 : s_apb3_prdata <= lvds1_pass_cnt_line[12];
            14'd138 : s_apb3_prdata <= lvds1_pass_cnt_line[13];
            14'd139 : s_apb3_prdata <= lvds1_pass_cnt_line[14];
            14'd140 : s_apb3_prdata <= lvds1_fail_cnt_line[0];
            14'd141 : s_apb3_prdata <= lvds1_fail_cnt_line[1];
            14'd142 : s_apb3_prdata <= lvds1_fail_cnt_line[2];
            14'd143 : s_apb3_prdata <= lvds1_fail_cnt_line[3];
            14'd144 : s_apb3_prdata <= lvds1_fail_cnt_line[4];
            14'd145 : s_apb3_prdata <= lvds1_fail_cnt_line[5];
            14'd146 : s_apb3_prdata <= lvds1_fail_cnt_line[6];
            14'd147 : s_apb3_prdata <= lvds1_fail_cnt_line[7];
            14'd148 : s_apb3_prdata <= lvds1_fail_cnt_line[8];
            14'd149 : s_apb3_prdata <= lvds1_fail_cnt_line[9];
            14'd150 : s_apb3_prdata <= lvds1_fail_cnt_line[10];
            14'd151 : s_apb3_prdata <= lvds1_fail_cnt_line[11];
            14'd152 : s_apb3_prdata <= lvds1_fail_cnt_line[12];
            14'd153 : s_apb3_prdata <= lvds1_fail_cnt_line[13];
            14'd154 : s_apb3_prdata <= lvds1_fail_cnt_line[14];
            14'd155 : s_apb3_prdata <= { 28'b0, xge_init_done };
            default: s_apb3_prdata <= 32'b0;
        endcase
    end
end

endmodule

