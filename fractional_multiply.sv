
module fractional_multiply #(
    parameter real FACTOR = 0.5,
    parameter IN_BIT   = 8,
    parameter OUT_BIT  = 6,
    parameter FRAC_BIT = 8,
    parameter Q_BITS = 16
) (
    input clk,
    input rstn,

    input  [  IN_BIT-1:0] din,
    output [ OUT_BIT-1:0] dout,
    output [FRAC_BIT-1:0] frac
);

initial begin
    #10;
    $display("Defined FACTOR value is: %f", FACTOR);
    assert(Q_BITS >= FRAC_BIT);
    assert(FRAC_BIT + OUT_BIT >= IN_BIT);
end

parameter logic [Q_BITS-1:0] FACTOR_QUAN = FACTOR * (1 << Q_BITS);
logic [IN_BIT + Q_BITS - 1 : 0] product;
logic [IN_BIT + Q_BITS - 1 : 0] product_round;
assign dout = product_round[FRAC_BIT +: OUT_BIT];
assign frac = product_round[0 +: FRAC_BIT];

generate
    if (Q_BITS > FRAC_BIT) begin
        assign product_round = product[Q_BITS - FRAC_BIT +: FRAC_BIT + IN_BIT] + product[Q_BITS - FRAC_BIT - 1];
    end else begin
        assign product_round = product[Q_BITS - FRAC_BIT +: FRAC_BIT + IN_BIT];
    end
endgenerate

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        product <= '0;
    end else begin
        product <= FACTOR_QUAN * din;
    end
end

endmodule
