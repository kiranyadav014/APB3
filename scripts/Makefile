# Makefile for FIFO UVM Testbench

# Simulator
SIM = vsim

# Source files
SOURCES = rtl/sync_fifo.sv \
          tb/fifo_if.sv \
          tb/fifo_tb_top.sv

# Test name (can be overridden from command line)
TEST ?= random_test

# UVM library path (set this based on your installation)
UVM_HOME ?= $(QUESTASIM_HOME)

# Compile flags
VLOG_FLAGS = -sv +incdir+./

# Simulate flags
VSIM_FLAGS = -c -do "run -all; quit" +UVM_TESTNAME=$(TEST)

# Default target
all: compile simulate

# Compile simulation
compile: $(SOURCES)
	vlog $(VLOG_FLAGS) $(SOURCES)

# Run simulation
simulate:
	$(SIM) $(VSIM_FLAGS) top

# Run specific test
test_%:
	@echo "Running test: $*"
	$(SIM) $(VSIM_FLAGS) top

# Run all test scenarios
run_all_tests:
	@echo "Running all test scenarios..."
	@$(MAKE) TEST=random_test simulate
	@$(MAKE) TEST=write_test simulate
	@$(MAKE) TEST=read_test simulate
	@$(MAKE) TEST=write_read_test simulate
	@$(MAKE) TEST=full_fifo_test simulate
	@$(MAKE) TEST=empty_fifo_test simulate

# View waveforms
wave:
	gtkwave fifo_tb.vcd &

# Clean simulation files
clean:
	rm -rf work *.log *.wdb *.vcd transcript *.vstf

# Help
help:
	@echo "FIFO UVM Testbench Makefile"
	@echo "Usage:"
	@echo "  make                      - Compile and run random_test"
	@echo "  make TEST=test_name       - Run specific test"
	@echo "  make run_all_tests        - Run all test scenarios"
	@echo "  make wave                 - View waveforms"
	@echo "  make clean                - Clean simulation files"
	@echo ""
	@echo "Available tests:"
	@echo "  - random_test"
	@echo "  - write_test"
	@echo "  - read_test"
	@echo "  - write_read_test"
	@echo "  - full_fifo_test"
	@echo "  - empty_fifo_test"

.PHONY: all compile simulate test_% run_all_tests wave clean help
