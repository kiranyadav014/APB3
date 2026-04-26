// FIFO Assertions Module
module fifo_assertions (
  input clk,
  input rst,
  input write_en,
  input read_en,
  input [7:0] data_in,
  input [7:0] data_out,
  input fifo_full,
  input fifo_empty
);

  // Additional protocol assertions
  
  // Property: Data stability during idle cycles
  property data_stable_when_idle;
    @(posedge clk) disable iff (rst)
    (!write_en && !read_en) |=> (data_in == $past(data_in) && data_out == $past(data_out));
  endproperty
  assert_data_stable_when_idle: assert property (data_stable_when_idle)
    else $error("ASSERTIONS: Data changed during idle cycle");
  
  // Property: FIFO depth consistency
  property fifo_depth_consistency;
    @(posedge clk) disable iff (rst)
    (fifo_full && fifo_empty) == 0;
  endproperty
  assert_fifo_depth_consistency: assert property (fifo_depth_consistency)
    else $error("ASSERTIONS: FIFO depth inconsistency detected");
  
  // Property: Write data valid when writing
  property write_data_valid;
    @(posedge clk) disable iff (rst)
    write_en |-> !$isunknown(data_in);
  endproperty
  assert_write_data_valid: assert property (write_data_valid)
    else $error("ASSERTIONS: Write data is unknown");
  
  // Property: Read data valid when reading
  property read_data_valid;
    @(posedge clk) disable iff (rst)
    read_en |-> !$isunknown(data_out);
  endproperty
  assert_read_data_valid: assert property (read_data_valid)
    else $error("ASSERTIONS: Read data is unknown");
  
  // Property: No X/Z on control signals
  property control_signals_valid;
    @(posedge clk)
    !$isunknown(write_en) && !$isunknown(read_en) && !$isunknown(fifo_full) && !$isunknown(fifo_empty);
  endproperty
  assert_control_signals_valid: assert property (control_signals_valid)
    else $error("ASSERTIONS: Control signals have unknown values");
  
  // Coverage for assertion hits
  cover property (@(posedge clk) fifo_full);
  cover property (@(posedge clk) fifo_empty);
  cover property (@(posedge clk) write_en && !fifo_full);
  cover property (@(posedge clk) read_en && !fifo_empty);
  cover property (@(posedge clk) write_en && read_en); // Should never happen
  
endmodule