module consumer_mod_b #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  empty,
    input  wire [DATA_WIDTH-1:0] d_out,
    output reg                   rd_en,
    output reg  [DATA_WIDTH-1:0] rx_data
);

    always @(posedge clk) begin
        if (rst) begin
            rd_en   <= 1'b0;
            rx_data <= 8'd0;
        end else if (!empty) begin
            rd_en   <= 1'b1;
            rx_data <= d_out;
        end else begin
            rd_en   <= 1'b0;
        end
    end

endmodule