`include "uvm_macros.svh"
import uvm_pkg::*;

class register_env extends uvm_env;
  `uvm_component_utils(register_env)
  //UVM Components
  register_agent agent;
  register_predictor  predictor;
  register_scoreboard scoreboard;
  register_coverage   coverage;
  // Configuration
  register_config cfg;
  // Constructor
  function new(string name = "register_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  // Build Phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get configuration
    if(!uvm_config_db#(register_config)::get( this, "", "cfg", cfg)) begin
      `uvm_fatal("ENV_CFG", "register_config not found")
    end
    // Create Agent
    agent = register_agent::type_id::create("agent", this);
    // Create Predictor
    predictor = register_predictor::type_id::create("predictor", this);
    // Create Scoreboard
    if(cfg.has_scoreboard) begin
      scoreboard = register_scoreboard::type_id::create("scoreboard", this);
    end
    // Create Coverage
    if (cfg.has_coverage) begin
      coverage = register_coverage::type_id::create("coverage", this);
    end
  endfunction
  // Connect Phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // Monitor -> Scoreboard
    if (cfg.has_scoreboard) begin
      agent.monitor.analysis_port.connect(scoreboard.actual_export);
    end
    // Monitor -> Coverage
    if (cfg.has_coverage) begin
      agent.monitor.analysis_port.connect(coverage.analysis_export);
    end
    // Monitor -> Predictor
    agent.monitor.analysis_port.connect(predictor.analysis_export);
    // Predictor -> Scoreboard
    if (cfg.has_scoreboard) begin
      predictor.analysis_port.connect(scoreboard.expected_export);
    end
  endfunction
endclass
