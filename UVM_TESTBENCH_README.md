# UVM Testbench for Synchronous FIFO

## Overview
This is a comprehensive UVM testbench for the `sync_fifo.sv` module. The testbench includes:
- Interface definition with clocking blocks
- Transaction class with constraints
- Sequences for different test scenarios
- Driver for controlling the DUT
- Monitor for capturing transactions
- Scoreboard for verification
- Environment for component integration
- Multiple test cases

## Module Parameters
- **WIDTH**: Data width (default: 8 bits)
- **DEPTH**: FIFO depth (default: 4)
- **WR_PTR_WR**: Write pointer width (default: 8 bits)
- **RD_PTR_RD**: Read pointer width (default: 8 bits)

## Testbench Components

### 1. **fifo_if.sv** - Interface
- Defines all FIFO signals
- Contains clocking blocks for driver and monitor
- Modports for hierarchical connectivity

### 2. **fifo_transaction.sv** - Transaction Class
- Transaction fields for write_en, read_en, data_in
- Captured outputs: data_out, fifo_full, fifo_empty
- Constraints for randomization
- convert2string() for logging

### 3. **fifo_sequence.sv** - Sequences
- **base_sequence**: Random read/write operations
- **write_sequence**: Write-only operations
- **read_sequence**: Read-only operations
- **write_then_read_sequence**: Sequential write then read

### 4. **fifo_driver.sv** - Driver
- Drives signals to DUT via interface
- Reset functionality
- Transaction sending and response capture

### 5. **fifo_monitor.sv** - Monitor
- Monitors all transactions
- Analysis port for scoreboard connectivity
- Logs all monitored transactions

### 6. **fifo_scoreboard.sv** - Scoreboard
- Maintains expected FIFO state
- Compares read data with expected values
- Checks full/empty flags
- Reports pass/fail statistics

### 7. **fifo_env.sv** - Environment
- Integrates driver, monitor, sequencer, scoreboard
- Manages component connectivity
- Configuration database

### 8. **fifo_test.sv** - Test Cases
- **base_test**: Base test class
- **random_test**: Random read/write (20 transactions)
- **write_test**: Write 4 words to fill FIFO
- **read_test**: Read 4 words from FIFO
- **write_read_test**: Write then read sequence
- **full_fifo_test**: Test full condition
- **empty_fifo_test**: Test empty condition

### 9. **fifo_tb_top.sv** - Top-level Module
- Instantiates interface, DUT, and test
- Clock generation
- Configuration database setup

## Running the Testbench

### Using ModelSim/QuestaSim:
```bash
# Compile
vlog rtl/sync_fifo.sv tb/fifo_if.sv tb/fifo_tb_top.sv

# Run specific test (e.g., random_test)
vsim -c top -do "run -all; quit" +UVM_TESTNAME=random_test

# Run with waveform dump
vsim -c top -do "run -all; quit" +UVM_TESTNAME=write_read_test
```

### Using VCS:
```bash
# Compile and run
vcs -sverilog +incdir+$UVM_HOME/src rtl/sync_fifo.sv tb/fifo_if.sv tb/fifo_tb_top.sv \
    +UVM_TESTNAME=random_test -o sim && ./sim
```

### Using Xcelium:
```bash
# Compile and run
xmvlog -64bit rtl/sync_fifo.sv tb/fifo_if.sv tb/fifo_tb_top.sv
xmsim -64bit top +UVM_TESTNAME=random_test
```

## Test Scenarios

### 1. Random Test
- Performs random read/write operations
- Useful for random corner case detection
- 20 transactions

### 2. Write Test
- Fills the FIFO completely (4 writes for DEPTH=4)
- Verifies write operations and full flag

### 3. Read Test
- Reads from empty FIFO
- Verifies read operations and empty flag

### 4. Write-Read Test
- Fills FIFO then reads all data
- Verifies data integrity

### 5. Full FIFO Test
- Tests behavior when FIFO is full
- Attempts to write when full

### 6. Empty FIFO Test
- Tests behavior when FIFO is empty
- Attempts to read from empty

## Verification Features

✓ **Data Integrity**: Scoreboard verifies correct data read from FIFO
✓ **Flag Checking**: Monitors and validates empty/full flags
✓ **Constraint-based Testing**: Randomized scenarios with configurable constraints
✓ **Functional Coverage**: Transaction monitoring and logging
✓ **Wave Dumping**: VCD file generation for debugging

## Key Features

1. **Modular Design**: Each component is independent and reusable
2. **Configurable**: Easily modify sequences and test parameters
3. **Comprehensive Logging**: UVM_INFO, UVM_MEDIUM, UVM_HIGH verbosity levels
4. **Pass/Fail Reporting**: Scoreboard maintains pass/fail counts
5. **Extensible**: Easy to add new sequences, tests, or checkers

## Expected Output

```
UVM_INFO fifo_driver.sv: Resetting FIFO...
UVM_INFO fifo_driver.sv: Driving transaction: WR:1 RD:0 DATA_IN:0x5a DATA_OUT:0x00 FULL:0 EMPTY:0
UVM_INFO fifo_monitor.sv: Monitored transaction: WR:1 RD:0 DATA_IN:0x5a DATA_OUT:0x00 FULL:0 EMPTY:0
UVM_INFO fifo_scoreboard.sv: WRITE: Data=0x5a at ptr=0
...
UVM_INFO fifo_scoreboard.sv: Scoreboard Summary: PASS=4, FAIL=0
```

## Troubleshooting

- **Compilation Errors**: Ensure UVM library is available (`+incdir+$UVM_HOME/src`)
- **Runtime Errors**: Check that virtual interface is properly configured
- **Simulation Hangs**: Verify that all sequences properly terminate
- **Scoreboard Errors**: Review monitor connections and transaction flow

## Files Summary
| File | Purpose |
|------|---------|
| sync_fifo.sv | DUT module |
| fifo_if.sv | Interface definition |
| fifo_transaction.sv | Transaction class |
| fifo_sequence.sv | Test sequences |
| fifo_driver.sv | Driver component |
| fifo_monitor.sv | Monitor component |
| fifo_scoreboard.sv | Scoreboard component |
| fifo_env.sv | Environment component |
| fifo_test.sv | Test cases |
| fifo_tb_top.sv | Top-level module |

---
**Note**: Modify parameters and constraints as needed for your specific FIFO configuration.
