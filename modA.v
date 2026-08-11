module producer_mod_a #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  full,   // From FIFO: High when FIFO cannot accept data
    output reg                   wr_en,  // To FIFO: Active-high write request
    output reg  [DATA_WIDTH-1:0] d_in    // To FIFO: Data payload
);

    always @(posedge clk) begin
        if (rst) begin
            wr_en <= 1'b0;
            d_in  <= 8'd1;               // Initial data payload value
        end else if (!full) begin
            wr_en <= 1'b1;               // Enable write if FIFO is not full
            d_in  <= d_in + 1'b1;        // Increment data for next transaction
        end else begin
            wr_en <= 1'b0;               // Halt writing when FIFO is full
        end
    end

endmodule