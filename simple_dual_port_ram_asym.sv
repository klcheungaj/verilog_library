/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2018 Efinix Inc. All rights reserved.
//
// Single RAM block
//
// *******************************
// Revisions:
// 0.0 Initial rev
// 0.1 Added output register
// 1.0 Finalized RTL macro
// *******************************

module simple_dual_port_ram_asym
#(
    parameter WR_ADDR_WIDTH    = 9,
    parameter WR_DATA_WIDTH    = 8,
    parameter RD_ADDR_WIDTH    = 9,
    parameter RD_DATA_WIDTH    = 8,
    parameter OUTPUT_REG    = "TRUE",
    parameter RAM_INIT_FILE = "",
    parameter RAM_INIT_RADIX= "HEX"
)
(
    input [(WR_DATA_WIDTH-1):0] wdata,
    input [(WR_ADDR_WIDTH-1):0] waddr,
    input [(RD_ADDR_WIDTH-1):0] raddr,
    input we, wclk, re, rclk,
    output [(RD_DATA_WIDTH-1):0] rdata
);

    localparam RAM_ADDR_WIDTH = WR_ADDR_WIDTH > RD_ADDR_WIDTH ? WR_ADDR_WIDTH : RD_ADDR_WIDTH;
    localparam RAM_DATA_WIDTH = WR_DATA_WIDTH < RD_DATA_WIDTH ? WR_DATA_WIDTH : RD_DATA_WIDTH;
    localparam MEMORY_DEPTH = 2**RAM_ADDR_WIDTH;
    localparam MAX_DATA = (1<<RAM_ADDR_WIDTH)-1;

    reg [RAM_DATA_WIDTH-1:0] ram[MEMORY_DEPTH-1:0];
    reg [RD_DATA_WIDTH-1:0] r_rdata_1P = '0;
    reg [RD_DATA_WIDTH-1:0] r_rdata_2P = '0;

    initial
    begin
    // By default the Efinix memory will initialize to 0
        if (RAM_INIT_FILE != "") begin
            if (RAM_INIT_RADIX == "BIN")
                $readmemb(RAM_INIT_FILE, ram);
            else
                $readmemh(RAM_INIT_FILE, ram);
        end else begin
            ram = '{default:'0};
        end
    end

    always @ (posedge wclk) begin
        // if (we) begin
        //     if (WR_ADDR_WIDTH == RAM_ADDR_WIDTH) begin
        //         ram[waddr] <= wdata;
        //     end else begin
        //         for (integer i=0 ; i<RAM_ADDR_WIDTH)
        //     end
        // end
        if (we) begin
            for (integer i=0 ; i<WR_DATA_WIDTH / RAM_DATA_WIDTH ; i=i+1) begin
                ram[waddr*(WR_DATA_WIDTH / RAM_DATA_WIDTH) + i] <= wdata[i*RAM_DATA_WIDTH +: RAM_DATA_WIDTH];
            end
        end
    end

    always @ (posedge rclk) begin
        // if (re) begin
        //     if (RD_ADDR_WIDTH == RAM_ADDR_WIDTH) begin
        //         r_rdata_1P <= ram[raddr];                
        //     end else begin

        //     end
        // end
        if (re) begin
            for (integer i=0 ; i<RD_DATA_WIDTH / RAM_DATA_WIDTH ; i=i+1) begin
                r_rdata_1P[i*RAM_DATA_WIDTH +: RAM_DATA_WIDTH] <= ram[raddr*(RD_DATA_WIDTH / RAM_DATA_WIDTH) + i];
            end
        end
        r_rdata_2P <= r_rdata_1P;
    end

    generate
        if (OUTPUT_REG == "TRUE")
            assign  rdata = r_rdata_2P;
        else
            assign  rdata = r_rdata_1P;
    endgenerate

endmodule

