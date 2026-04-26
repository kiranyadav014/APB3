// FIFO Environment
class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  fifo_driver drv;
  fifo_monitor mon;
  fifo_coverage cov;
  fifo_scoreboard sb;
  uvm_sequencer #(fifo_transaction) seqr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    
    drv = fifo_driver::type_id::create("drv", this);
    mon = fifo_monitor::type_id::create("mon", this);
    cov = fifo_coverage::type_id::create("cov", this);
    sb = fifo_scoreboard::type_id::create("sb", this);
    seqr = uvm_sequencer #(fifo_transaction)::type_id::create("seqr", this);
  endfunction
  
  function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    
    drv.seq_item_port.connect(seqr.seq_item_export);
    mon.ap.connect(cov.analysis_export);
    mon.ap.connect(sb.ap_export);
  endfunction

  function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("ENV", "fifo_env end_of_elaboration_phase", UVM_LOW)
  endfunction

  function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("ENV", "fifo_env start_of_simulation_phase", UVM_LOW)
  endfunction

  function void extract_phase(uvm_extract_phase phase);
    super.extract_phase(phase);
    `uvm_info("ENV", "fifo_env extract_phase", UVM_LOW)
  endfunction

  function void check_phase(uvm_check_phase phase);
    super.check_phase(phase);
    `uvm_info("ENV", "fifo_env check_phase", UVM_LOW)
  endfunction

  function void report_phase(uvm_report_phase phase);
    super.report_phase(phase);
    `uvm_info("ENV", "fifo_env report_phase", UVM_LOW)
  endfunction

  function void final_phase(uvm_final_phase phase);
    super.final_phase(phase);
    `uvm_info("ENV", "fifo_env final_phase", UVM_LOW)
  endfunction
  
endclass
