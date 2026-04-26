// FIFO Transaction Class
class fifo_transaction extends uvm_sequence_item;
  `uvm_object_utils(fifo_transaction)
  
  parameter WIDTH = 8;
  parameter DEPTH = 4;
  
  // Transaction fields
  rand logic write_en;
  rand logic read_en;
  rand logic [WIDTH-1:0] data_in;
  logic fifo_full;
  logic fifo_empty;
  logic [WIDTH-1:0] data_out;
  
  // Constraints
  constraint valid_operation {
    write_en dist {0 := 30, 1 := 70};
    read_en dist {0 := 30, 1 := 70};
    !(write_en && read_en);  // Cannot write and read simultaneously (optional constraint)
  }
  
  function new(string name = "fifo_transaction");
    super.new(name);
  endfunction
  
  function void post_randomize();
    super.post_randomize();
    
    // Transaction assertions
    assert (!(write_en && read_en)) else `uvm_error("TRANSACTION", "Transaction has both write_en and read_en set")
    assert (write_en || read_en || (!write_en && !read_en)) else `uvm_error("TRANSACTION", "Invalid transaction state")
  endfunction
  
  function string convert2string();
    string s;
    s = $sformatf("WR:%0d RD:%0d DATA_IN:0x%0h DATA_OUT:0x%0h FULL:%0d EMPTY:%0d",
                   write_en, read_en, data_in, data_out, fifo_full, fifo_empty);
    return s;
  endfunction
  
endclass
