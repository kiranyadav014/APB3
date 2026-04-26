// Base Test Class
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  fifo_env env;
  
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_build_phase phase);
  extern function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
  extern function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
  extern function void extract_phase(uvm_extract_phase phase);
  extern function void check_phase(uvm_check_phase phase);
  extern function void report_phase(uvm_report_phase phase);
  extern function void final_phase(uvm_final_phase phase);
  
endclass

// Random Test
class random_test extends base_test;
  `uvm_component_utils(random_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Write Test
class write_test extends base_test;
  `uvm_component_utils(write_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Read Test
class read_test extends base_test;
  `uvm_component_utils(read_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Write then Read Test
class write_read_test extends base_test;
  `uvm_component_utils(write_read_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Full FIFO Test
class full_fifo_test extends base_test;
  `uvm_component_utils(full_fifo_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Empty FIFO Test
class empty_fifo_test extends base_test;
  `uvm_component_utils(empty_fifo_test)
  
  extern function new(string name, uvm_component parent);
  extern task run_phase(uvm_run_phase phase);
  
endclass

// Extern implementations
function base_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void base_test::build_phase(uvm_build_phase phase);
  super.build_phase(phase);
  env = fifo_env::type_id::create("env", this);
endfunction

function void base_test::end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction

function void base_test::start_of_simulation_phase(uvm_start_of_simulation_phase phase);
  super.start_of_simulation_phase(phase);
  `uvm_info("TEST", "base_test start_of_simulation_phase", UVM_LOW)
endfunction

function void base_test::extract_phase(uvm_extract_phase phase);
  super.extract_phase(phase);
  `uvm_info("TEST", "base_test extract_phase", UVM_LOW)
endfunction

function void base_test::check_phase(uvm_check_phase phase);
  super.check_phase(phase);
  `uvm_info("TEST", "base_test check_phase", UVM_LOW)
endfunction

function void base_test::report_phase(uvm_report_phase phase);
  super.report_phase(phase);
  `uvm_info("TEST", "base_test report_phase", UVM_LOW)
endfunction

function void base_test::final_phase(uvm_final_phase phase);
  super.final_phase(phase);
  `uvm_info("TEST", "base_test final_phase", UVM_LOW)
endfunction

function random_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task random_test::run_phase(uvm_run_phase phase);
  base_sequence seq;
  
  phase.raise_objection(this);
  
  seq = base_sequence::type_id::create("seq");
  seq.num_transactions = 20;
  seq.start(env.seqr);
  
  #100;
  phase.drop_objection(this);
endtask

function write_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task write_test::run_phase(uvm_run_phase phase);
  write_sequence seq;
  
  phase.raise_objection(this);
  
  seq = write_sequence::type_id::create("seq");
  seq.num_transactions = 4;
  seq.start(env.seqr);
  
  #100;
  phase.drop_objection(this);
endtask

function read_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task read_test::run_phase(uvm_run_phase phase);
  read_sequence seq;
  
  phase.raise_objection(this);
  
  seq = read_sequence::type_id::create("seq");
  seq.num_transactions = 4;
  seq.start(env.seqr);
  
  #100;
  phase.drop_objection(this);
endtask

function write_read_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task write_read_test::run_phase(uvm_run_phase phase);
  write_then_read_sequence seq;
  
  phase.raise_objection(this);
  
  seq = write_then_read_sequence::type_id::create("seq");
  seq.start(env.seqr);
  
  #100;
  phase.drop_objection(this);
endtask

function full_fifo_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task full_fifo_test::run_phase(uvm_run_phase phase);
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

function empty_fifo_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

task empty_fifo_test::run_phase(uvm_run_phase phase);
  read_sequence seq;
  
  phase.raise_objection(this);
  
  // Try to read from empty FIFO
  seq = read_sequence::type_id::create("seq");
  seq.num_transactions = 5;
  seq.start(env.seqr);
  
  #100;
  phase.drop_objection(this);
endtask
