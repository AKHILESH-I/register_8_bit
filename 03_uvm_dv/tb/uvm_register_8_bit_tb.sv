`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;
import register_pkg::*;

module register_8_bit_tb;
  // Clock
  logic clk;
  // Interface
  register_if vif(clk);
  // DUT
  register_8_bit dut (.clk(clk), .rst_n (vif.rst_n), .d(vif.d), .q(vif.q));
  // Assertions
  register_assertions assertions (.clk(clk), .rst_n(vif.rst_n), .d(vif.d), .q(vif.q));
  // Clock generation
  initial begin
    clk = 1'b0;
    forever begin
      #5 clk = ~clk;
    end
  end
  // Provide virtual interface to UVM
  initial begin
    uvm_config_db#(virtual register_if)::set(null, "*", "vif", vif);
  end
  // Start UVM
  initial begin
    run_test("register_test");
  end
endmodule
