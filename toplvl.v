module sync_fifo_system #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
)(
    input wire clk,
    input wire rst
);

    // Internal interconnect wires
    wire                  full_sig;
    wire                  empty_sig;
    wire                  wr_en_sig;
    wire                  rd_en_sig;
    wire [DATA_WIDTH-1:0] data_bus_in;
    wire [DATA_WIDTH-1:0] data_bus_out;
    wire [DATA_WIDTH-1:0] rx_captured_data;

    // Module A Instantiation (Producer)
    producer_mod_a #(
        .DATA_WIDTH(DATA_WIDTH)
    ) mod_a (
        .clk  (clk),
        .rst  (rst),
        .full (full_sig),
        .wr_en(wr_en_sig),
        .d_in (data_bus_in)
    );

    // Synchronous FIFO Instantiation
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) fifo_inst (
        .clk  (clk),
        .rst  (rst),
        .wr_en(wr_en_sig),
        .rd_en(rd_en_sig),
        .d_in (data_bus_in),
        .d_out(data_bus_out),
        .empty(empty_sig),
        .full (full_sig)
    );

    // Module B Instantiation (Consumer)
    consumer_mod_b #(
        .DATA_WIDTH(DATA_WIDTH)
    ) mod_b (
        .clk    (clk),
        .rst    (rst),
        .empty  (empty_sig),
        .d_out  (data_bus_out),
        .rd_en  (rd_en_sig),
        .rx_data(rx_captured_data)
    );

endmodule