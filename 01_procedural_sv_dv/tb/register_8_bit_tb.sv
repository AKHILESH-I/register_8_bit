// Project 1: Procedural SystemVerilog DV Baseline

//============================================================
// Project      : 8-bit Register Verification
// Stage        : Procedural SystemVerilog DV
// File         : register_8_bit_tb.sv
// Simulator    : QuestaSim
// Repository   : https://github.com/AKHILESH-I/register_8_bit
//============================================================

module register_8_bit_tb;
  logic clk;
  logic rst_n;
  logic [7:0] d;
  logic [7:0] q;
  //Reference Model
  logic [7:0] expected_q;
  //Testbench control
  bit   hold_fail;
  logic capture_check_en;
  //DUT Instantiation
  register_8_bit dut(.clk(clk), .rst_n(rst_n), .d(d), .q(q));
  //Clock Generation
  initial clk = 0;
  always #5 clk = ~clk;
  //Functional Coverage
  covergroup register_cg @(posedge clk);
    //Data Value Coverage
    cp_d: coverpoint d{
      bins all_zero = {8'h00};
      bins all_one = {8'hFF};
      bins pattern_AA = {8'hAA};
      bins pattern_55 = {8'h55};
      bins low_values = {[8'h01 : 8'h0F]};
      bins mid_values = {
        [8'h10 : 8'h54],
        [8'h56 : 8'hA9],
        [8'hAB : 8'hEF]
       };
      bins high_values = {[8'hF0 : 8'hFE]};
    }
    //Data Transition Coverage
    cp_d_transition: coverpoint d{
      bins zero_to_one = (8'h00 => 8'hFF);
      bins one_to_zero = (8'hFF => 8'h00);
      bins AA_to_55 = (8'hAA => 8'h55);
      bins pattern_55_to_AA = (8'h55 => 8'hAA);
    }
    //Reset State Coverage
    cp_reset: coverpoint rst_n{
      bins reset_active = {1'b0};
      bins reset_inactive = {1'b1};
    }
    //Reset Transition Coverage
    cp_reset_transition: coverpoint rst_n{
      bins reset_assert  = (1'b1 => 1'b0);
      bins reset_release = (1'b0 => 1'b1);
    }
    //Output Coverage
    cp_q: coverpoint q {
      bins all_zero   = {8'h00};
      bins all_one    = {8'hFF};
      bins pattern_AA = {8'hAA};
      bins pattern_55 = {8'h55};
    }
    //Important Data Categories for Reset Cross
    cp_d_reset_category: coverpoint d {
      bins all_zero = {8'h00};
      bins all_one  = {8'hFF};
      bins pattern_AA   = {8'hAA};
      bins pattern_55  = {8'h55};
    }
    //Data × Reset
    cross cp_d_reset_category, cp_reset;
  endgroup
  register_cg cg = new();
  //Asynchronous Reset Coverage
  covergroup register_reset_cg @(negedge rst_n);
    cp_reset_assert: coverpoint rst_n{
      bins reset_asserted  = {1'b0};
    }
  endgroup
  //Instantiate reset coverage
  register_reset_cg reset_cg = new();
  //Reference Model
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      expected_q <= 8'h00;
    else
      expected_q <= d;
  end
  //Asynchronous Reset Assertion
  always @(negedge rst_n) begin
     #1;
    assert (q === 8'h00)
    else
      $error(
        "[%0t] ASYNC RESET FAILED : q = %0h",
        $time,
        q
      );
  end
  //Capture logic
  //Property
  property p_capture;
    @(posedge clk)
    disable iff(!rst_n)
    capture_check_en |=> q === $past(d);
  endproperty
  //Assertion
  a_capture:
  assert property(p_capture)
  else
    $error(
      "[%0t] Capture Failed : expected = %0h actual = %0h",
      $time,
      $past(d),
      $sampled(q)
    );
  //Reset dominance
  //Property
  property p_reset_dominance;
    @(posedge clk)
    !rst_n |-> q === 8'h00;
  endproperty
  //Assertion
  a_reset_dominance:
  assert property(p_reset_dominance)
  else
    $error(
      "[%0t] Reset dominance Failed q = %0h",
      $time,
      $sampled(q)
    );
  //X/Z Check
  property p_q_known;
    @(posedge clk)
    disable iff(!rst_n)
    !$isunknown(q);
  endproperty
  //Assertion
  a_q_known:
  assert property(p_q_known)
  else
    $error(
      "[%0t] X/Z CHECK FAILED : q = %0h",
      $time,
      $sampled(q)
    );
  //Stimulus
  initial begin
    hold_fail = 0;
    capture_check_en = 0;
  //TEST 1 : ASYNC RESET
    $display(" TEST 1 : ASYNCHRONOUS RESET ");
    rst_n = 0;  //ACTIVE
    d = 8'h00;
    @(posedge clk);
    @(negedge clk);
    rst_n = 1;
    d = 8'h01;
    @(posedge clk);
    #2;
    rst_n = 0;
    #1;
    if(q !== 8'h00)
      $error("[%0t] ASYNC RESET FAILED: q = %0h",$time, q);
    else
      $display("[%0t] ASYNC RESET PASSED: q = %0h", $time, q);
    #3;
    rst_n = 1;
  //TEST 2 : CAPTURE 00
    $display("TEST 2 : CAPTURE 00");
    @(negedge clk);
    d = 8'h00;
    capture_check_en = 1;
    @(posedge clk);
    #1;
    if(q !== 8'h00)
      $error("[%0t] CAPTURE 00 FAILED: d = %0h q = %0h",$time, d, q);
    else
      $display("[%0t] CAPTURE 00 PASSED", $time);
    #3;
  //TEST 3 : CAPTURE AA
    $display(" TEST 3 : CAPTURE AA");
    @(negedge clk);
    d = 8'hAA;
    @(posedge clk);
    #1;
    if(q !== 8'hAA)
      $error("[%0t] CAPTURE AA FAILED: d = %0h q = %0h", $time, d, q);
    else
      $display("[%0t] CAPTURE AA PASSED", $time);
  //TEST 4 : CAPTURE FF
    $display("TEST 4 : CAPTURE FF");
    @(negedge clk);
    d = 8'hFF;
    @(posedge clk);
    #1;
    if(q !== 8'hFF)
      $error("[%0t] capture FF Failed: d = %0h q = %0h", $time, d, q);
    else
      $display("[%0t] CAPTURE FF PASSED", $time);
  //TEST 5 : HOLD
    @(negedge clk);
    d = 8'hAA;
    //No Clock Edge Here
    //Q must remain FF
    hold_fail = 0;
    repeat(4) begin
      #1;
      if(q !== 8'hFF) begin
        hold_fail = 1;
        $error("[%0t] HOLD FAILED : expected=8'hFF actual=%0h", $time, q);
      end
    end
    if(!hold_fail)
      $display("HOLD PASSED");
  //TEST 6 : CAPTURE 55
    $display(" TEST 6 : CAPTURE 55 ");
      @(negedge clk);
      d = 8'h55;
      @(posedge clk);
      #1;
      if(q !== 8'h55)
        $error("[%0t] CAPTURE 55 FAILED : d = %0h q = %0h", $time, d, q);
      else
        $display("[%0t] CAPTURE 55 PASSED", $time);
  //TRANSITION COVERAGE STIMULUS
    //00 -> FF
    @(negedge clk);
    d = 8'h00;
    @(posedge clk);
    #1;
    @(negedge clk);
    d = 8'hFF;
    @(posedge clk);
    #1;
    //FF -> 00
    @(negedge clk);
    d = 8'h00;
    @(posedge clk);
    #1;
    //55 -> AA
    @(negedge clk);
    d = 8'h55;
    @(posedge clk);
    #1;
    @(negedge clk);
    d = 8'hAA;
    @(posedge clk);
    #1;
    //AA -> 55
    @(negedge clk);
    d = 8'hAA;
    @(posedge clk);
    #1;
    @(negedge clk);
    d = 8'h55;
    @(posedge clk);
    #1;
  //TEST 7 : Randomized stimulus
    $display(" TEST 7 : RANDOM ");
    repeat(50) begin
      @(negedge clk);
      d = $urandom_range(8'h00, 8'hFF);
      @(posedge clk);
      #1;
      if(q !== expected_q)
        $error(
          "[%0t] FAILED : d = %0h expected=%0h actual=%0h",
          $time,
          d,
          expected_q,
          q
        );
      else
        $display(
          "[%0t] PASSED: d = %0h q = %0h",
          $time,
          d,
          q
        );
    end
  //TEST 8 : RESET DOMINANCE
    $display("TEST 8 : RESET DOMINANCE");
    rst_n = 0;
    // Reset + 00
    @(negedge clk);
    d = 8'h00;
    @(posedge clk);
    #1;
    if(q !== 8'h00)
      $error("[%0t] RESET + 00 FAILED", $time);
    // Reset + FF
    @(negedge clk);
    d = 8'hFF;
    @(posedge clk);
    #1;
    if(q !== 8'h00)
      $error("[%0t] RESET + FF FAILED", $time);
    // Reset + AA
    @(negedge clk);
    d = 8'hAA;
    @(posedge clk);
    #1;
    if(q !== 8'h00)
      $error("[%0t] RESET + AA FAILED", $time);
    // Reset + 55
    @(negedge clk);
    d = 8'h55;
    @(posedge clk);
    #1;
    if(q !== 8'h00)
      $error("[%0t] RESET + 55 FAILED", $time);
    $display("RESET DATA COMBINATIONS PASSED");
    repeat(10) begin
      @(negedge clk);
      d = $urandom_range(8'h00, 8'hFF);
      #1;
      if(q !== 8'h00)
        $error("[%0t] FAILED : q changed while reset active", $time);
      @(posedge clk);
      #1;
      if(q !== 8'h00)
        $error("[%0t] FAILED : q captured data during reset", $time);
    end
    $display("RESET DOMINANCE PASSED");
  //END
    rst_n = 1;
    @(posedge clk);
    #1;
    $display("All Tests COMPLETED");
    $display("REGISTER Coverage = %0.2f%%", cg.get_coverage());
    $display("REGISTER Reset Coverage = %0.2f%%", reset_cg.get_coverage());
  $finish;
  end
endmodule
