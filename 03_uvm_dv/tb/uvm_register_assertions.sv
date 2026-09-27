`timescale 1ns/1ps

module register_assertions(
  input logic       clk,
  input logic       rst_n,
  input logic [7:0] d,
  input logic [7:0] q
);
  // 1. ASYNCHRONOUS RESET CHECK
  // Whenever reset is asserted, q must become 0.
  always @(negedge rst_n) begin
    #1step;
    assert (q === 8'h00)
    else
      $error("[%0t] ASYNC RESET FAILED: q = %0h", $time, q);
  end
  // 2. RESET DOMINANCE
  // While reset is active, q must remain 0.
  property p_reset_dominance;
    @(posedge clk)
      !rst_n |-> q === 8'h00;
  endproperty
  a_reset_dominance:
    assert property (p_reset_dominance)
    else
      $error("[%0t] RESET DOMINANCE FAILED: q = %0h", $time, q);
  // 3. REGISTER CAPTURE
  // q captures d on the clock edge when reset is inactive.
  property p_capture;
    @(posedge clk)
      disable iff (!rst_n)
      $past(rst_n) && rst_n |-> q === $past(d);
  endproperty
  a_capture:
    assert property (p_capture)
    else
      $error("[%0t] CAPTURE FAILED: expected q = %0h actual q = %0h", $time, $past(d), q);
  // 4. X/Z CHECK
  // q must not contain X/Z while reset is inactive.
  always @(posedge clk) begin
    #1step;
    if (rst_n) begin
      assert (!$isunknown(q))
      else
        $error("[%0t] X/Z CHECK FAILED: q = %0h", $time, q);
    end
  end
endmodule

