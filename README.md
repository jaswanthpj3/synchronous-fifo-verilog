# Synchronous FIFO System in Verilog

A parameterizable Synchronous FIFO designed in Verilog (IEEE 1364-2001) featuring custom Producer and Consumer handshake modules.

## Architecture & Features
* **Parameterized Depth & Width:** Scalable data width and memory depth.
* **Full & Empty Flags:** Utilizes extra MSB lap-counter logic to distinguish full/empty states without losing memory capacity.
* **Producer/Consumer Handshake:** Integrates Module A (Producer) and Module B (Consumer) to simulate real-world data flow.
## System Architecture Block Diagram

```mermaid
graph LR
    subgraph System ["sync_fifo_system"]
        direction LR
        
        A["Producer Module A<br/>(producer_mod_a)"]
        FIFO["Synchronous FIFO<br/>(sync_fifo)<br/>8x8 Depth/Width"]
        B["Consumer Module B<br/>(consumer_mod_b)"]

        A -- "wr_en" --> FIFO
        A -- "d_in [7:0]" --> FIFO
        FIFO -- "full" --> A

        FIFO -- "empty" --> B
        B -- "rd_en" --> FIFO
        FIFO -- "d_out [7:0]" --> B
        B -- "rx_data [7:0]" --> Internal["Internal Logic"]
    end

    CLK(["clk"]) --> A
    CLK --> FIFO
    CLK --> B

    RST(["rst"]) --> A
    RST --> FIFO
    RST --> B
## Simulation Setup
Tested on Ubuntu 22.04 using **Icarus Verilog** and **GTKWave**.

```bash
# Compile
iverilog -o fifo_sim tb_toplvl.v toplvl.v fifo.v modA.v modB.v

# Run simulation
vvp fifo_sim

# View waveform
gtkwave waveform.vcd &
