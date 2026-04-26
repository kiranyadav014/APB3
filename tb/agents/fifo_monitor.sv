// FIFO Monitor
class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)
  
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_transaction) ap;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_run_phase phase);
    forever begin
      fifo_transaction txn;
      txn = fifo_transaction::type_id::create("txn");
      
      @(vif.mon_cb);
      
      txn.write_en = vif.mon_cb.write_en;
      txn.read_en = vif.mon_cb.read_en;
      txn.data_in = vif.mon_cb.data_in;
      txn.data_out = vif.mon_cb.data_out;
      txn.fifo_full = vif.mon_cb.fifo_full;
      txn.fifo_empty = vif.mon_cb.fifo_empty;
      
      `uvm_info("MONITOR", $sformatf("Monitored transaction: %s", txn.convert2string()), UVM_HIGH)
      ap.write(txn);
    end
  endtask
  
endclass
