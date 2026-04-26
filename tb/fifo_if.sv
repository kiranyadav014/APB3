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
  
endinterface
