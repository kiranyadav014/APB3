// Top-level Test Module
module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "fifo_uvm_externs.svh"
  
  parameter WIDTH = 8;
  parameter DEPTH = 4;
  parameter WR_PTR_WR = 8;
  parameter RD_PTR_RD = 8;
  
  // Include all test files
  `include "fifo_transaction.sv"
  `include "fifo_sequence.sv"
  `include "fifo_driver.sv"
  `include "fifo_monitor.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_coverage.sv"
  `include "fifo_env.sv"
  `include "fifo_test.sv"
  
  // Clock generation
  bit clk = 0;
  always #5 clk = ~clk;
  
  // Interface instantiation
  fifo_if intf(clk);
  
  // DUT instantiation
  sync_fifo #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .WR_PTR_WR(WR_PTR_WR),
    .RD_PTR_RD(RD_PTR_RD)
  ) dut (
    .clk(clk),
    .rst(intf.rst),
    .read_en(intf.read_en),
    .write_en(intf.write_en),
    .data_in(intf.data_in),
    .data_out(intf.data_out),
    .fifo_full(intf.fifo_full),
    .fifo_empty(intf.fifo_empty)
  );
  
  initial begin
    // Configure virtual interface
    uvm_config_db #(virtual fifo_if)::set(null, "*", "vif", intf);
    
    // Run the test
    run_test();
  end
  
  // Initial reset
  initial begin
    intf.rst = 1;
    repeat(2) @(posedge clk);
    intf.rst = 0;
  end
  
  // Waveform dumping (optional - comment out if not needed)
  initial begin
    $dumpfile("fifo_tb.vcd");
    $dumpvars(0, top);
  end
  
endmodule
