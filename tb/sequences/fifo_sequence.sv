// FIFO Test Sequences
class base_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(base_sequence)
  
  int num_transactions = 10;
  
  extern function new(string name = "base_sequence");
  extern task body();
  
endclass

// Write-only sequence
class write_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(write_sequence)
  
  int num_transactions = 4;
  
  extern function new(string name = "write_sequence");
  extern task body();
  
endclass

// Read-only sequence
class read_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(read_sequence)
  
  int num_transactions = 4;
  
  extern function new(string name = "read_sequence");
  extern task body();
  
endclass

// Write then Read sequence
class write_then_read_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(write_then_read_sequence)
  
  extern function new(string name = "write_then_read_sequence");
  extern task body();
  
endclass

// Extern implementations
function base_sequence::new(string name = "base_sequence");
  super.new(name);
endfunction

task base_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize());
    finish_item(txn);
  end
endtask

function write_sequence::new(string name = "write_sequence");
  super.new(name);
endfunction

task write_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize() with {write_en == 1; read_en == 0;});
    finish_item(txn);
  end
endtask

function read_sequence::new(string name = "read_sequence");
  super.new(name);
endfunction

task read_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize() with {write_en == 0; read_en == 1;});
    finish_item(txn);
  end
endtask

function write_then_read_sequence::new(string name = "write_then_read_sequence");
  super.new(name);
endfunction

task write_then_read_sequence::body();
  fifo_transaction txn;
  write_sequence ws = write_sequence::type_id::create("ws");
  read_sequence rs = read_sequence::type_id::create("rs");
  
  ws.num_transactions = 4;
  rs.num_transactions = 4;
  
  ws.start(m_sequencer);
  rs.start(m_sequencer);
endtask
