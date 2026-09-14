import register_pkg::*;

module register_8_bit_tb;
  //Clock
  logic clk;
  initial begin
    clk = 1'b0;
  end
  always #5 clk = ~clk;
  //Interface
  register_if reg_if(clk);
  //DUT
  register_8_bit dut(.clk(clk), .rst_n(reg_if.rst_n), .d(reg_if.d), .q(reg_if.q));
  //Virtual interface
  virtual register_if.DRIVER drv_vif;
  virtual register_if.MONITOR mon_vif;
  //Environment
  register_environment env;
  //Test
  initial begin
    //Initialize interface
    reg_if.rst_n = 1'b0;
    reg_if.d = 8'h00;
    //Allow initial reset to propagate
    #2;
    //Connect virtual interfaces
    drv_vif = reg_if;
    mon_vif = reg_if;
    env = new(drv_vif, mon_vif, 20);
    //Build environment
    env.build();
    //Run environment
    env.run();
    //Scoreboard report
    env.report();
    //End simulation
    $finish;
  end
endmodule
