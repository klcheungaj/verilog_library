
`timescale 1ns/100ps

`include "true_dual_port_ram.v"
`include "ram_3dlut.sv"

module ram_3dlut_tb();

parameter GS = 33;
parameter LUT_CD = 8;
localparam IDX_BIT = $clog2(GS);

logic clk = 0;
logic rstn = 0;
logic [LUT_CD*3-1:0]  cfg_data;
logic                 cfg_valid;
logic                 cfg_last;

logic                 in_valid;
wire                  w_valid;
logic  [ IDX_BIT-1:0] p0_idx_r;
logic  [ IDX_BIT-1:0] p0_idx_g;
logic  [ IDX_BIT-1:0] p0_idx_b;
wire   [LUT_CD*3-1:0] w_p0_nbr  [7:0];
logic  [ IDX_BIT-1:0] p1_idx_r;
logic  [ IDX_BIT-1:0] p1_idx_g;
logic  [ IDX_BIT-1:0] p1_idx_b;
wire   [LUT_CD*3-1:0] w_p1_nbr  [7:0];

always #1 clk = !clk;

ram_3dlut #(
    .GS(GS),
    .LUT_CD(LUT_CD)
) dut (
    .clk(clk),
    .rstn(rstn),

    .i_valid(in_valid),
    .o_valid(w_valid),
    .i_p0_idx_r(p0_idx_r),
    .i_p0_idx_g(p0_idx_g),
    .i_p0_idx_b(p0_idx_b),
    .o_p0_nbr(w_p0_nbr),
    .i_p1_idx_r(p1_idx_r),
    .i_p1_idx_g(p1_idx_g),
    .i_p1_idx_b(p1_idx_b),
    .o_p1_nbr(w_p1_nbr),

    .i_cfg_data(cfg_data),
    .i_cfg_valid(cfg_valid),
    .i_cfg_last(cfg_last)
);

initial begin
    rstn = 0;
    in_valid = 0;
    cfg_data = 0;
    cfg_valid = 0;
    cfg_last = 0;
    p0_idx_r = 0;
    p0_idx_g = 0;
    p0_idx_b = 0;
    p1_idx_r = 0;
    p1_idx_g = 0;
    p1_idx_b = 0;
    #10
    rstn = 1;
    #10
    init_3dlut();
    #10
    seq_read();
    $display("[INFO] SUCCESS. Sequential Read Test done");
    #10
    rand_read();
    $display("[INFO] SUCCESS. Random Read Test done");
    #10
    $display("[INFO] SUCCESS. Simulation End");
    $stop();
end

task init_3dlut();
    static int i=0;
    for (i=0 ; i<GS**3 ; i=i+1) begin
        @(negedge clk)
        cfg_data = i;
        cfg_valid = 1;
        cfg_last = i == (GS**3) - 1;
    end
    @(negedge clk)
    cfg_valid = 0;
    cfg_last = 0;
endtask

task seq_read();
    for (int i=0 ; i<GS ; i=i+1) begin
        for (int j=0 ; j<GS ; j=j+1) begin
            for (int k=0 ; k<GS ; k=k+1) begin
                @(negedge clk)
                p0_idx_r = k;
                p0_idx_g = j;
                p0_idx_b = i;
                p1_idx_r = j;
                p1_idx_g = i;
                p1_idx_b = k;
                in_valid = 1;
                $display("[INFO] %0d ns: Port 0 - red index: %d, green index: %d, blue index: ", $time(), p0_idx_r, p0_idx_g, p0_idx_b);
                $display("[INFO] %0d ns: Port 1 - red index: %d, green index: %d, blue index: ", $time(), p1_idx_r, p1_idx_g, p1_idx_b);
            end
        end
    end
    @(negedge clk) begin
        in_valid = 0;
    end
endtask

task rand_read();
    for (int i=0 ; i<(GS**3)*2 ; i=i+1) begin
        @(negedge clk)
        p0_idx_r = $urandom() % GS; 
        p0_idx_g = $urandom() % GS; 
        p0_idx_b = $urandom() % GS; 
        p1_idx_r = $urandom() % GS; 
        p1_idx_g = $urandom() % GS; 
        p1_idx_b = $urandom() % GS; 
        in_valid = 1;
        $display("[INFO] %0d ns: Port 0 - red index: %d, green index: %d, blue index: ", $time(), p0_idx_r, p0_idx_g, p0_idx_b);
        $display("[INFO] %0d ns: Port 1 - red index: %d, green index: %d, blue index: ", $time(), p1_idx_r, p1_idx_g, p1_idx_b);
    end
    @(negedge clk) begin
        in_valid = 0;
    end
endtask

property nbr_value_gssub1(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && (b != GS - 1) && (g != GS - 1) && (r != GS - 1) ,idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_rmax(i, r, g, b, nbr); // when channel = MAX, ch+1 is not ignored as no interpolation is needed 
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b001 && (i[0] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_gmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b010 && (i[1] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_bmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b100 && (i[2] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_bgmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b110 && (i[1] == 0 && i[2] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_rbmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b101 && (i[0] == 0 && i[2] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_grmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b011 && (i[0] == 0 && i[1] == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

property nbr_value_allmax(i, r, g, b, nbr);
    int idx_r, idx_g, idx_b;
    logic [2:0] max_comb = {b == GS - 1, g == GS - 1, r == GS - 1}; 
    @(posedge clk) (in_valid && max_comb == 3'b111 && (i == 0),idx_r=r, idx_g=g, idx_b=b) 
        |-> ##2 nbr == (idx_b + i[2])*(GS**2) + (idx_g + i[1])*(GS) + (idx_r + i[0]);
endproperty 

generate
    for (genvar idx = 0; idx < 8; idx++) begin : assert_array
        assert property(nbr_value_gssub1(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))
        else begin
            $display("[ERROR] Assertion failed! Wrong neighbour point output at index %0d. Port 0 - R: %d, G: %d, B: %d", idx, p0_idx_r, p0_idx_g, p0_idx_b);
        end
        assert property(nbr_value_rmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_rmax", $time());
        assert property(nbr_value_gmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_gmax", $time());
        assert property(nbr_value_bmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_bmax", $time());
        assert property(nbr_value_bgmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_bgmax", $time());
        assert property(nbr_value_rbmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_rbmax", $time());
        assert property(nbr_value_grmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_grmax", $time());
        assert property(nbr_value_allmax(idx, p0_idx_r, p0_idx_g, p0_idx_b, w_p0_nbr[idx]))  $display("[INFO] %0d ns: Assertion success: nbr_value_allmax", $time());
        
        assert property(nbr_value_gssub1(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))
        else begin
            $display("[ERROR] Assertion failed! Wrong neighbour point output at index %0d. Port 1 - R: %d, G: %d, B: %d", idx, p1_idx_r, p1_idx_g, p1_idx_b);
        end
        assert property(nbr_value_rmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_rmax", $time());
        assert property(nbr_value_gmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_gmax", $time());
        assert property(nbr_value_bmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))    $display("[INFO] %0d ns: Assertion success: nbr_value_bmax", $time());
        assert property(nbr_value_bgmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_bgmax", $time());
        assert property(nbr_value_rbmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_rbmax", $time());
        assert property(nbr_value_grmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))   $display("[INFO] %0d ns: Assertion success: nbr_value_grmax", $time());
        assert property(nbr_value_allmax(idx, p1_idx_r, p1_idx_g, p1_idx_b, w_p1_nbr[idx]))  $display("[INFO] %0d ns: Assertion success: nbr_value_allmax", $time());
    end
endgenerate

endmodule
