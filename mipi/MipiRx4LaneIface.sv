
interface MipiRx4LaneIface;

wire        clk_CLKOUT;
wire        clk_LP_P_IN;
wire        clk_LP_N_IN;
wire        clk_HS_TERM;
wire        clk_HS_ENA;

wire [7:0]  d0_HS_IN;
wire        d0_LP_P_IN;
wire        d0_LP_N_IN;
wire        d0_FIFO_EMPTY;
wire [7:0]  d1_HS_IN;
wire        d1_LP_P_IN;
wire        d1_LP_N_IN;
wire        d1_FIFO_EMPTY;
wire [7:0]  d2_HS_IN;
wire        d2_LP_P_IN;
wire        d2_LP_N_IN;
wire        d2_FIFO_EMPTY;
wire [7:0]  d3_HS_IN;
wire        d3_LP_P_IN;
wire        d3_LP_N_IN;
wire        d3_FIFO_EMPTY;

wire        d0_RST;
wire        d0_FIFO_RD;
wire        d0_HS_TERM;
wire        d0_HS_ENA;
wire        d1_RST;
wire        d1_FIFO_RD;
wire        d1_HS_TERM;
wire        d1_HS_ENA;
wire        d2_RST;
wire        d2_FIFO_RD;
wire        d2_HS_TERM;
wire        d2_HS_ENA;
wire        d3_RST;
wire        d3_FIFO_RD;
wire        d3_HS_TERM;
wire        d3_HS_ENA;

modport mst(
    output      clk_CLKOUT,
    output      clk_LP_P_IN,
    output      clk_LP_N_IN,
    input       clk_HS_TERM,
    input       clk_HS_ENA,

    output      d0_HS_IN,
    output      d0_LP_P_IN,
    output      d0_LP_N_IN,
    output      d0_FIFO_EMPTY,
    output      d1_HS_IN,
    output      d1_LP_P_IN,
    output      d1_LP_N_IN,
    output      d1_FIFO_EMPTY,
    output      d2_HS_IN,
    output      d2_LP_P_IN,
    output      d2_LP_N_IN,
    output      d2_FIFO_EMPTY,
    output      d3_HS_IN,
    output      d3_LP_P_IN,
    output      d3_LP_N_IN,
    output      d3_FIFO_EMPTY,

    input       d0_RST,
    input       d0_FIFO_RD,
    input       d0_HS_TERM,
    input       d0_HS_ENA,
    input       d1_RST,
    input       d1_FIFO_RD,
    input       d1_HS_TERM,
    input       d1_HS_ENA,
    input       d2_RST,
    input       d2_FIFO_RD,
    input       d2_HS_TERM,
    input       d2_HS_ENA,
    input       d3_RST,
    input       d3_FIFO_RD,
    input       d3_HS_TERM,
    input       d3_HS_ENA
);

modport slv (
    input       clk_CLKOUT,
    input       clk_LP_P_IN,
    input       clk_LP_N_IN,
    output      clk_HS_TERM,
    output      clk_HS_ENA,

    input       d0_HS_IN,
    input       d0_LP_P_IN,
    input       d0_LP_N_IN,
    input       d0_FIFO_EMPTY,
    input       d1_HS_IN,
    input       d1_LP_P_IN,
    input       d1_LP_N_IN,
    input       d1_FIFO_EMPTY,
    input       d2_HS_IN,
    input       d2_LP_P_IN,
    input       d2_LP_N_IN,
    input       d2_FIFO_EMPTY,
    input       d3_HS_IN,
    input       d3_LP_P_IN,
    input       d3_LP_N_IN,
    input       d3_FIFO_EMPTY,

    output      d0_RST,
    output      d0_FIFO_RD,
    output      d0_HS_TERM,
    output      d0_HS_ENA,
    output      d1_RST,
    output      d1_FIFO_RD,
    output      d1_HS_TERM,
    output      d1_HS_ENA,
    output      d2_RST,
    output      d2_FIFO_RD,
    output      d2_HS_TERM,
    output      d2_HS_ENA,
    output      d3_RST,
    output      d3_FIFO_RD,
    output      d3_HS_TERM,
    output      d3_HS_ENA
);

endinterface
