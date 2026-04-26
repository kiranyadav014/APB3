// FIFO Monitor
class fifo_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)
  
  virtual fifo_if vif;
  uvm_analysis_port #(fifo_transaction) ap;
  
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_build_phase phase);
  extern task run_phase(uvm_run_phase phase);
  extern function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
  extern function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
  extern function void extract_phase(uvm_extract_phase phase);
  extern function void check_phase(uvm_check_phase phase);
  extern function void report_phase(uvm_report_phase phase);
  extern function void final_phase(uvm_final_phase phase);
  
endclass

// Extern implementations
function fifo_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  ap = new("ap", this);
endfunction

function void fifo_monitor::build_phase(uvm_build_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(virtual fifo_if)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", "Virtual interface not found")
endfunction

function void fifo_monitor::end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
  super.end_of_elaboration_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor end_of_elaboration_phase", UVM_LOW)
endfunction

function void fifo_monitor::start_of_simulation_phase(uvm_start_of_simulation_phase phase);
  super.start_of_simulation_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor start_of_simulation_phase", UVM_LOW)
endfunction

function void fifo_monitor::extract_phase(uvm_extract_phase phase);
  super.extract_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor extract_phase", UVM_LOW)
endfunction

function void fifo_monitor::check_phase(uvm_check_phase phase);
  super.check_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor check_phase", UVM_LOW)
endfunction

function void fifo_monitor::report_phase(uvm_report_phase phase);
  super.report_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor report_phase", UVM_LOW)
endfunction

function void fifo_monitor::final_phase(uvm_final_phase phase);
  super.final_phase(phase);
  `uvm_info("MONITOR", "fifo_monitor final_phase", UVM_LOW)
endfunction

task fifo_monitor::run_phase(uvm_run_phase phase);
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
    
    // Monitor assertions
    if (txn.fifo_full && txn.fifo_empty) begin
      `uvm_error("MONITOR", "Monitor detected FIFO both full and empty")
    end
    
    if (txn.write_en && txn.fifo_full) begin
      `uvm_error("MONITOR", "Monitor detected write when FIFO is full")
    end
    
    if (txn.read_en && txn.fifo_empty) begin
      `uvm_error("MONITOR", "Monitor detected read when FIFO is empty")
    end
    
    if (txn.write_en && txn.read_en) begin
      `uvm_error("MONITOR", "Monitor detected simultaneous read and write")
    end
    
    `uvm_info("MONITOR", $sformatf("Monitored transaction: %s", txn.convert2string()), UVM_HIGH)
    ap.write(txn);
  end
endtask
