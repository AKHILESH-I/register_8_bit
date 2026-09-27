`include "uvm_macros.svh"
import uvm_pkg::*;

class register_sequence extends uvm_sequence #(register_seq_item);
  `uvm_object_utils(register_sequence)
  register_config cfg;
  function new(string name = "register_sequence");
    super.new(name);
  endfunction
  virtual task body();
    register_seq_item req;
    if (!uvm_config_db#(register_config)::get(null, "", "cfg", cfg)) begin
      `uvm_fatal("SEQ_CFG", "register_config not found")
    end
    if (cfg.num_transactions < 10) begin
      `uvm_fatal("SEQ_COUNT", $sformatf("num_transactions must be >= 10, current value = %0d", cfg.num_transactions))
    end
    // RESET-DIRECTED TRANSACTIONS
    // 1. reset + 00
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'h00;
    finish_item(req);
    // 2. reset + FF
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'hFF;
    finish_item(req);
    // 3. reset + AA
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'hAA;
    finish_item(req);
    // 4. reset + 55
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'h55;
    finish_item(req);
    // 5. reset + 01
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'h01;
    finish_item(req);
    // 6. reset + 80
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'h80;
    finish_item(req);
    // 7. reset + F0
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b0;
    req.d     = 8'hF0;
    finish_item(req);
    // RESET RELEASE
    // 8. reset inactive + 00
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b1;
    req.d     = 8'h00;
    finish_item(req);
    // ACTIVE-STATE COVERAGE CLOSURE
    // 9. reset inactive + 55
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b1;
    req.d     = 8'h55;
    finish_item(req);
    // 10. reset inactive + 01
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b1;
    req.d     = 8'h01;
    finish_item(req);
    // 11. reset inactive + FF
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b1;
    req.d     = 8'hFF;
    finish_item(req);
    // 12. reset inactive + F0
    req = register_seq_item::type_id::create("req");
    start_item(req);
    req.rst_n = 1'b1;
    req.d     = 8'hF0;
    finish_item(req);
    // CONSTRAINED-RANDOM TRANSACTIONS
    // Preserve the configured total transaction count.
    repeat (cfg.num_transactions - 12) begin
      req = register_seq_item::type_id::create("req");
      start_item(req);
      if (!req.randomize()) begin
        `uvm_fatal("SEQ_RAND", "Failed to randomize register_seq_item")
      end
      finish_item(req);
    end
  endtask
endclass

