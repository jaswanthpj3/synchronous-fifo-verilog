# Synchronous FIFO System in Verilog

A parameterizable Synchronous FIFO designed in Verilog (IEEE 1364-2001) featuring custom Producer and Consumer handshake modules.

## Architecture & Features
* **Parameterized Depth & Width:** Scalable data width and memory depth.
* **Full & Empty Flags:** Utilizes extra MSB lap-counter logic to distinguish full/empty states without losing memory capacity.
* **Producer/Consumer Handshake:** Integrates Module A (Producer) and Module B (Consumer) to simulate real-world data flow.

## Simulation Setup
Tested on Ubuntu 22.04 using **Icarus Verilog** and **GTKWave**.

```bash
# Compile
iverilog -o fifo_sim tb_toplvl.v toplvl.v fifo.v modA.v modB.v

# Run simulation
vvp fifo_sim

# View waveform
gtkwave waveform.vcd &
