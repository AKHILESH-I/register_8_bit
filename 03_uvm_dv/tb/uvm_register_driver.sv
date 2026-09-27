`include "uvm_macros.svh"
import uvm_pkg::*;

class register_driver extends uvm_driver #(register_seq_item);
  virtual register_if vif;
  register_config cfg;
  function new(string name = "register_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  `uvm_component_utils(register_driver)
  // BUILD PHASE
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(register_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("DRV_CFG", "register_config not found")
    end
    vif = cfg.vif;
    if (vif == null) begin
      `uvm_fatal("DRV_VIF", "Virtual interface is null")
    end
  endfunction
  // RUN PHASE
  virtual task run_phase(uvm_phase phase);
    register_seq_item req;
    // No transaction is valid initially
    vif.valid <= 1'b0;
    forever begin
      // Get transaction from sequencer
      seq_item_port.get_next_item(req);
      // Drive transaction
      drive_transaction(req);
      // Tell sequencer transaction is complete
      seq_item_port.item_done();
    end
  endtask
  // DRIVE TRANSACTION
  virtual task drive_transaction(register_seq_item req);
    // Drive before the next sampling edge
    @(negedge vif.clk);
    // Mark transaction as valid
    vif.valid <= 1'b1;
    // Drive DUT inputs
    vif.rst_n <= req.rst_n;
    vif.d     <= req.d;
    `uvm_info("DRIVER", $sformatf("driving rst_n = %0b d = %0h", req.rst_n, req.d), UVM_MEDIUM)
    // Allow monitor to sample this transaction
    @(posedge vif.clk);
    // Transaction is no longer valid
    @(negedge vif.clk);
    vif.valid <= 1'b0;
  endtask
endclass

