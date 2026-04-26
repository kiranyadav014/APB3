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
  
  task run_phase(uvm_run_phase phase);
    reset();
    
    forever begin
      fifo_transaction txn;
      seq_item_port.get_next_item(txn);
      drive(txn);
      seq_item_port.item_done();
    end
  endtask
  
  task reset();
    `uvm_info("DRIVER", "Resetting FIFO...", UVM_MEDIUM)
    vif.drv_cb.rst <= 1;
    vif.drv_cb.write_en <= 0;
    vif.drv_cb.read_en <= 0;
    vif.drv_cb.data_in <= 0;
    repeat(2) @(vif.drv_cb);
    vif.drv_cb.rst <= 0;
    @(vif.drv_cb);
  endtask
  
  task drive(fifo_transaction txn);
    vif.drv_cb.write_en <= txn.write_en;
    vif.drv_cb.read_en <= txn.read_en;
    vif.drv_cb.data_in <= txn.data_in;
    
    @(vif.drv_cb);
    
    txn.fifo_full = vif.drv_cb.fifo_full;
    txn.fifo_empty = vif.drv_cb.fifo_empty;
    
    `uvm_info("DRIVER", $sformatf("Driving transaction: %s", txn.convert2string()), UVM_HIGH)
  endtask
  
endclass
