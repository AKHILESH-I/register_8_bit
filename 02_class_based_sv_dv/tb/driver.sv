class register_driver;
  //Virtual interface
  virtual register_if.DRIVER vif;
  //Gen to Drv mailbox
  mailbox #(register_transaction) gen2drv;
  //Constructor
  function new(
    virtual register_if.DRIVER vif,
    mailbox #(register_transaction) gen2drv
  );
    if(vif == null)
      $fatal(1, "[Driver] Virtual interface is null");
    if(gen2drv == null)
      $fatal(1, "[Driver] gen2drv mailbox is null");
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  // Drive Transaction
  task drive_transaction(register_transaction tx);
    // Wait for the driver clocking event
    @(vif.driver_cb);
    // Drive reset
    vif.driver_cb.rst_n <= tx.rst_n;
    // Drive data
    vif.driver_cb.d <= tx.d;
    // Display transaction
    tx.display("Driver");
  endtask
  //Run task
  task run();
    //Transaction handle
    register_transaction tx;
    forever begin
      // Get transaction from Generator
      gen2drv.get(tx);
      //Drive transaction
      drive_transaction(tx);
    end
  endtask
endclass
