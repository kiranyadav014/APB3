// Base Test Class
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  fifo_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    env = fifo_env::type_id::create("env", this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass

// Random Test
class random_test extends base_test;
  `uvm_component_utils(random_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    base_sequence seq;
    
    phase.raise_objection(this);
    
    seq = base_sequence::type_id::create("seq");
    seq.num_transactions = 20;
    seq.start(env.seqr);
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Write Test
class write_test extends base_test;
  `uvm_component_utils(write_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    write_sequence seq;
    
    phase.raise_objection(this);
    
    seq = write_sequence::type_id::create("seq");
    seq.num_transactions = 4;
    seq.start(env.seqr);
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Read Test
class read_test extends base_test;
  `uvm_component_utils(read_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    read_sequence seq;
    
    phase.raise_objection(this);
    
    seq = read_sequence::type_id::create("seq");
    seq.num_transactions = 4;
    seq.start(env.seqr);
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Write then Read Test
class write_read_test extends base_test;
  `uvm_component_utils(write_read_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    write_then_read_sequence seq;
    
    phase.raise_objection(this);
    
    seq = write_then_read_sequence::type_id::create("seq");
    seq.start(env.seqr);
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Full FIFO Test
class full_fifo_test extends base_test;
  `uvm_component_utils(full_fifo_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    write_sequence seq;
    fifo_transaction txn;
    
    phase.raise_objection(this);
    
    // Fill the FIFO completely
    seq = write_sequence::type_id::create("seq");
    seq.num_transactions = 4;
    seq.start(env.seqr);
    
    // Try to write when full
    repeat(5) begin
      txn = fifo_transaction::type_id::create("txn");
      $cast(env.seqr.sequencer_state, UVM_IDLE);
      begin
        env.seqr.get_next_item(txn);
        txn.randomize() with {write_en == 1; read_en == 0;};
        env.seqr.item_done();
      end
    end
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass

// Empty FIFO Test
class empty_fifo_test extends base_test;
  `uvm_component_utils(empty_fifo_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    read_sequence seq;
    
    phase.raise_objection(this);
    
    // Try to read from empty FIFO
    seq = read_sequence::type_id::create("seq");
    seq.num_transactions = 5;
    seq.start(env.seqr);
    
    #100;
    phase.drop_objection(this);
  endtask
  
endclass
