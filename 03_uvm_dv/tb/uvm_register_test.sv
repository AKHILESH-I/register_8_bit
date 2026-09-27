`include "uvm_macros.svh"
import uvm_pkg::*;

class register_test extends uvm_test;
  `uvm_component_utils(register_test)
  // Environment
  register_env env;
  // Configuration
  register_config cfg;
  // Constructor
  function new(string name = "register_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create Configuration Object
    cfg = register_config::type_id::create("cfg");
    // Configuration Settings
    cfg.has_scoreboard   = 1;
    cfg.has_coverage     = 1;
    cfg.is_active        = UVM_ACTIVE;
    cfg.num_transactions = 20;
    // Get Virtual Interface From Top-Level Testbench
    if (!uvm_config_db#(virtual register_if)::get( this, "", "vif", cfg.vif)) begin
      `uvm_fatal("TEST_VIF", "Virtual interface not found")
    end
    // Put Complete Configuration Into Config DB
    uvm_config_db#(register_config)::set(null, "*", "cfg", cfg);
    // Create Environment
    env = register_env::type_id::create("env", this);
  endfunction
  // Run Phase
  virtual task run_phase(uvm_phase phase);
    register_sequence seq;
    // Raise Objection
    phase.raise_objection(this);
    `uvm_info("TEST", "Starting register UVM test", UVM_LOW)
    // Create Sequence
    seq = register_sequence::type_id::create("seq");
    // Start Sequence
    `uvm_info("TEST", "Starting register sequence", UVM_LOW)
    seq.start(env.agent.sequencer);
    // Allow Final Monitor Sample To Complete
    @(cfg.vif.monitor_cb);
    // Test Completed
    `uvm_info("TEST", "Register UVM test completed", UVM_LOW)
    // Drop Objection
    phase.drop_objection(this);
  endtask
endclass

