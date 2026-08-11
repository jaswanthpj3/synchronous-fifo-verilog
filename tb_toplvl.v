`timescale 1ns / 1ps

module tb_toplvl;

    // Testbench signals
    reg clk;
    reg rst;

    // Instantiate Top-Level System
    sync_fifo_system #(
        .DATA_WIDTH(8),
        .DEPTH(8)
    ) uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation: 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // GTKWave dump configuration
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_toplvl);

        // Initialize signals
        clk = 0;
        rst = 1;

        // Hold Reset for 20ns
        #20;
        rst = 0;

        // Print header for terminal monitoring
        $display("-----------------------------------------------------------------------");
        $display("Time(ns) | rst | wr_en | d_in | full | empty | rd_en | d_out | rx_data");
        $display("-----------------------------------------------------------------------");
        $monitor("%4t     |  %b  |   %b   | %3d  |  %b   |   %b   |   %b   | %3d   |  %3d", 
                 $time, rst, uut.wr_en_sig, uut.data_bus_in, uut.full_sig, 
                 uut.empty_sig, uut.rd_en_sig, uut.data_bus_out, uut.rx_captured_data);

        // Run simulation for 500ns
        #500;
        
        $display("-----------------------------------------------------------------------");
        $display("Simulation Finished!");
        $finish;
    end

endmodule