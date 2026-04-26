// FIFO Environment
class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)
  
  fifo_driver drv;
  fifo_monitor mon;
  fifo_scoreboard sb;
  uvm_sequencer #(fifo_transaction) seqr;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    
    drv = fifo_driver::type_id::create("drv", this);
    mon = fifo_monitor::type_id::create("mon", this);
    sb = fifo_scoreboard::type_id::create("sb", this);
    seqr = uvm_sequencer #(fifo_transaction)::type_id::create("seqr", this);
  endfunction
  
  function void connect_phase(uvm_connect_phase phase);
    super.connect_phase(phase);
    
    drv.seq_item_port.connect(seqr.seq_item_export);
    mon.ap.connect(sb.ap_export);
  endfunction
  
endclass
