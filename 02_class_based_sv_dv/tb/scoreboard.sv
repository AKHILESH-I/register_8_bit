class register_scoreboard;
  //Mon to Scb mailbox
  mailbox #(register_transaction) mon2scb;
  //Transaction received form Monitor
  register_transaction tx;
  //Reference model
  bit [7:0] expected_q;
  //Counters
  int pass_count;
  int fail_count;
  int processed_count;
  int expected_transactions;
  //Constructor
  function new(
    mailbox #(register_transaction) mon2scb,
    int expected_transactions = 20
  );
    if (mon2scb == null)
      $fatal(1, "[Scoreboard] mon2scb mailbox is null");
    if (expected_transactions <= 0)
      $fatal(
        1,
        "[Scoreboard] Expected transaction count must be > 0"
      );
    this.mon2scb = mon2scb;
    this.expected_transactions = expected_transactions;
    // Register reset value
    expected_q = 8'h00;
    pass_count = 0;
    fail_count = 0;
    processed_count = 0;
  endfunction
  //Reference model
  function void predict(register_transaction tx);
    if(!tx.rst_n)
      expected_q = 8'h00;
  endfunction
  // Compare DUT output with Reference Model
  function void check(register_transaction tx);
    if(tx.q === expected_q) begin
      pass_count++;
      $display("[%0t] SCB Pass: rst_n = %0b d = %0h expected_q = %0h q = %0h",
        $time, tx.rst_n, tx.d, expected_q, tx.q);
    end
    else begin
      fail_count++;
      $error("[%0t] SCB Fail: rstn = %0b d = %0h expected_q = %0h q = %0h",
        $time, tx.rst_n, tx.d, expected_q, tx.q);
    end
  endfunction
  //Run task
  task run();
    forever begin
      //Wait for Transaction from Monitor
      mon2scb.get(tx);
      // Calculate expected DUT output
      predict(tx);
      // Compare actual DUT output
      check(tx);
      //Update reference model
      if(tx.rst_n)
        expected_q = tx.d;
      //Transaction processed
      processed_count++;
    end
  endtask
  //Report
  function void report();
    $display("Expected transactions = %0d", expected_transactions);
    $display("Processed transactions = %0d", processed_count);
    $display("Pass count = %0d", pass_count);
    $display("Fail count = %0d", fail_count);
    if(processed_count != expected_transactions) begin
      $error(
        "[Scoreboard] Transaction count mismatch: expected = %0d processed = %0d",
        expected_transactions, processed_count
      );
    end
    if((fail_count == 0) && (processed_count == expected_transactions))
      $display("Scb result = Pass");
    else
      $display("Scb result = Fail");
  endfunction
endclass
