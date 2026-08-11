module sync_fifo #(
    parameter DATA_WIDTH = 8,                 // Width of each data word in bits
    parameter DEPTH      = 8,                 // Total number of memory storage locations
)(
    input  wire                  clk,         // Shared clock signal for reads and writes
    input  wire                  rst,         // Active-high reset signal
    input  wire                  wr_en,       // Push signal (write request)
    input  wire                  rd_en,       // Pop signal (read request)
    input  wire [DATA_WIDTH-1:0] d_in,        // Incoming data payload
    output reg  [DATA_WIDTH-1:0] d_out,       // Outgoing data payload
    output wire                  empty,       // Flag: High when FIFO has no unread data
    output wire                  full         // Flag: High when FIFO has no open slots
);

    localparam ADDR_WIDTH = $clog2(DEPTH);    // Automatically computes bits needed (3 bits for DEPTH=8)
    // Memory declaration: DEPTH slots, each DATA_WIDTH bits wide
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Pointers are (ADDR_WIDTH + 1) bits wide to hold the extra MSB lap bit
    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;

    // --- WRITE LOGIC ---
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;                      // Reset pointer to address 0, lap 0
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= d_in; // Strip MSB, write to memory index
            wr_ptr <= wr_ptr + 1'b1;          // Increment pointer (MSB flips on wrap)
        end
    end

    // --- READ LOGIC ---
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr <= 0;                      // Reset pointer to address 0, lap 0
            d_out  <= 0;                      // Clear output register
        end else if (rd_en && !empty) begin
            d_out  <= mem[rd_ptr[ADDR_WIDTH-1:0]]; // Strip MSB, read from memory index
            rd_ptr <= rd_ptr + 1'b1;          // Increment pointer (MSB flips on wrap)
        end
    end

    // --- STATUS FLAGS LOGIC ---
    // Empty: Both memory addresses and lap bits match exactly
    assign empty = (wr_ptr == rd_ptr);

    // Full: Memory addresses match, but the writer is 1 lap ahead of the reader
    assign full  = (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) &&
                   (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]);

endmodule