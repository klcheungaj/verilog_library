
module frame_buffer_sel #(
    localparam FRAME_CNT         = 4,
    localparam FRAME_CNT_WID        = $clog2(FRAME_CNT)
) (
    input               rd_clk,
    input               wr_clk,
    input               rd_rstn,
    input               wr_rstn,
    input               wr_vsync,
    input               rd_vsync,
    // input [12:0] 		in_x_wr,
    // input [12:0] 		in_y_wr,
    // input				in_wr_en,
    // input [12:0]		x_win_wr,
    // input [12:0]		x_win_rd,
    // input [12:0]		y_win_wr,
    // input [12:0]		y_win_rd,
    
    output logic [FRAME_CNT_WID-1:0] wr_frame_idx,
    output logic                     valid_wr_frame,
    output logic [FRAME_CNT_WID-1:0] rd_frame_idx
); 


/*  write clock domain   */
reg  [FRAME_CNT_WID-1:0] frame_cnt = 0;
reg                      vs_r = 0;

/*  axi clock domain    */
(* async_reg = "true" *)reg  [FRAME_CNT_WID-1:0] frame_cnt_rd = 0;
(* async_reg = "true" *)reg                      vsync_rd = 0;
reg  [FRAME_CNT_WID-1:0] frame_cnt_rd_r1 = 0;
reg  [FRAME_CNT_WID-1:0] frame_cnt_rd_r2 = 0;
reg                      vsync_rd_r1 = 0;
reg                      vsync_rd_r2 = 0;
// reg  [FRAME_CNT_WID-1:0] wr_frame_idx = 0;
// reg  [FRAME_CNT_WID-1:0] rd_frame_idx = 0;
// reg                      valid_wr_frame = 0;
reg  [             15:0] debug_same_wr = 0;
reg  [             15:0] debug_same_rd = 0;
reg  [             15:0] debug_frame_cnt = 0;

always_ff @(posedge wr_clk or negedge wr_rstn) begin
    if (!wr_rstn) begin
        frame_cnt <= '0;
        vs_r <= '0;
    end else begin
        vs_r <= wr_vsync;

        if (!wr_vsync && vs_r) begin
            frame_cnt <= frame_cnt + 1;
        end
    end
end

/**
 * @brieft controlling double buffer of frames input to avoid tearing  
 */
always_ff @(posedge rd_clk or negedge rd_rstn) begin
    if (!rd_rstn) begin
        frame_cnt_rd <= '0;
        frame_cnt_rd_r1 <= '0;
        frame_cnt_rd_r2 <= '0;
        vsync_rd <= '0;
        vsync_rd_r1 <= '0;
        vsync_rd_r2 <= '0;
        wr_frame_idx <= '0;
        valid_wr_frame <= '0;
        rd_frame_idx <= '0;
    end else begin
        frame_cnt_rd <= frame_cnt;
        frame_cnt_rd_r1 <= frame_cnt_rd;
        frame_cnt_rd_r2 <= frame_cnt_rd_r1;
        vsync_rd <= rd_vsync;
        vsync_rd_r1 <= vsync_rd;
        vsync_rd_r2 <= vsync_rd_r1;

        if (frame_cnt_rd_r2 != frame_cnt_rd_r1) begin
            debug_frame_cnt <= debug_frame_cnt + 1;

            if (FRAME_CNT_WID'(wr_frame_idx + 1'b1) == rd_frame_idx) begin //frame buffer (memory) is full, drop this frame
                wr_frame_idx <= wr_frame_idx;
                valid_wr_frame <= 0;
                debug_same_wr <= debug_same_wr + 1;
            end else begin
                wr_frame_idx <= wr_frame_idx + 1'b1;
                valid_wr_frame <= 1;
            end
        end

        if (!vsync_rd_r2 && vsync_rd_r1) begin
            if (FRAME_CNT_WID'(rd_frame_idx + 1'b1) == wr_frame_idx) begin //frame buffer (memory) is empty, use the last frame
                rd_frame_idx <= rd_frame_idx;
                debug_same_rd <= debug_same_rd + 1;
            end else begin
                rd_frame_idx <= rd_frame_idx + 1'b1;
            end
        end
    end
end

endmodule
