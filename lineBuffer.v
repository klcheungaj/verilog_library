
module lineBuffer #(
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

    output reg                  o_vsync,
    output reg                  o_hsync,
    output reg                  o_de,
    output reg                  o_valid,
    output reg [PW-1:0]         o_d0,
    output reg [PW-1:0]         o_d1,
    output reg [PW-1:0]         o_d2,
    output reg [PW-1:0]         o_d3,
    output reg [PW-1:0]         o_d4,
    output reg [AW-1:0]         o_x,
    output reg [AW-1:0]         o_y
);


localparam IN_PCNT_W = $clog2(IN_PCNT);

reg [AW-1:0]            x_addr = 0;
reg [1:0]               y_addr = 0;
reg [PW*IN_PCNT-1:0]    r1_data = 0;
reg [PW-1:0]            r2_data = 0;
reg [PW-1:0]            r3_data = 0;
wire [PW-1:0]           d0a;
wire [PW-1:0]           d0b;
wire [PW-1:0]           d1a;
wire [PW-1:0]           d1b;

reg [5:0]               r_vsync = 0;
reg [5:0]               r_hsync = 0;
reg [5:0]               r_de = 0;
reg [5:0]               r_valid = 0;

always @(posedge i_pclk or negedge i_arstn) begin : pipeline
    if (~i_arstn) begin
        r2_data    <= 0;
        r3_data    <= 0;
        r_vsync[0] <= 0;
        r_hsync[0] <= 0;
        r_de[0]    <= 0;
        for (integer i=0 ; i<4; i=i+1) begin
            r_vsync[i+1] <= 0;
            r_hsync[i+1] <= 0;
            r_de[i+1]    <= 0;
            r_valid[i+1] <= 0;
        end
    end else begin
        r2_data    <= r1_data[0 +: PW];
        r3_data    <= r2_data;
        r_vsync[0] <= i_vsync;
        r_hsync[0] <= i_hsync;
        r_de[0]    <= i_de;
        for (integer i=0 ; i<4; i=i+1) begin
            r_vsync[i+1] <= r_vsync[i];
            r_hsync[i+1] <= r_hsync[i];
            r_de[i+1]    <= r_de[i];
            r_valid[i+1] <= r_valid[i];
        end
    end
end

always @(posedge i_pclk or negedge i_arstn) begin : output_register
    if (~i_arstn) begin
        o_vsync <= 0;
        o_hsync <= 0;
        o_de    <= 0;
        o_valid <= 0;
        o_d0    <= 0;
        o_d1    <= 0;
        o_d2    <= 0;
        o_d3    <= 0;
        o_d4    <= 0;
        o_y     <= 0;
        o_x     <= 0;
    end else begin
        o_vsync <= r_vsync[2];
        o_hsync <= r_hsync[2];
        o_de    <= r_de[2];
        o_valid <= r_valid[2];
        o_d0 <= y_addr[1] == 0 ? d0a : d1a;
        o_d2 <= y_addr[1] == 1 ? d1a : d0a;
        o_d4 <= r3_data;
        case (y_addr)
        0: begin
            o_d1 <= d0b;
            o_d3 <= d1b;
        end
        1: begin
            o_d1 <= d1a;
            o_d3 <= d0a;
        end
        2: begin
            o_d1 <= d1b;
            o_d3 <= d0b;
        end
        3: begin
            o_d1 <= d0a;
            o_d3 <= d1a;
        end
        endcase

        if (r_vsync[3] && ~r_vsync[2]) begin
            o_x <= {AW{1'b0}};
            o_y <= 0;
        end else if (r_de[3] && ~r_de[2]) begin
            o_y <= o_y + 1'b1;
            o_x <= {AW{1'b0}};
        end else if (r_vsync[2] && r_hsync[2] && r_de[2] && r_valid[2]) begin
            o_x <= o_x + 1;
        end
    end
end


generate 
    if (IN_PCNT > 1) begin
        reg [$clog2(IN_PCNT)-1:0] linebuf_s = 0;
        
        true_dual_port_ram #(
            .DATA_WIDTH     (PW),
            .ADDR_WIDTH     (AW+1),
            .WRITE_MODE_1   ("READ_FIRST"),
            .WRITE_MODE_2   ("READ_FIRST"),
            .OUTPUT_REG_1   ("TRUE"),
            .OUTPUT_REG_2   ("TRUE"),
            .RAM_INIT_FILE  ("")
        ) line_buffer_u0 (
            .we1    (r_valid[0] && y_addr[1] == 0),
            .clka   (i_pclk                     ),
            .din1   (r1_data[0 +: PW]            ),
            .addr1  ({y_addr[0], x_addr[AW-1:IN_PCNT_W], linebuf_s}     ),
            .dout1  (d0a),
            
            .we2    (1'b0                       ),
            .clkb   (i_pclk                     ),
            .din2   (0                          ),
            .addr2  ({~y_addr[0], x_addr[AW-1:IN_PCNT_W], linebuf_s}     ),
            .dout2  (d0b)
        );

        true_dual_port_ram #(
            .DATA_WIDTH     (PW),
            .ADDR_WIDTH     (AW+1),
            .WRITE_MODE_1   ("READ_FIRST"),
            .WRITE_MODE_2   ("READ_FIRST"),
            .OUTPUT_REG_1   ("TRUE"),
            .OUTPUT_REG_2   ("TRUE"),
            .RAM_INIT_FILE  ("")
        ) line_buffer_u1 (
            .we1    (r_valid[0] && y_addr[1] == 1),
            .clka   (i_pclk                     ),
            .din1   (r1_data[0 +: PW]            ),
            .addr1  ({y_addr[0], x_addr[AW-1:IN_PCNT_W], linebuf_s}     ),
            .dout1  (d1a),
            
            .we2    (1'b0                       ),
            .clkb   (i_pclk                     ),
            .din2   (0                          ),
            .addr2  ({~y_addr[0], x_addr[AW-1:IN_PCNT_W], linebuf_s}     ),
            .dout2  (d1b)
        );

        always @(posedge i_pclk or negedge i_arstn) begin
            if (~i_arstn) begin
                r1_data    <= 0;
                linebuf_s  <= 0;
                r_valid[0] <= 0;
            end else begin
                r1_data <= i_data;
                if (i_vsync && i_hsync && i_de) begin
                    if (i_valid) begin
                        linebuf_s <= 0;
                        r_valid[0] <= 1;
                    end else begin
                        r1_data <= r1_data >> PW;
                        if (linebuf_s < IN_PCNT - 1'b1) begin
                            linebuf_s <= linebuf_s + 1'b1;
                        end else begin
                            r_valid[0] <= 0;
                        end
                    end
                end else begin
                    linebuf_s <= 0;
                    r_valid[0] <= 0;
                end
            end
        end
    end else begin
        true_dual_port_ram #(
            .DATA_WIDTH     (PW),
            .ADDR_WIDTH     (AW+1),
            .WRITE_MODE_1   ("READ_FIRST"),
            .WRITE_MODE_2   ("READ_FIRST"),
            .OUTPUT_REG_1   ("TRUE"),
            .OUTPUT_REG_2   ("TRUE"),
            .RAM_INIT_FILE  ("")
        ) line_buffer_u0 (
            .we1    (r_valid[0] && y_addr[1] == 0),
            .clka   (i_pclk                     ),
            .din1   (r1_data[0 +: PW]            ),
            .addr1  ({y_addr[0], x_addr}     ),
            .dout1  (d0a),
            
            .we2    (1'b0                       ),
            .clkb   (i_pclk                     ),
            .din2   (0                          ),
            .addr2  ({~y_addr[0], x_addr}     ),
            .dout2  (d0b)
        );

        true_dual_port_ram #(
            .DATA_WIDTH     (PW),
            .ADDR_WIDTH     (AW+1),
            .WRITE_MODE_1   ("READ_FIRST"),
            .WRITE_MODE_2   ("READ_FIRST"),
            .OUTPUT_REG_1   ("TRUE"),
            .OUTPUT_REG_2   ("TRUE"),
            .RAM_INIT_FILE  ("")
        ) line_buffer_u1 (
            .we1    (r_valid[0] && y_addr[1] == 1),
            .clka   (i_pclk                     ),
            .din1   (r1_data[0 +: PW]            ),
            .addr1  ({y_addr[0], x_addr}    ),
            .dout1  (d1a),
            
            .we2    (1'b0                       ),
            .clkb   (i_pclk                     ),
            .din2   (0                          ),
            .addr2  ({~y_addr[0], x_addr}     ),
            .dout2  (d1b)
        );

        always @(posedge i_pclk or negedge i_arstn) begin
            if (~i_arstn) begin
                r1_data <= 0;
                r_valid[0] <= 0;
            end else begin
                r1_data <= i_data;
                if (i_vsync && i_hsync && i_de && i_valid) begin
                    r_valid[0] <= 1;
                end else begin
                    r_valid[0] <= 0;
                end
            end
        end
    end
endgenerate



always @(posedge i_pclk or negedge i_arstn) begin : buffer_address_control
    if (~i_arstn) begin
        x_addr <= 0;
        y_addr <= 0;
    end else begin
        if (r_vsync[1] && ~r_vsync[0]) begin
            x_addr <= {AW{1'b0}};
            y_addr <= 0;
        end else if (r_de[1] && ~r_de[0]) begin
            y_addr <= y_addr + 1;
            x_addr <= {AW{1'b0}};
        end else if (r_valid[0]) begin
            x_addr <= x_addr + 1;
        end
    end
end


endmodule
