class register_environment;
  //Components
  register_generator gen;
  register_driver drv;
  register_monitor mon;
  register_scoreboard scb;
  //Mailboxes
  mailbox #(register_transaction) gen2drv;
  mailbox #(register_transaction) mon2scb;
  //Virtual interfaces
  virtual register_if.DRIVER drv_vif;
  virtual register_if.MONITOR mon_vif;
  // Configuration
  int num_transactions;
  //Constructor
  function new(
    virtual register_if.DRIVER drv_vif,
    virtual register_if.MONITOR mon_vif,
    int num_transactions = 20
  );
  if (drv_vif == null)
    $fatal(1, "[Environment] Driver virtual interface is null");
  if (mon_vif == null)
    $fatal(1, "[Environment] Monitor virtual interface is null");
  if (num_transactions <= 0)
    $fatal(1, "[Environment] Number of transactions must be > 0");
    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.num_transactions = num_transactions;
  endfunction
  //Build Environment
  function void build();
    //Create mailboxes
    gen2drv = new();
    mon2scb = new();
    //Create components
    gen = new(gen2drv, num_transactions);
    drv = new(drv_vif, gen2drv);
    mon = new(mon_vif, mon2scb);
    scb = new(mon2scb, num_transactions);
  endfunction
  //Run Environment
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
    //Wait until Scoreboard has processed
    wait(scb.processed_count == num_transactions);
    $display(
      "[%0t] Environment completed: %0d transactions processed",
      $time,
      scb.processed_count
    );
  endtask
  //Report
  function void report();
    scb.report();
  endfunction
endclass
