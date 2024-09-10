
interface MipiTx4LaneIface;

wire       clk_LP_P_OUT;
wire       clk_LP_N_OUT;
wire [7:0] clk_HS_OUT;
wire       clk_HS_OE;
wire       clk_RST;
wire       d3_RST;
wire       d2_RST;
wire       d1_RST;
wire       d0_RST;
wire [7:0] d0_HS_OUT;
wire [7:0] d1_HS_OUT;
wire [7:0] d2_HS_OUT;
wire [7:0] d3_HS_OUT;
wire       d3_HS_OE;
wire       d2_HS_OE;
wire       d1_HS_OE;
wire       d0_HS_OE;
wire       d3_LP_P_OUT;
wire       d2_LP_P_OUT;
wire       d1_LP_P_OUT;
wire       d0_LP_P_OUT;
wire       d3_LP_N_OUT;
wire       d2_LP_N_OUT;
wire       d1_LP_N_OUT;
wire       d0_LP_N_OUT;
wire       clk_LP_P_OE;
wire       clk_LP_N_OE;
wire       d3_LP_P_OE;
wire       d2_LP_P_OE;
wire       d1_LP_P_OE;
wire       d0_LP_P_OE;
wire       d3_LP_N_OE;
wire       d2_LP_N_OE;
wire       d1_LP_N_OE;
wire       d0_LP_N_OE;

modport mst(
    output clk_LP_P_OUT,
    output clk_LP_N_OUT,
    output clk_HS_OUT,
    output clk_HS_OE,
    output clk_RST,
    output d3_RST,
    output d2_RST,
    output d1_RST,
    output d0_RST,
    output d0_HS_OUT,
    output d1_HS_OUT,
    output d2_HS_OUT,
    output d3_HS_OUT,
    output d3_HS_OE,
    output d2_HS_OE,
    output d1_HS_OE,
    output d0_HS_OE,
    output d3_LP_P_OUT,
    output d2_LP_P_OUT,
    output d1_LP_P_OUT,
    output d0_LP_P_OUT,
    output d3_LP_N_OUT,
    output d2_LP_N_OUT,
    output d1_LP_N_OUT,
    output d0_LP_N_OUT,
    output clk_LP_P_OE,
    output clk_LP_N_OE,
    output d3_LP_P_OE,
    output d2_LP_P_OE,
    output d1_LP_P_OE,
    output d0_LP_P_OE,
    output d3_LP_N_OE,
    output d2_LP_N_OE,
    output d1_LP_N_OE,
    output d0_LP_N_OE
);

modport slv(
    input clk_LP_P_OUT,
    input clk_LP_N_OUT,
    input clk_HS_OUT,
    input clk_HS_OE,
    input clk_RST,
    input d3_RST,
    input d2_RST,
    input d1_RST,
    input d0_RST,
    input d0_HS_OUT,
    input d1_HS_OUT,
    input d2_HS_OUT,
    input d3_HS_OUT,
    input d3_HS_OE,
    input d2_HS_OE,
    input d1_HS_OE,
    input d0_HS_OE,
    input d3_LP_P_OUT,
    input d2_LP_P_OUT,
    input d1_LP_P_OUT,
    input d0_LP_P_OUT,
    input d3_LP_N_OUT,
    input d2_LP_N_OUT,
    input d1_LP_N_OUT,
    input d0_LP_N_OUT,
    input clk_LP_P_OE,
    input clk_LP_N_OE,
    input d3_LP_P_OE,
    input d2_LP_P_OE,
    input d1_LP_P_OE,
    input d0_LP_P_OE,
    input d3_LP_N_OE,
    input d2_LP_N_OE,
    input d1_LP_N_OE,
    input d0_LP_N_OE
);

endinterface
