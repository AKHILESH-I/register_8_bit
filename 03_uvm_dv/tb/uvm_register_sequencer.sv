`include "uvm_macros.svh"
import uvm_pkg::*;

class register_sequencer extends uvm_sequencer #(register_seq_item);
  //Constructor
  function new(string name = "register_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  //Factory registration
  `uvm_component_utils(register_sequencer)
endclass
