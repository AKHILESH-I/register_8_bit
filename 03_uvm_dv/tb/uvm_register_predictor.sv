`include "uvm_macros.svh"
import uvm_pkg::*;

class register_predictor extends uvm_component;
  `uvm_component_utils(register_predictor)
  // Monitor -> Predictor
  uvm_analysis_imp #(register_seq_item, register_predictor)
    analysis_export;
  // Predictor -> Scoreboard
  uvm_analysis_port #(register_seq_item)
    analysis_port;
  // Reference Model State
  bit [7:0] expected_q;
  // Constructor
  function new(string name = "register_predictor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create analysis implementation
    analysis_export =
      new("analysis_export", this);
    // Create analysis port
    analysis_port =
      new("analysis_port", this);
    // Initialize reference model
    expected_q = 8'h00;
  endfunction
  // Reference Model
  virtual function void write(register_seq_item trans);
    register_seq_item predicted_trans;
    // Reference Model
    if (!trans.rst_n)
      expected_q = 8'h00;
    else
      expected_q = trans.d;
    // Create Expected Transaction
    predicted_trans = register_seq_item::type_id::create("predicted_trans");
    predicted_trans.rst_n = trans.rst_n;
    predicted_trans.d = trans.d;
    predicted_trans.q = expected_q;
    // Mark transaction as EXPECTED
    predicted_trans.trans_type = EXPECTED;
    // Display Expected Transaction
    `uvm_info("PREDICTOR", $sformatf("Expected: rst_n=%0b d=%0h expected_q=%0h", predicted_trans.rst_n, predicted_trans.d, predicted_trans.q), UVM_MEDIUM)
    // Send Expected Transaction To Scoreboard
    analysis_port.write(predicted_trans);
  endfunction
endclass

