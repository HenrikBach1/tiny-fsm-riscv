#!/bin/bash
# file=/home/sad/projects/tiny-fsm-riscv/scripts/build.sh
# Build script for Tiny FSM + PicoRV32 project

echo "Starting synthesis and simulation..."
yosys -p "synth_ice40 -top user_project_wrapper -blif output.blif" src/*.v
iverilog -o testbench sim/testbench.v
vvp testbench
