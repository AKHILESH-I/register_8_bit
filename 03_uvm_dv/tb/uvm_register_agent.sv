`include "uvm_macros.svh"
import uvm_pkg::*;

class register_agent extends uvm_agent;
  //UVM components
  register_sequencer sequencer;
  register_driver driver;
  register_monitor monitor;
  //Configuration
  register_config cfg;
  //constructor
  function new(string name = "register_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  //Factory registration
  `uvm_component_utils(register_agent)
  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(register_config)::get(this, "", "cfg", cfg)) begin
      `uvm_fatal("AGT_CFG", "register_config is not found")
    end
    //Create monitor
    monitor = register_monitor::type_id::create("monitor", this);
    //Create active components
    if(cfg.is_active == UVM_ACTIVE) begin
      sequencer = register_sequencer::type_id::create("sequencer", this);
      driver = register_driver::type_id::create("driver", this);
    end
  endfunction
  //Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass
