`include "uvm_macros.svh"
import uvm_pkg::*;

`uvm_analysis_imp_decl(_actual)
`uvm_analysis_imp_decl(_expected)

class register_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(register_scoreboard)
  // TLM Analysis Implementations
  // Monitor -> Scoreboard
  uvm_analysis_imp_actual #(register_seq_item, register_scoreboard)
    actual_export;
  // Predictor -> Scoreboard
  uvm_analysis_imp_expected #(register_seq_item, register_scoreboard)
    expected_export;
  // Transaction Queues
  // Actual transactions received from Monitor
  register_seq_item actual_trans_q[$];
  // Expected transactions received from Predictor
  register_seq_item expected_trans_q[$];
  // Statistics
  int unsigned total_transactions;
  int unsigned passed_transactions;
  int unsigned failed_transactions;
  // Constructor
  function new(string name = "register_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create TLM analysis implementations
    actual_export = new("actual_export", this);
    expected_export = new("expected_export", this);
    // Initialize statistics
    total_transactions  = 0;
    passed_transactions = 0;
    failed_transactions = 0;
  endfunction
  // Actual Transaction From Monitor
  virtual function void write_actual(register_seq_item trans);
    // Store actual transaction
    actual_trans_q.push_back(trans);
    `uvm_info("SCOREBOARD", "Actual transaction received", UVM_HIGH)
    // Try comparison
    compare_transactions();
  endfunction
  // Expected Transaction From Predictor
  virtual function void write_expected(register_seq_item trans);
    // Store expected transaction
    expected_trans_q.push_back(trans);
    `uvm_info("SCOREBOARD", "Expected transaction received", UVM_HIGH)
    // Try comparison
    compare_transactions();
  endfunction
  // Compare Actual vs Expected
  virtual function void compare_transactions();
    register_seq_item actual_trans;
    register_seq_item expected_trans;
    string msg;
    // Wait until both streams contain a transaction
    if ((actual_trans_q.size() == 0) || (expected_trans_q.size() == 0)) begin
      return;
    end
    // Get transactions in FIFO order
    actual_trans = actual_trans_q.pop_front();
    expected_trans = expected_trans_q.pop_front();
    // Count transaction
    total_transactions++;
    // Compare
    if ((actual_trans.rst_n === expected_trans.rst_n) && (actual_trans.d  === expected_trans.d) && (actual_trans.q    === expected_trans.q)) begin
      // PASS
      passed_transactions++;
      msg = $sformatf("PASS: rst_n=%0b d=%0h expected_q=%0h actual_q=%0h", actual_trans.rst_n, actual_trans.d, expected_trans.q, actual_trans.q);
      `uvm_info("SCOREBOARD", msg, UVM_MEDIUM);
    end
    else begin
      // FAIL
      failed_transactions++;
      msg = $sformatf("FAIL: rst_n=%0b d=%0h expected_q=%0h actual_q=%0h", actual_trans.rst_n, actual_trans.d, expected_trans.q, actual_trans.q);
      `uvm_error("SCOREBOARD", msg);
    end
  endfunction
  // Report Phase
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", "===", UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Total Transactions : %0d", total_transactions), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Passed Transactions: %0d", passed_transactions), UVM_NONE)
    `uvm_info("SCOREBOARD", $sformatf("Failed Transactions: %0d", failed_transactions), UVM_NONE)
    // Check for unmatched transactions
    if (actual_trans_q.size() != 0) begin
      `uvm_error("SCOREBOARD", $sformatf("Unmatched actual transactions remaining: %0d", actual_trans_q.size()))
    end
    if (expected_trans_q.size() != 0) begin
      `uvm_error("SCOREBOARD", $sformatf("Unmatched expected transactions remaining: %0d", expected_trans_q.size()))
    end
    // Final Result
    if ((failed_transactions == 0) && (actual_trans_q.size() == 0) && (expected_trans_q.size() == 0)) begin
      `uvm_info("SCOREBOARD", "SCOREBOARD RESULT : PASS", UVM_NONE);
    end
    else begin
      `uvm_error( "SCOREBOARD", "SCOREBOARD RESULT : FAIL");
    end
    `uvm_info("SCOREBOARD", "===", UVM_NONE)
  endfunction
endclass

