class register_monitor;
  //Virtual interface
  virtual register_if.MONITOR vif;
  //Monitor to Scoreboard mailbox
  mailbox #(register_transaction) mon2scb;
  //Constructor
  function new(
    virtual register_if.MONITOR vif,
    mailbox #(register_transaction) mon2scb
  );
    if(vif == null)
      $fatal(1,"[Monitor] virtual interface is null");
    if(mon2scb == null)
      $fatal(1,"[Monitor] mon2scb mailbox is null");
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  //Run task
  task run();
    //Transaction handle
    register_transaction tx;

    @(vif.monitor_cb);
    forever begin
      //Wait for Mon cb event
      @(vif.monitor_cb);
      //create a transaction
      tx = new();
      //Sample DUT interface
      tx.rst_n = vif.monitor_cb.rst_n;
      tx.d = vif.monitor_cb.d;
      tx.q = vif.monitor_cb.q;
      //Display
      tx.display("Monitor");
      //Send transaction to Scoreboard
      mon2scb.put(tx);
    end
  endtask
endclass
