#!/bin/bash
# Quick compilation script for FIFO UVM Testbench
# This script compiles and runs the testbench with ModelSim/QuestaSim

set -e

SIMULATOR=${1:-vsim}
TEST_NAME=${2:-random_test}
OUTPUT_LOG="fifo_sim_$(date +%Y%m%d_%H%M%S).log"

echo "================================================"
echo "FIFO UVM Testbench Compilation and Simulation"
echo "================================================"
echo ""
echo "Simulator: $SIMULATOR"
echo "Test: $TEST_NAME"
echo "Output: $OUTPUT_LOG"
echo ""

# List of source files
SOURCES=(
    "rtl/sync_fifo.sv"
    "tb/fifo_if.sv"
    "tb/fifo_tb_top.sv"
)

# Verify all source files exist
echo "Checking source files..."
for file in "${SOURCES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Source file not found: $file"
        exit 1
    fi
    echo "  ✓ $file"
done
echo ""

# Create work directory and compile
echo "Compiling with $SIMULATOR..."
case $SIMULATOR in
    vsim)
        # ModelSim/QuestaSim
        vlog -sv -work work "${SOURCES[@]}"
        echo "Compilation successful!"
        echo ""
        echo "Running simulation with test: $TEST_NAME"
        vsim -c -do "run -all; quit" +UVM_TESTNAME=$TEST_NAME top 2>&1 | tee "$OUTPUT_LOG"
        ;;
    vcs)
        # VCS
        vcs -sverilog -full64 "${SOURCES[@]}" -top top
        echo "Compilation successful!"
        echo ""
        echo "Running simulation with test: $TEST_NAME"
        ./simv +UVM_TESTNAME=$TEST_NAME 2>&1 | tee "$OUTPUT_LOG"
        ;;
    xmvlog)
        # Xcelium (Xcelium)
        xmvlog -64bit -sv "${SOURCES[@]}"
        xmelab -64bit top
        echo "Compilation successful!"
        echo ""
        echo "Running simulation with test: $TEST_NAME"
        xmsim -64bit top +UVM_TESTNAME=$TEST_NAME 2>&1 | tee "$OUTPUT_LOG"
        ;;
    *)
        echo "ERROR: Unknown simulator: $SIMULATOR"
        echo "Supported simulators: vsim, vcs, xmvlog"
        exit 1
        ;;
esac

echo ""
echo "================================================"
echo "Simulation completed!"
echo "Log file: $OUTPUT_LOG"
echo "================================================"
