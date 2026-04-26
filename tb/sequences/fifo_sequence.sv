// FIFO Test Sequences
class base_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(base_sequence)
  
  int num_transactions = 10;
  
  function new(string name = "base_sequence");
    super.new(name);
  endfunction
  
  extern task body();
  
endclass

// Extern task implementation
task base_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize());
    finish_item(txn);
  end
endtask

// Write-only sequence
class write_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(write_sequence)
  
  int num_transactions = 4;
  
  function new(string name = "write_sequence");
    super.new(name);
  endfunction
  
  extern task body();
  
endclass

// Extern task implementation
task write_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize() with {write_en == 1; read_en == 0;});
    finish_item(txn);
  end
endtask

// Read-only sequence
class read_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(read_sequence)
  
  int num_transactions = 4;
  
  function new(string name = "read_sequence");
    super.new(name);
  endfunction
  
  extern task body();
  
endclass

// Extern task implementation
task read_sequence::body();
  fifo_transaction txn;
  
  repeat(num_transactions) begin
    txn = fifo_transaction::type_id::create("txn");
    start_item(txn);
    assert(txn.randomize() with {write_en == 0; read_en == 1;});
    finish_item(txn);
  end
endtask

// Write then Read sequence
class write_then_read_sequence extends uvm_sequence #(fifo_transaction);
  `uvm_object_utils(write_then_read_sequence)
  
  function new(string name = "write_then_read_sequence");
    super.new(name);
  endfunction
  
  extern task body();
  
endclass

// Extern task implementation
task write_then_read_sequence::body();
  fifo_transaction txn;
  write_sequence ws = write_sequence::type_id::create("ws");
  read_sequence rs = read_sequence::type_id::create("rs");
  
  ws.num_transactions = 4;
  rs.num_transactions = 4;
  
  ws.start(m_sequencer);
  rs.start(m_sequencer);
endtask
