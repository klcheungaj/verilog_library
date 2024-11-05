
module apb3_mux #(
    parameter SLAVE_APB_AW = 20,
    parameter MASTER_APB_AW = 10,
    parameter APB_DW = 32,
    parameter NUM_MASTER = 10
) (
    input  wire  [SLAVE_APB_AW-1:0] s_apb3_paddr,
    input  wire                     s_apb3_psel,
    input  wire                     s_apb3_penable,
    output logic                    s_apb3_pready,
    input  wire                     s_apb3_pwrite,
    input  wire  [      APB_DW-1:0] s_apb3_pwdata,
    output logic [      APB_DW-1:0] s_apb3_prdata,
    output logic                    s_apb3_pslverror,

    output wire [MASTER_APB_AW-1:0] m_apb3_paddr    [NUM_MASTER-1:0],
    output wire                     m_apb3_psel     [NUM_MASTER-1:0],
    output wire                     m_apb3_penable  [NUM_MASTER-1:0],
    input  wire                     m_apb3_pready   [NUM_MASTER-1:0],
    output wire                     m_apb3_pwrite   [NUM_MASTER-1:0],
    output wire [       APB_DW-1:0] m_apb3_pwdata   [NUM_MASTER-1:0],
    input  wire [       APB_DW-1:0] m_apb3_prdata   [NUM_MASTER-1:0],
    input  wire                     m_apb3_pslverror[NUM_MASTER-1:0]
);

genvar idx;
localparam SEL_WID = $clog2(NUM_MASTER);

initial begin
    if (SEL_WID + MASTER_APB_AW > SLAVE_APB_AW) begin
        $error(
            "total master port address range is larger than slave port address range. SLAVE_APB_AW: %d, MASTER_APB_AW: %d, NUM_MASTER: %d",
            SLAVE_APB_AW, MASTER_APB_AW, NUM_MASTER);
    end
end

generate
    for (idx = 0; idx < NUM_MASTER; idx = idx + 1) begin
        assign m_apb3_paddr[idx] = s_apb3_paddr[0+:MASTER_APB_AW];
        assign m_apb3_psel[idx] = (s_apb3_paddr[MASTER_APB_AW +: SEL_WID] == idx) ? s_apb3_psel : 1'b0;
        assign m_apb3_penable[idx] = s_apb3_penable;
        assign m_apb3_pwrite[idx] = s_apb3_pwrite;
        assign m_apb3_pwdata[idx] = s_apb3_pwdata;
    end
endgenerate

always_comb begin
    logic [SEL_WID:0] temp;
    s_apb3_pready = 0;
    for (temp = 0; temp < NUM_MASTER; temp = temp + 1) begin
        if (s_apb3_paddr[MASTER_APB_AW +: SEL_WID] == temp[0 +: SEL_WID]) 
            s_apb3_pready = m_apb3_pready[temp[0 +: SEL_WID]];
    end
end

always_comb begin
    logic [SEL_WID:0] temp;
    s_apb3_prdata = 0;
    for (temp = 0; temp < NUM_MASTER; temp = temp + 1) begin
        if (s_apb3_paddr[MASTER_APB_AW +: SEL_WID] == temp[0 +: SEL_WID]) 
            s_apb3_prdata = m_apb3_prdata[temp[0 +: SEL_WID]];
    end
end

always_comb begin
    logic [SEL_WID:0] temp;
    s_apb3_pslverror = 0;
    for (temp = 0; temp < NUM_MASTER; temp = temp + 1) begin
        if (s_apb3_paddr[MASTER_APB_AW +: SEL_WID] == temp[0 +: SEL_WID])
            s_apb3_pslverror = m_apb3_pslverror[temp[0 +: SEL_WID]];
    end
end

endmodule
