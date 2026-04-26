// FIFO Driver
class fifo_driver extends uvm_driver #(fifo_transaction);
  `uvm_component_utils(fifo_driver)
  
  virtual fifo_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction
  
  extern task run_phase(uvm_run_phase phase);
  extern task reset();
  extern task drive(fifo_transaction txn);

  function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("DRIVER", "fifo_driver end_of_elaboration_phase", UVM_LOW)
  endfunction

  function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("DRIVER", "fifo_driver start_of_simulation_phase", UVM_LOW)
  endfunction

  function void extract_phase(uvm_extract_phase phase);
    super.extract_phase(phase);
    `uvm_info("DRIVER", "fifo_driver extract_phase", UVM_LOW)
  endfunction

  function void check_phase(uvm_check_phase phase);
    super.check_phase(phase);
    `uvm_info("DRIVER", "fifo_driver check_phase", UVM_LOW)
  endfunction

  function void report_phase(uvm_report_phase phase);
    super.report_phase(phase);
    `uvm_info("DRIVER", "fifo_driver report_phase", UVM_LOW)
  endfunction

  function void final_phase(uvm_final_phase phase);
    super.final_phase(phase);
    `uvm_info("DRIVER", "fifo_driver final_phase", UVM_LOW)
  endfunction
  
endclass

// Extern task implementations
task fifo_driver::run_phase(uvm_run_phase phase);
  reset();
  
  forever begin
    fifo_transaction txn;
    seq_item_port.get_next_item(txn);
    drive(txn);
    seq_item_port.item_done();
  end
endtask

task fifo_driver::reset();
  `uvm_info("DRIVER", "Resetting FIFO...", UVM_MEDIUM)
  vif.drv_cb.rst <= 1;
  vif.drv_cb.write_en <= 0;
  vif.drv_cb.read_en <= 0;
  vif.drv_cb.data_in <= 0;
  repeat(2) @(vif.drv_cb);
  vif.drv_cb.rst <= 0;
  @(vif.drv_cb);
endtask

task fifo_driver::drive(fifo_transaction txn);
  vif.drv_cb.write_en <= txn.write_en;
  vif.drv_cb.read_en <= txn.read_en;
  vif.drv_cb.data_in <= txn.data_in;
  
  @(vif.drv_cb);
  
  txn.fifo_full = vif.drv_cb.fifo_full;
  txn.fifo_empty = vif.drv_cb.fifo_empty;
  
  // Driver assertions
  if (txn.write_en && txn.read_en) begin
    `uvm_error("DRIVER", "Driver attempted simultaneous read and write")
  end
  
  if (txn.write_en && txn.fifo_full) begin
    `uvm_error("DRIVER", "Driver attempted write when FIFO is full")
  end
  
  if (txn.read_en && txn.fifo_empty) begin
    `uvm_error("DRIVER", "Driver attempted read when FIFO is empty")
  end
  
  `uvm_info("DRIVER", $sformatf("Driving transaction: %s", txn.convert2string()), UVM_HIGH)
endtask
