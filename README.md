# Synchronous FIFO with UVM Testbench

A comprehensive SystemVerilog implementation of a synchronous FIFO with a complete UVM testbench for verification.

## 📁 Project Structure

```
APB3/
├── rtl/                    # RTL Design Files
│   └── sync_fifo.sv       # Synchronous FIFO module
├── tb/                     # Testbench Files
│   ├── fifo_if.sv         # Interface definition
│   ├── fifo_transaction.sv # Transaction class
│   ├── fifo_tb_top.sv     # Top-level testbench
│   ├── sequences/         # Test sequences
│   │   └── fifo_sequence.sv
│   ├── agents/            # UVM agents (driver, monitor, scoreboard)
│   │   ├── fifo_driver.sv
│   │   ├── fifo_monitor.sv
│   │   └── fifo_scoreboard.sv
│   └── tests/             # Test cases and environment
│       ├── fifo_env.sv
│       └── fifo_test.sv
├── scripts/               # Build and run scripts
│   ├── Makefile
│   └── run_sim.sh
├── .gitignore            # Git ignore file
├── UVM_TESTBENCH_README.md # Detailed testbench documentation
└── README.md             # This file
```

## 🎯 Features

### FIFO Module (`sync_fifo.sv`)
- **Synchronous FIFO** with configurable parameters
- **Full/Empty flags** for status indication
- **Parameterizable width and depth**
- **Reset functionality**

### UVM Testbench
- **Complete UVM verification environment**
- **Multiple test scenarios** (random, write-only, read-only, etc.)
- **Scoreboard-based verification**
- **Functional coverage**
- **Waveform dumping** for debugging

## 🚀 Quick Start

### Prerequisites
- SystemVerilog simulator (ModelSim, QuestaSim, VCS, or Xcelium)
- UVM library installed and configured

### Running the Testbench

#### Using Makefile (Recommended)
```bash
# Run default test (random_test)
make

# Run specific test
make TEST=write_read_test

# Run all tests
make run_all_tests

# View waveforms (requires GTKWave)
make wave

# Clean simulation files
make clean
```

#### Using Shell Script
```bash
# Run with ModelSim (default)
./scripts/run_sim.sh

# Run with specific simulator and test
./scripts/run_sim.sh vsim write_read_test
```

#### Manual Simulation
```bash
# Compile
vlog -sv rtl/sync_fifo.sv tb/fifo_if.sv tb/fifo_tb_top.sv

# Run simulation
vsim -c -do "run -all; quit" +UVM_TESTNAME=random_test top
```

## 🧪 Available Tests

| Test Name | Description |
|-----------|-------------|
| `random_test` | Random read/write operations (20 transactions) |
| `write_test` | Fill FIFO with write operations |
| `read_test` | Read operations from FIFO |
| `write_read_test` | Sequential write then read operations |
| `full_fifo_test` | Test FIFO full condition |
| `empty_fifo_test` | Test FIFO empty condition |

## 📋 Module Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `WIDTH` | 8 | Data width in bits |
| `DEPTH` | 4 | FIFO depth (number of entries) |
| `WR_PTR_WR` | 8 | Write pointer width |
| `RD_PTR_RD` | 8 | Read pointer width |

## 🔧 Configuration

### Modifying FIFO Parameters
Edit the parameters in `rtl/sync_fifo.sv`:
```systemverilog
parameter WIDTH = 16,      // Change data width
          DEPTH = 8,       // Change FIFO depth
          WR_PTR_WR = 4,   // Adjust pointer widths
          RD_PTR_RD = 4;
```

### Adding New Tests
1. Add test class in `tb/tests/fifo_test.sv`
2. Register with UVM factory
3. Run with `+UVM_TESTNAME=new_test`

## 📊 Verification Features

- ✅ **Data Integrity Checking**: Scoreboard verifies correct data flow
- ✅ **Flag Validation**: Monitors full/empty status flags
- ✅ **Functional Coverage**: Comprehensive transaction coverage
- ✅ **Random Testing**: Constraint-based randomization
- ✅ **Debug Support**: Waveform dumping and detailed logging

## 🛠️ Development

### File Organization
- **rtl/**: Hardware design files
- **tb/**: Testbench components
- **scripts/**: Build and automation scripts
- **docs/**: Documentation files

### Code Style
- Follow SystemVerilog best practices
- Use UVM methodology for verification
- Include comprehensive comments
- Maintain consistent naming conventions

## 📈 Simulation Results

Expected output format:
```
UVM_INFO fifo_driver.sv: Resetting FIFO...
UVM_INFO fifo_driver.sv: Driving transaction: WR:1 RD:0 DATA_IN:0x5a
UVM_INFO fifo_scoreboard.sv: WRITE: Data=0x5a at ptr=0
...
UVM_INFO fifo_scoreboard.sv: Scoreboard Summary: PASS=4, FAIL=0
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with proper documentation
4. Add/update tests as needed
5. Submit a pull request

## 📄 License

This project is open source. See individual files for license information.

## 📞 Support

For issues or questions:
1. Check the [UVM Testbench README](UVM_TESTBENCH_README.md) for detailed documentation
2. Review simulation logs for error messages
3. Verify UVM library configuration
4. Check simulator-specific requirements

---

**Note**: Ensure your simulator supports SystemVerilog and UVM before running the testbench.