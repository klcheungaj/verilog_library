

interface DphyRx4LaneIface;


// PPI DPHY RX IF
// output  logic       ESC_CLK,
logic       SLOWCLK;   //312.5MHz from RX CLK lane for HS Byte clk
logic       RESET_N;   //active low async reset to RX DPHY
logic       RST0_N; // active low async reset to FIFO
logic       RX_ULPS_ACTIVE_CLK_NOT;
logic       RX_ULPS_CLK_NOT;
logic       ESC_LAN0_CLK;
logic       ESC_LAN1_CLK;
logic       ESC_LAN2_CLK;
logic       ESC_LAN3_CLK;
logic       LINESTATE_LAN0_ERROR;
logic       LINESTATE_LAN1_ERROR;
logic       LINESTATE_LAN2_ERROR;
logic       LINESTATE_LAN3_ERROR;
logic       STOPSTATE_LAN0;
logic       STOPSTATE_LAN1;
logic       STOPSTATE_LAN2;
logic       STOPSTATE_LAN3;
logic       ERR_ESC_LAN0;
logic       ERR_ESC_LAN1;
logic       ERR_ESC_LAN2;
logic       ERR_ESC_LAN3;
logic       RX_VALID_HS_LAN0;
logic       RX_VALID_HS_LAN1;
logic       RX_VALID_HS_LAN2;
logic       RX_VALID_HS_LAN3;
logic   [15:0]   RX_DATA_HS_LAN0;
logic   [15:0]   RX_DATA_HS_LAN1;
logic   [15:0]   RX_DATA_HS_LAN2;
logic   [15:0]   RX_DATA_HS_LAN3;
logic       RX_SKEW_CAL_HS_LAN0;
logic       RX_SKEW_CAL_HS_LAN1;
logic       RX_SKEW_CAL_HS_LAN2;
logic       RX_SKEW_CAL_HS_LAN3;
logic       RX_SYNC_HS_LAN0;
logic       RX_SYNC_HS_LAN1;
logic       RX_SYNC_HS_LAN2;
logic       RX_SYNC_HS_LAN3;
logic       ERR_SOT_SYNC_HS_LAN0;
logic       ERR_SOT_SYNC_HS_LAN1;
logic       ERR_SOT_SYNC_HS_LAN2;
logic       ERR_SOT_SYNC_HS_LAN3;
logic       RX_ULPS_ACTIVE_NOT_LAN0;
logic       RX_ULPS_ACTIVE_NOT_LAN1;
logic       RX_ULPS_ACTIVE_NOT_LAN2;
logic       RX_ULPS_ACTIVE_NOT_LAN3;
logic       RX_ULPS_ESC_LAN0;
logic       RX_ULPS_ESC_LAN1;
logic       RX_ULPS_ESC_LAN2;
logic       RX_ULPS_ESC_LAN3;
// logic         FORCE_RX;
// logic         REQUEST_TX_ESC;
// logic [7:0]   LPDT_TX_DATA;
// logic         LPDT_TX_ENTER;
// logic         LPDT_TX_VALID;
// logic [3:0]   SEND_TRIGGER;
// logic         TURNAROUND_REQ;
// logic         ULPS_TX_ENTER;
// logic         ULPS_TX_EXIT;
// logic         TURN_REQUEST;
// logic         TX_REQUEST_ESC;
// logic         TX_LPDT_ESC;
// logic         TX_ULPS_EXIT;
// logic [3:0]   TX_TRIGGER_ESC;
// logic [7:0]   TX_DATA_ESC;
// logic         TX_VALID_ESC;
logic         FORCE_RX_MODE;
// logic         TX_ULPS_ESC;

modport slv(
    input   SLOWCLK,   //312.5MHz from RX CLK lane for HS Byte clk
    output  RESET_N,   //active low async reset to RX DPHY
    output  RST0_N,  // active low async reset to FIFO
    input   RX_ULPS_ACTIVE_CLK_NOT,
    input   RX_ULPS_CLK_NOT,
    input   ESC_LAN0_CLK,
    input   ESC_LAN1_CLK,
    input   ESC_LAN2_CLK,
    input   ESC_LAN3_CLK,
    input   LINESTATE_LAN0_ERROR,
    input   LINESTATE_LAN1_ERROR,
    input   LINESTATE_LAN2_ERROR,
    input   LINESTATE_LAN3_ERROR,
    input   STOPSTATE_LAN0,
    input   STOPSTATE_LAN1,
    input   STOPSTATE_LAN2,
    input   STOPSTATE_LAN3,
    input   ERR_ESC_LAN0,
    input   ERR_ESC_LAN1,
    input   ERR_ESC_LAN2,
    input   ERR_ESC_LAN3,
    input   RX_VALID_HS_LAN0,
    input   RX_VALID_HS_LAN1,
    input   RX_VALID_HS_LAN2,
    input   RX_VALID_HS_LAN3,
    input   RX_DATA_HS_LAN0,
    input   RX_DATA_HS_LAN1,
    input   RX_DATA_HS_LAN2,
    input   RX_DATA_HS_LAN3,
    input   RX_SKEW_CAL_HS_LAN0,
    input   RX_SKEW_CAL_HS_LAN1,
    input   RX_SKEW_CAL_HS_LAN2,
    input   RX_SKEW_CAL_HS_LAN3,
    input   RX_SYNC_HS_LAN0,
    input   RX_SYNC_HS_LAN1,
    input   RX_SYNC_HS_LAN2,
    input   RX_SYNC_HS_LAN3,
    input   ERR_SOT_SYNC_HS_LAN0,
    input   ERR_SOT_SYNC_HS_LAN1,
    input   ERR_SOT_SYNC_HS_LAN2,
    input   ERR_SOT_SYNC_HS_LAN3,
    input   RX_ULPS_ACTIVE_NOT_LAN0,
    input   RX_ULPS_ACTIVE_NOT_LAN1,
    input   RX_ULPS_ACTIVE_NOT_LAN2,
    input   RX_ULPS_ACTIVE_NOT_LAN3,
    input   RX_ULPS_ESC_LAN0,
    input   RX_ULPS_ESC_LAN1,
    input   RX_ULPS_ESC_LAN2,
    input   RX_ULPS_ESC_LAN3,
    // output   FORCE_RX,
    // output   REQUEST_TX_ESC,
    // output   LPDT_TX_DATA,
    // output   LPDT_TX_ENTER,
    // output   LPDT_TX_VALID,
    // output   SEND_TRIGGER,
    // output   TURNAROUND_REQ,
    // output   ULPS_TX_ENTER,
    // output   ULPS_TX_EXIT,
    // output   TURN_REQUEST,
    // output   TX_REQUEST_ESC,
    // output   TX_LPDT_ESC,
    // output   TX_ULPS_EXIT,
    // output   TX_TRIGGER_ESC,
    // output   TX_DATA_ESC,
    // output   TX_VALID_ESC,
    output   FORCE_RX_MODE
    // output   TX_ULPS_ESC
);

endinterface
