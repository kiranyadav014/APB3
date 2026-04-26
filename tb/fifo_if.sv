// FIFO Interface
interface fifo_if (input logic clk);
  parameter WIDTH = 8;
  
  logic rst;
  logic write_en;
  logic read_en;
  logic [WIDTH-1:0] data_in;
  logic [WIDTH-1:0] data_out;
  logic fifo_full;
  logic fifo_empty;
  
  // Clocking block for driver
  clocking drv_cb @(posedge clk);
    default input #1 output #0;
    output rst;
    output write_en;
    output read_en;
    output data_in;
    input fifo_full;
    input fifo_empty;
  endclocking
  
  // Clocking block for monitor
  clocking mon_cb @(posedge clk);
    input rst;
    input write_en;
    input read_en;
    input data_in;
    input data_out;
    input fifo_full;
    input fifo_empty;
  endclocking
  
  // Modport for driver
  modport drv (clocking drv_cb);
  
  // Modport for monitor
  modport mon (clocking mon_cb);
  
  // Assertions
  
  // Property: FIFO cannot be both full and empty simultaneously
  property fifo_not_full_and_empty;
    @(posedge clk) disable iff (rst)
    !(fifo_full && fifo_empty);
  endproperty
  assert_fifo_not_full_and_empty: assert property (fifo_not_full_and_empty)
    else `uvm_error("FIFO_IF", "FIFO is both full and empty simultaneously")
  
  // Property: No write when FIFO is full
  property no_write_when_full;
    @(posedge clk) disable iff (rst)
    fifo_full |-> !write_en;
  endproperty
  assert_no_write_when_full: assert property (no_write_when_full)
    else `uvm_error("FIFO_IF", "Write attempted when FIFO is full")
  
  // Property: No read when FIFO is empty
  property no_read_when_empty;
    @(posedge clk) disable iff (rst)
    fifo_empty |-> !read_en;
  endproperty
  assert_no_read_when_empty: assert property (no_read_when_empty)
    else `uvm_error("FIFO_IF", "Read attempted when FIFO is empty")
  
  // Property: No simultaneous read and write
  property no_simultaneous_rw;
    @(posedge clk) disable iff (rst)
    !(write_en && read_en);
  endproperty
  assert_no_simultaneous_rw: assert property (no_simultaneous_rw)
    else `uvm_error("FIFO_IF", "Simultaneous read and write attempted")
  
  // Property: Reset behavior
  property reset_clears_flags;
    @(posedge clk)
    rst |=> (fifo_empty && !fifo_full);
  endproperty
  assert_reset_clears_flags: assert property (reset_clears_flags)
    else `uvm_error("FIFO_IF", "Reset did not clear flags correctly")
  
endinterface
