
`timescale 1ns/10ps

`define SETUP #0.5

/**
 * @warning this module supports following cases only:
 *          1. bit of 1st beat start from MS bit, e.g. 4'b1100 or 4'b1111
 *          2. bit of last beat start from LS bit, e.g. 4'b0011 or 4'b1111
 *          3. s_tvalid is continuous aligned or unaligned. Sparse tkeep (e.g. 4'b1010) is not supported
 */
module axis_align #(
    parameter AXIS_DW = 64,
    parameter AXIS_KW = ((AXIS_DW-1)>>3)+1
) (
    input                      clk,
    input                      rst,
    input                      s_axis_tvalid,
    output                     s_axis_tready,
    input  [AXIS_DW-1:0]       s_axis_tdata,
    input  [AXIS_KW-1:0]       s_axis_tkeep,
    input                      s_axis_tlast,

    output logic               m_axis_tvalid,
    input                      m_axis_tready,
    output logic [AXIS_DW-1:0] m_axis_tdata,
    output logic [AXIS_KW-1:0] m_axis_tkeep,
    output logic               m_axis_tlast
);

function logic [AXIS_DW*2+AXIS_KW*2-1:0] shift (
    input logic [AXIS_DW-1:0] cur_tdata,
    input logic [AXIS_DW-1:0] new_tdata, 
    input logic [AXIS_KW-1:0] cur_tkeep,
    input logic [AXIS_KW-1:0] new_tkeep 
);
    logic [AXIS_DW*2-1:0] temp_tdata;
    logic [AXIS_KW*2-1:0] temp_tkeep;
    logic [AXIS_DW-1:0] out_tdata;
    logic [AXIS_KW-1:0] out_tkeep;
    logic [AXIS_DW-1:0] remain_tdata;
    logic [AXIS_KW-1:0] remain_tkeep;
    logic [$clog2(AXIS_KW):0] one_count;
    logic [$clog2(AXIS_KW*2):0] idx;
    temp_tdata = {new_tdata, cur_tdata};
    temp_tkeep = {new_tkeep, cur_tkeep};

    for (idx=0 ; idx<AXIS_KW ; idx=idx+1) begin
        if (temp_tkeep[0] == 1'b0) begin
            temp_tkeep = temp_tkeep >> 1;
            temp_tdata = temp_tdata >> 8; 
        end else begin
            temp_tkeep = temp_tkeep;
            temp_tdata = temp_tdata;
        end
    end

    out_tdata = temp_tdata[0 +: AXIS_DW];
    out_tkeep = temp_tkeep[0 +: AXIS_KW];
    temp_tdata = {new_tdata, cur_tdata};
    temp_tkeep = {new_tkeep, cur_tkeep};

    for (idx=0 ; idx<AXIS_KW ; idx=idx+1) begin
        if (temp_tkeep[AXIS_KW*2-1] == 1'b0) begin
            temp_tkeep = temp_tkeep << 1;
            temp_tdata = temp_tdata << 8; 
        end else begin
            temp_tkeep = temp_tkeep;
            temp_tdata = temp_tdata;
        end
    end
    remain_tdata = temp_tdata[AXIS_DW +: AXIS_DW];
    remain_tkeep = temp_tkeep[0 +: AXIS_KW];
    return {remain_tkeep, out_tkeep, remain_tdata, out_tdata};
endfunction

typedef enum logic [1:0] {
    IDLE,
    ACTIVE,
    WAIT_M
} state_t;

logic [AXIS_DW-1:0] r_tdata = '0;
logic [AXIS_DW-1:0] r_tdata_remain = '0;
logic [AXIS_KW-1:0] r_tkeep = '0;
logic [AXIS_KW-1:0] r_tkeep_remain = '0;
logic               r_tlast = '0;
logic               r_valid_override = '0;
wire                s_beat_valid = s_axis_tvalid && s_axis_tready;
wire                m_beat_valid = m_axis_tvalid && m_axis_tready;
state_t state = IDLE;

assign `SETUP s_axis_tready = (state == IDLE || (state == ACTIVE && !m_axis_tvalid) || m_beat_valid) && !r_tlast;
assign `SETUP m_axis_tvalid = m_axis_tlast || r_tkeep == '1 || r_valid_override;
assign `SETUP m_axis_tkeep = r_tkeep[0 +: AXIS_KW];
assign `SETUP m_axis_tdata = r_tdata[0 +: AXIS_DW];
assign `SETUP m_axis_tlast = r_tkeep_remain == '0 && r_tlast;
always_ff @(posedge clk) begin
    if (rst) begin
        r_tkeep_remain <= '0;
        r_tkeep <= '0;
        r_tdata_remain <= '0;
        r_tdata <= '0;
        r_tlast <= '0;
    end else begin
        if (m_beat_valid) begin
            if (s_beat_valid) begin
                {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= 
                    shift(r_tdata_remain, s_axis_tdata, r_tkeep_remain, s_axis_tkeep);
            end else if (m_axis_tlast) begin
                {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= '0;
            end else if (r_tlast) begin
                {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= 
                    shift(r_tdata_remain, '0, r_tkeep_remain, '0);
            end else begin
                {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= 
                    shift('0, r_tdata_remain, '0, r_tkeep_remain);
            end

            if (m_beat_valid && m_axis_tlast) begin
                r_tlast <= '0;
            end else if (s_beat_valid) begin
                r_tlast <= s_axis_tlast;
            end
        end else if (!m_axis_tvalid && s_beat_valid) begin
            {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= 
                shift(r_tdata, s_axis_tdata, r_tkeep, s_axis_tkeep);
            r_tlast <= s_axis_tlast;
        end
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        r_valid_override <= 0;
    end else begin
        case (state)
        IDLE: begin
            if (s_beat_valid) begin
                state <= ACTIVE;
            end
        end

        ACTIVE: begin
            if (m_beat_valid) begin 
                if (m_axis_tlast) begin
                    state <= IDLE;
                end
            end else if (m_axis_tvalid && !m_axis_tready) begin
                r_valid_override <= 1;
                state <= WAIT_M;
            end
        end

        WAIT_M: begin
            if (m_beat_valid) begin 
                r_valid_override <= 0;
                if (m_axis_tlast) begin
                    state <= IDLE;
                end else begin
                    state <= ACTIVE;
                end
            end
        end

        default: state <= IDLE;
        endcase
    end
end

endmodule
