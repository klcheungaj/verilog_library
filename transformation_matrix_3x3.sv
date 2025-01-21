

module transformation_matrix_3x3 #(
    parameter  IDW = 10,  // input data width
    parameter  MIDW = 2,  // matrix integer part data width
    parameter  MFDW = 14,  // matrix fractional part width
    parameter  ODW = 8,   // output data width
    localparam MDW = MIDW + MFDW,  // matrix total data width
    localparam DIM = 3
) (
    input                                    clk,
    input                                    rstn,
    
    input                                    in_valid,
    input         [DIM*IDW-1:0]              din,
    input signed [DIM-1:0][DIM-1:0][MDW-1:0] matrix,  // [row][column][data]

    output                                   out_valid,
    output        [DIM*ODW-1:0]              dout
);

/**
 *          
 *   /        \      /                                       \      /       \   
 *  | dout[0] |     | matrix[0][0] matrix[0][1] matrix[0][2] |     | din[0] |   
 *  | dout[1] |  =  | matrix[1][0] matrix[1][1] matrix[1][2] |  X  | din[1] |   
 *  | dout[2] |     | matrix[2][0] matrix[2][1] matrix[2][2] |     | din[2] |   
 *   \        /      \                                       /      \       /   
 * 
 */

localparam signed SHIFT_WIDTH = MFDW + (IDW - ODW);
initial begin
    assert(MIDW >= 2);  // 1 bit for sign, 1 bit for representing 1.0
    assert(MFDW >= 1);
    assert(MDW + IDW >= ODW);
    assert(SHIFT_WIDTH >= 0);
end

localparam DIMW = $clog2(DIM);  //DIM data width
localparam [DIMW-1:0] PAD_DIMW = '0;
localparam [ODW-1:0] PAD_ODW = '0;
localparam [MIDW-1:0] PAD_MIDW = '0;
wire signed [IDW+MDW-1:0] w_prod_row[DIM][DIM];
logic signed [IDW+MDW+DIMW-1:0] r_sum_row[DIM];
logic signed [ODW-1:0] r_shifted_row[DIM];
logic [2:0] r_valid = '0;
genvar idx;

assign out_valid = r_valid[1];

function [ODW-1:0] right_shift;
    input signed [IDW+MDW+DIMW-1:0] data;
    input [ODW-1:0] bias;
    localparam TEMP_WIDTH = IDW+MDW+DIMW-SHIFT_WIDTH;
    localparam signed [TEMP_WIDTH:0] OUT_MAX = $signed((TEMP_WIDTH+1)'(1 << ODW));
    localparam signed [TEMP_WIDTH:0] OUT_MIN = '0;
    
    logic signed [TEMP_WIDTH-1:0] shift;
    logic signed [TEMP_WIDTH:0] temp;

    shift = data[SHIFT_WIDTH +: IDW+MDW+DIMW-SHIFT_WIDTH];
    temp  = shift + $signed({PAD_DIMW, PAD_MIDW, bias});
    if (temp >= OUT_MAX) right_shift = '1;
    else if (temp < OUT_MIN) right_shift = '0;
    else right_shift = temp[0 +: ODW];
endfunction

always_ff @(posedge clk or negedge rstn) begin
    if (rstn) begin
        r_valid <= '0;
    end else begin
        r_valid <= {r_valid[0 +: 2], in_valid};
    end
end

generate
    assign w_prod_row[0][0] = $signed({1'b0, din[0*IDW+:IDW]}) * $signed(matrix[0][0]);
    assign w_prod_row[0][1] = $signed({1'b0, din[1*IDW+:IDW]}) * $signed(matrix[0][1]);
    assign w_prod_row[0][2] = $signed({1'b0, din[2*IDW+:IDW]}) * $signed(matrix[0][2]);
    assign w_prod_row[1][0] = $signed({1'b0, din[0*IDW+:IDW]}) * $signed(matrix[1][0]);
    assign w_prod_row[1][1] = $signed({1'b0, din[1*IDW+:IDW]}) * $signed(matrix[1][1]);
    assign w_prod_row[1][2] = $signed({1'b0, din[2*IDW+:IDW]}) * $signed(matrix[1][2]);
    assign w_prod_row[2][0] = $signed({1'b0, din[0*IDW+:IDW]}) * $signed(matrix[2][0]);
    assign w_prod_row[2][1] = $signed({1'b0, din[1*IDW+:IDW]}) * $signed(matrix[2][1]);
    assign w_prod_row[2][2] = $signed({1'b0, din[2*IDW+:IDW]}) * $signed(matrix[2][2]);

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            r_sum_row <= '{default: '0};
        end else begin
            r_sum_row[0] <= {PAD_DIMW, w_prod_row[0][0]} + {PAD_DIMW, w_prod_row[0][1]} + {PAD_DIMW, w_prod_row[0][2]};
            r_sum_row[1] <= {PAD_DIMW, w_prod_row[1][0]} + {PAD_DIMW, w_prod_row[1][1]} + {PAD_DIMW, w_prod_row[1][2]};
            r_sum_row[2] <= {PAD_DIMW, w_prod_row[2][0]} + {PAD_DIMW, w_prod_row[2][1]} + {PAD_DIMW, w_prod_row[2][2]};
        end

    end

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            r_shifted_row <= '{default: '0};
        end else begin
            r_shifted_row[0] <= right_shift(r_sum_row[0], PAD_ODW);
            r_shifted_row[1] <= right_shift(r_sum_row[1], PAD_ODW);
            r_shifted_row[2] <= right_shift(r_sum_row[2], PAD_ODW);
        end
    end
endgenerate

endmodule
