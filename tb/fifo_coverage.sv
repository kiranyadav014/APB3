// FIFO Coverage Subscriber
class fifo_coverage extends uvm_subscriber #(fifo_transaction);
  `uvm_component_utils(fifo_coverage)

  fifo_transaction txn;
  fifo_cov cov;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_build_phase phase);
    super.build_phase(phase);
    cov = new("cov");
  endfunction

  extern function void write(fifo_transaction t);

  function void end_of_elaboration_phase(uvm_end_of_elaboration_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage end_of_elaboration_phase", UVM_LOW)
  endfunction

  function void start_of_simulation_phase(uvm_start_of_simulation_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage start_of_simulation_phase", UVM_LOW)
  endfunction

  function void extract_phase(uvm_extract_phase phase);
    super.extract_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage extract_phase", UVM_LOW)
  endfunction

  function void check_phase(uvm_check_phase phase);
    super.check_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage check_phase", UVM_LOW)
  endfunction

  function void report_phase(uvm_report_phase phase);
    super.report_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage report_phase", UVM_LOW)
  endfunction

  function void final_phase(uvm_final_phase phase);
    super.final_phase(phase);
    `uvm_info("COVERAGE", "fifo_coverage final_phase", UVM_LOW)
  endfunction

  covergroup fifo_cov;
    write_en_cp : coverpoint txn.write_en {
      bins idle = {0};
      bins write = {1};
    }
    read_en_cp : coverpoint txn.read_en {
      bins idle = {0};
      bins read = {1};
    }
    fifo_full_cp : coverpoint txn.fifo_full;
    fifo_empty_cp : coverpoint txn.fifo_empty;
    full_empty_x : cross fifo_full_cp, fifo_empty_cp;
    rw_x : cross write_en_cp, read_en_cp;
  endgroup

endclass

// Extern function implementation
function void fifo_coverage::write(fifo_transaction t);
  txn = t;
  cov.sample();
endfunction
