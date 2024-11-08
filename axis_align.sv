
/**
 * cases: 
 *  1: tkeep all 1
 *  2: tkeep all 1, one cycle tlast
 *  3: tkeep not all 1
 *  4: tkeep not all 1, one cycle tlast
 */
module axis_align #(
    parameter AXIS_DW = 64,
    parameter AXIS_KW = ((AXIS_DW-1)>>3)+1
) (
    input                      clk,
    input                      rst,
    input                      s_axis_tvalid,   // @warning: assume s_tvalid is continuous during a burst
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
    input logic [AXIS_KW-1:0] cur_tkeep,// @warning: assume kept bit start from MS bit, e.g. 4'b1100 or 4'b1111
    input logic [AXIS_KW-1:0] new_tkeep // @warning: assume kept bit start from LS bit, e.g. 4'b0011 or 4'b1111
);
automatic logic [AXIS_DW*2-1:0] in_tdata = {new_tdata, cur_tdata};
automatic logic [AXIS_KW*2-1:0] in_tkeep = {new_tkeep, cur_tkeep};
automatic logic [AXIS_DW*2-1:0] out_tdata = in_tdata;
automatic logic [AXIS_KW*2-1:0] out_tkeep = in_tkeep;

for (int i=0 ; i<AXIS_KW*2 ; i++) begin
    if (out_tkeep[0] == 1'b0) begin
        out_tkeep = {1'b0, out_tkeep[1 +: AXIS_KW*2-1]};
        out_tdata = {8'b0, out_tdata[8 +: AXIS_DW*2-8]};
    end else begin
        break;
    end
end
return {out_tkeep, out_tdata};
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

assign m_axis_tvalid = r_tlast || r_tkeep == '1 || r_valid_override;
assign m_axis_tlast = r_tkeep_remain == '0 && r_tlast;
assign s_axis_tready = state == IDLE || (state == ACTIVE && !m_axis_tvalid) || m_beat_valid;
assign m_axis_tkeep = r_tkeep[0 +: AXIS_KW];
assign m_axis_tdata = r_tdata[0 +: AXIS_DW];

always_ff @(posedge clk) begin
    if (rst) begin
        r_tkeep_remain <= '0;
        r_tkeep <= '0;
        r_tdata_remain <= '0;
        r_tdata <= '0;
        r_tlast <= '0;
    end else begin
        if (m_beat_valid) begin
            {r_tkeep_remain, r_tkeep, r_tdata_remain, r_tdata} <= 
                shift(r_tdata_remain, s_axis_tdata, r_tkeep_remain, s_axis_tkeep);
            r_tlast <= s_axis_tlast;
        end else if (!m_axis_tvalid) begin
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
