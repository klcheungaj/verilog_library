


interface DphyTx4LaneIface;

logic               SLOWCLK;      //312.5MHz from PLL for HS Byte clk
logic               RESET_N;
logic               STOPSTATE_CLK;
logic               TX_REQUEST_HS;
logic               TX_ULPS_CLK;
logic               TX_ULPS_EXIT;
logic               TX_ULPS_ACTIVE_CLK_NOT;
logic               TX_ULPS_ESC_LAN0;
logic               TX_ULPS_ESC_LAN1;
logic               TX_ULPS_ESC_LAN2;
logic               TX_ULPS_ESC_LAN3;
logic               TX_ULPS_EXIT_LAN0;
logic               TX_ULPS_EXIT_LAN1;
logic               TX_ULPS_EXIT_LAN2;
logic               TX_ULPS_EXIT_LAN3;
logic               TX_ULPS_ACTIVE_NOT_LAN0;
logic               TX_ULPS_ACTIVE_NOT_LAN1;
logic               TX_ULPS_ACTIVE_NOT_LAN2;
logic               TX_ULPS_ACTIVE_NOT_LAN3;
logic               TX_REQUEST_ESC_LAN0;
logic               TX_REQUEST_ESC_LAN1;
logic               TX_REQUEST_ESC_LAN2;
logic               TX_REQUEST_ESC_LAN3;
logic               TX_SKEW_CAL_HS_LAN0;
logic               TX_SKEW_CAL_HS_LAN1;
logic               TX_SKEW_CAL_HS_LAN2;
logic               TX_SKEW_CAL_HS_LAN3;
logic               STOPSTATE_LAN0;
logic               STOPSTATE_LAN1;
logic               STOPSTATE_LAN2;
logic               STOPSTATE_LAN3;
logic               TX_READY_HS_LAN0;
logic               TX_READY_HS_LAN1;
logic               TX_READY_HS_LAN2;
logic               TX_READY_HS_LAN3;
logic               TX_REQUEST_HS_LAN0;
logic               TX_REQUEST_HS_LAN1;
logic               TX_REQUEST_HS_LAN2;
logic               TX_REQUEST_HS_LAN3;
logic   [15:0]          TX_DATA_HS_LAN0;
logic   [15:0]          TX_DATA_HS_LAN1;
logic   [15:0]          TX_DATA_HS_LAN2;
logic   [15:0]          TX_DATA_HS_LAN3;
logic               TX_WORD_VALID_HS_LAN0;
logic               TX_WORD_VALID_HS_LAN1;
logic               TX_WORD_VALID_HS_LAN2;
logic               TX_WORD_VALID_HS_LAN3;
logic               TX_LPDT_ESC;
logic               TX_VALID_ESC; 
logic               PLL_SSC_EN; 
logic [3:0]         TX_TRIGGER_ESC;
logic [7:0]         TX_DATA_ESC;
// logic               LPDT_TX_ENTER;
// logic [3:0]         SEND_TRIGGER;
// logic [7:0]         LPDT_TX_DATA;
// logic               LPDT_TX_VALID;
// logic               FORCE_RX;
// logic               TURNAROUND_REQ;
// logic               TURN_REQUEST;
// logic               FORCE_RX_MODE;

modport mst(
    input        SLOWCLK,      //312.5MHz from PLL for HS Byte clk
    output       RESET_N,
    input        STOPSTATE_CLK,
    output       TX_REQUEST_HS,
    output       TX_ULPS_CLK,
    output       TX_ULPS_EXIT,
    input        TX_ULPS_ACTIVE_CLK_NOT,
    output       TX_ULPS_ESC_LAN0,
    output       TX_ULPS_ESC_LAN1,
    output       TX_ULPS_ESC_LAN2,
    output       TX_ULPS_ESC_LAN3,
    output       TX_ULPS_EXIT_LAN0,
    output       TX_ULPS_EXIT_LAN1,
    output       TX_ULPS_EXIT_LAN2,
    output       TX_ULPS_EXIT_LAN3,
    input        TX_ULPS_ACTIVE_NOT_LAN0,
    input        TX_ULPS_ACTIVE_NOT_LAN1,
    input        TX_ULPS_ACTIVE_NOT_LAN2,
    input        TX_ULPS_ACTIVE_NOT_LAN3,
    output       TX_REQUEST_ESC_LAN0,
    output       TX_REQUEST_ESC_LAN1,
    output       TX_REQUEST_ESC_LAN2,
    output       TX_REQUEST_ESC_LAN3,
    output       TX_SKEW_CAL_HS_LAN0,
    output       TX_SKEW_CAL_HS_LAN1,
    output       TX_SKEW_CAL_HS_LAN2,
    output       TX_SKEW_CAL_HS_LAN3,
    input        STOPSTATE_LAN0,
    input        STOPSTATE_LAN1,
    input        STOPSTATE_LAN2,
    input        STOPSTATE_LAN3,
    input        TX_READY_HS_LAN0,
    input        TX_READY_HS_LAN1,
    input        TX_READY_HS_LAN2,
    input        TX_READY_HS_LAN3,
    output       TX_REQUEST_HS_LAN0,
    output       TX_REQUEST_HS_LAN1,
    output       TX_REQUEST_HS_LAN2,
    output       TX_REQUEST_HS_LAN3,
    output        TX_DATA_HS_LAN0,
    output        TX_DATA_HS_LAN1,
    output        TX_DATA_HS_LAN2,
    output        TX_DATA_HS_LAN3,
    output       TX_WORD_VALID_HS_LAN0,
    output       TX_WORD_VALID_HS_LAN1,
    output       TX_WORD_VALID_HS_LAN2,
    output       TX_WORD_VALID_HS_LAN3,
    output    TX_LPDT_ESC,
    output    TX_VALID_ESC,
    output    PLL_SSC_EN,
    output    TX_TRIGGER_ESC,
    output    TX_DATA_ESC
    // output    LPDT_TX_ENTER,
    // output    SEND_TRIGGER,
    // output    LPDT_TX_DATA,
    // output    LPDT_TX_VALID,
    // output    FORCE_RX,
    // output    TURNAROUND_REQ,
    // output    TURN_REQUEST,
    // output    FORCE_RX_MODE
);


endinterface
