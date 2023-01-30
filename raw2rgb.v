/////////////////////////////////////////////////////////////////////////////
//
// Raw to RGB with an internal buffer
// For pixel count larger than 1, the data valid signal should not be continuous. e.g. IN_PCNT = 2:
// i_valid: 1  0  1  0  1  0  1 
// i_data : RG    RG    RG    RG
//
//********************************
// Revisions:
// 1.0 Initial rev
 
module raw2rgb
#(
    parameter   PW          = 8,     //width of a pixel channel 
    parameter   IN_PCNT     = 2,     //input pixel count of a data valid, should be power of 2
    parameter   OUT_PCNT    = 2,     //output pixel count of a data valid, should be power of 2
    parameter   AW          = 11,    //maximum width of x address        
    parameter   FORMAT      = "RGGB" //bayer filter format
) (
    input                       i_pclk, //system pixel clock. 1 cycle = 1 pixel
    input                       i_arstn,

    input                       i_vsync,
    input                       i_hsync,
    input                       i_de,
    input                       i_valid,
    input [PW*IN_PCNT-1:0]      i_data,

    output                      o_vsync,
    output                      o_hsync,
    output                      o_de,
    output                      o_valid,
    output [PW*3*OUT_PCNT-1:0]  o_data,
    output [AW-1:0]             o_x,
    output [AW-1:0]             o_y
);

wire                  w_vsync;
wire                  w_hsync;
wire                  w_de;
wire                  w_valid;
wire [PW-1:0]         w_d0;
wire [PW-1:0]         w_d1;
wire [PW-1:0]         w_d2;
wire [PW-1:0]         w_d3;
wire [PW-1:0]         w_d4;
wire [AW-1:0]         w_x;
wire [AW-1:0]         w_y;
lineBuffer #(
    .PW(8),
    .IN_PCNT(2),
    .OUT_PCNT(2),
    .AW(11)
) inst_lineBuffer (
    .i_pclk (i_pclk),
    .i_arstn(i_arstn),
    
    .i_vsync(i_vsync),
    .i_hsync(i_hsync),
    .i_de   (i_de),
    .i_valid(i_valid),
    .i_data (i_data),

    .o_vsync(w_vsync),
    .o_hsync(w_hsync),
    .o_de   (w_de),
    .o_valid(w_valid),
    .o_d0   (w_d0),
    .o_d1   (w_d1),
    .o_d2   (w_d2),
    .o_d3   (w_d3),
    .o_d4   (w_d4),
    .o_x    (w_x),
    .o_y    (w_y)
);



endmodule
