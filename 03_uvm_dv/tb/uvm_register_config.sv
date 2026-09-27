`include "uvm_macros.svh"
import uvm_pkg::*;
class register_config extends uvm_object;
  //Virtual interface
  virtual register_if vif;
  //Environment configuration
  bit has_scoreboard = 1;
  bit has_coverage = 1;
  //Agent configuration
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  //Number of transaction
  int unsigned num_transactions = 20;
  //Constructor
  function new(string name = "register_config");
    super.new(name);
  endfunction
  //Factory registration
  `uvm_object_utils_begin(register_config)
    `uvm_field_int(has_scoreboard, UVM_DEFAULT)
    `uvm_field_int(has_coverage, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
    `uvm_field_int(num_transactions, UVM_DEFAULT)
  `uvm_object_utils_end
endclass
