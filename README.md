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
```
## System Architecture Block Diagram

```mermaid
flowchart LR
    %% Custom Styles
    classDef fifoClass fill:#1e40af,stroke:#60a5fa,stroke-width:2px,color:#ffffff;
    classDef modClass fill:#065f46,stroke:#34d399,stroke-width:2px,color:#ffffff;
    classDef globalClass fill:#334155,stroke:#94a3b8,color:#f8fafc;

    subgraph TopLevel ["sync_fifo_system (Top-Level Wrapper)"]
        direction LR

        A["<b>Producer</b><br/>(modA.v)"]:::modClass
        FIFO["<b>Synchronous FIFO</b><br/>(fifo.v)<br/><i>8x8 Bit Depth & Width</i>"]:::fifoClass
        B["<b>Consumer</b><br/>(modB.v)"]:::modClass

        %% Multi-bit Data Buses (Thick Lines)
        A == "d_in [7:0]" ==> FIFO
        FIFO == "d_out [7:0]" ==> B

        %% Control & Flag Signals
        A -->|"wr_en"| FIFO
        FIFO -.->|"full"| A

        B -->|"rd_en"| FIFO
        FIFO -.->|"empty"| B
    end

    %% Global Inputs
    CLK(["clk"]):::globalClass --> TopLevel
    RST(["rst"]):::globalClass --> TopLevel