// FIFO Scoreboard
class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)
  
  parameter WIDTH = 8;
  parameter DEPTH = 4;
  
  uvm_analysis_export #(fifo_transaction) ap_export;
  uvm_tlm_analysis_fifo #(fifo_transaction) af;
  
  logic [WIDTH-1:0] expected_mem[DEPTH-1:0];
  int wr_ptr_sb = 0;
  int rd_ptr_sb = 0;
  int pass_count = 0;
  int fail_count = 0;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap_export = new("ap_export", this);
    af = new("af", this);
  endfunction
  
  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    ap_export.connect(af.analysis_export);
  endfunction
  
  task run_phase(uvm_run_phase phase);
    fifo_transaction txn;
    
    forever begin
      af.get(txn);
      
      if(txn.write_en && !txn.fifo_full) begin
        expected_mem[wr_ptr_sb % DEPTH] = txn.data_in;
        wr_ptr_sb++;
        `uvm_info("SB", $sformatf("WRITE: Data=0x%0h at ptr=%0d", txn.data_in, (wr_ptr_sb-1) % DEPTH), UVM_MEDIUM)
      end
      
      if(txn.read_en && !txn.fifo_empty) begin
        logic [WIDTH-1:0] expected_data;
        expected_data = expected_mem[rd_ptr_sb % DEPTH];
        
        if(expected_data == txn.data_out) begin
          `uvm_info("SB", $sformatf("READ MATCH: Expected=0x%0h, Got=0x%0h", expected_data, txn.data_out), UVM_MEDIUM)
          pass_count++;
        end else begin
          `uvm_error("SB", $sformatf("READ MISMATCH: Expected=0x%0h, Got=0x%0h", expected_data, txn.data_out))
          fail_count++;
        end
        rd_ptr_sb++;
      end
      
      // Check empty flag
      if((wr_ptr_sb % (1 << 8)) == (rd_ptr_sb % (1 << 8))) begin
        if(!txn.fifo_empty) begin
          `uvm_error("SB", "FIFO should be empty but fifo_empty=0")
          fail_count++;
        end
      end
      
      // Check full flag
      if(((wr_ptr_sb - rd_ptr_sb) % (1 << 8)) == DEPTH) begin
        if(!txn.fifo_full) begin
          `uvm_error("SB", "FIFO should be full but fifo_full=0")
          fail_count++;
        end
      end
    end
  endtask

  function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("SB", "fifo_scoreboard end_of_elaboration_phase", UVM_LOW)
  endfunction

  function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("SB", "fifo_scoreboard start_of_simulation_phase", UVM_LOW)
  endfunction

  function void extract_phase(uvm_extract_phase phase);
    super.extract_phase(phase);
    `uvm_info("SB", "fifo_scoreboard extract_phase", UVM_LOW)
  endfunction

  function void check_phase(uvm_check_phase phase);
    super.check_phase(phase);
    `uvm_info("SB", "fifo_scoreboard check_phase", UVM_LOW)
  endfunction

  function void report_phase(uvm_report_phase phase);
    super.report_phase(phase);
    `uvm_info("SB", $sformatf("Scoreboard Summary: PASS=%0d, FAIL=%0d", pass_count, fail_count), UVM_MEDIUM)
  endfunction

  function void final_phase(uvm_final_phase phase);
    super.final_phase(phase);
    `uvm_info("SB", "fifo_scoreboard final_phase", UVM_LOW)
  endfunction
  
endclass
