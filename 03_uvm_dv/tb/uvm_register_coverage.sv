`include "uvm_macros.svh"
import uvm_pkg::*;

class register_coverage extends uvm_subscriber #(register_seq_item);
  //Factory registration
  `uvm_component_utils(register_coverage)
  //Transaction received from monitor
  register_seq_item trans;
  //Functional coverage
  covergroup register_cg;
    //Data value coverage
    cp_d: coverpoint trans.d{
      bins all_zero = {8'h00};
      bins all_one = {8'hFF};
      bins pattern_AA = {8'hAA};
      bins pattern_55 = {8'h55};
      bins low_values = {[8'h01 : 8'h0F]};
      bins mid_values = {[8'h10 : 8'hEF]};
      bins high_values = {[8'hF0 : 8'hFE]};
    }
    //Reset coverage
    cp_rst_n: coverpoint trans.rst_n{
      bins reset_active = {1'b0};
      bins reset_inactive = {1'b1};
    }
    //Output coverage
    cp_q: coverpoint trans.q{
      bins all_zero = {8'h00};
      bins all_one = {8'hFF};
      bins pattern_AA = {8'hAA};
      bins pattern_55 = {8'h55};
    }
    //d * rst_n
    cross cp_d, cp_rst_n;
  endgroup
  //Constructor
  function new(string name = "register_coverage", uvm_component parent = null);
    super.new(name, parent);
    register_cg = new();
  endfunction
  //Receive transaction from monitor
  virtual function void write(register_seq_item t);
    trans = t;
    //Sample coverage
    register_cg.sample();
    `uvm_info("COVERAGE", $sformatf("Sampled rst_n = %0b, d = %0h, q = %0h", trans.rst_n, trans.d, trans.q), UVM_HIGH);
  endfunction
  //Final coverage report
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("Functional coverage = %0.2f%%", register_cg.get_coverage()), UVM_NONE);
  endfunction
endclass
