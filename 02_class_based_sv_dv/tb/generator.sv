class register_generator;
  //Mailbox Gen to Drv
  mailbox #(register_transaction) gen2drv;
  // Number of transactions
  int num_transactions;
  //Generator completion event
  event gen_done;
  //Constructor
  function new(
    mailbox #(register_transaction) gen2drv,
    int num_transactions = 20
  );
    if(gen2drv == null)
      $fatal(1, "[Generator] gen2drv mailbox is null");
    if(num_transactions <= 0)
      $fatal(1, "[Generator] Number of transactions must be > 0");
    this.gen2drv = gen2drv;
    this.num_transactions = num_transactions;
  endfunction
  //Run task
  task run();
    //Transaction handle
    register_transaction tx;
    repeat(num_transactions) begin
      // Create a new transaction
      tx = new();
      // Randomize transaction
      if(!tx.randomize()) begin
        $fatal(
          1,
          "[Generator] Transaction randomization failed"
        );
      end
      // Display generated transaction
      tx.display("Generator");
      // Send transaction to Driver
      gen2drv.put(tx.copy());
    end
    // Generator completed
    $display("[%0t] Generator generated %0d transactions", $time, num_transactions);
    //Signal completion
    -> gen_done;
  endtask
endclass
