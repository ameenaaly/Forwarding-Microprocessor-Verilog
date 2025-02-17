# Forwarding Microprocessor Design 

## Overview
This project implements a **Forwarding Microprocessor** using **Verilog HDL**, designed to handle **data hazards** efficiently in a pipelined architecture. The forwarding mechanism reduces stalls, improving instruction throughput.

## Features
- **Pipelined Design**: Implements a multi-stage pipeline for efficient instruction execution.
- **Forwarding Unit**: Resolves data hazards by forwarding values to dependent instructions.
- **Control Logic**: Includes a hazard detection unit to minimize stalls.
- **Testbenches**: Verification included for key components.
- **Modular Structure**: Each unit is implemented as an independent module for scalability.

## Setup & Usage

### **1. Install Required Tools**
Ensure you have:
- **Verilog Simulator**: Icarus Verilog (`iverilog`) or ModelSim.
- **Waveform Viewer**: GTKWave (for simulation output).

### **2. Clone the Repository**
```bash
git clone https://github.com/your-username/Forwarding-Microprocessor.git
cd Forwarding-Microprocessor

