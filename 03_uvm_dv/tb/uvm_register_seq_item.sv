`include "uvm_macros.svh"
import uvm_pkg::*;
typedef enum {
  ACTUAL,
  EXPECTED
} register_trans_type;
class register_seq_item extends uvm_sequence_item;
  // Transaction fields
  rand bit       rst_n;
  rand bit [7:0] d;
  // DUT response
  bit [7:0] q;
  // Transaction type
  register_trans_type trans_type;
  // Data Constraint
  constraint data_distribution_c {
    d dist {8'h00 := 10, 8'hFF := 10, 8'hAA := 10, 8'h55 := 10, [8'h01:8'hFE] :/ 60};
  }
  // Reset Constraint
  constraint reset_constraint_c {
    rst_n dist {1'b0 := 10, 1'b1 := 90};
  }
  // Constructor
  function new(string name = "register_seq_item");
    super.new(name);
  endfunction
  // UVM factory registration
  `uvm_object_utils_begin(register_seq_item)
    `uvm_field_int(rst_n, UVM_DEFAULT)
    `uvm_field_int(d, UVM_DEFAULT)
    `uvm_field_int(q, UVM_DEFAULT)
    `uvm_field_enum(register_trans_type, trans_type, UVM_DEFAULT)
  `uvm_object_utils_end
endclass
