`include "uvm_macros.svh"
import uvm_pkg::*;

class register_monitor extends uvm_monitor;
  `uvm_component_utils(register_monitor)
  virtual register_if vif;
  register_config cfg;
  uvm_analysis_port #(register_seq_item) analysis_port;
  // CONSTRUCTOR
  function new(string name = "register_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  // BUILD PHASE
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(register_config)::get( this, "", "cfg", cfg)) begin
      `uvm_fatal("MON_CFG", "register_config not found")
    end
    vif = cfg.vif;
    if (vif == null) begin
      `uvm_fatal( "MON_VIF", "Virtual interface is null")
    end
    analysis_port = new("analysis_port", this);
  endfunction
  // RUN PHASE
  virtual task run_phase(uvm_phase phase);
    register_seq_item trans;
    forever begin
      // Wait for clock edge
      @(vif.monitor_cb);
      // Ignore cycles that are not associated
      // with a real driver transaction
      if (!vif.monitor_cb.valid)
        continue;
      // Create transaction
      trans = register_seq_item::type_id::create("trans");
      // Sample DUT signals
      trans.rst_n = vif.monitor_cb.rst_n;
      trans.d = vif.monitor_cb.d;
      trans.q = vif.monitor_cb.q;
      trans.trans_type = ACTUAL;
      `uvm_info("MONITOR", $sformatf("Sampled rst_n=%0b d=%0h q=%0h", trans.rst_n, trans.d, trans.q), UVM_MEDIUM)
      // Send transaction to subscribers
      analysis_port.write(trans);
    end
  endtask
endclass

