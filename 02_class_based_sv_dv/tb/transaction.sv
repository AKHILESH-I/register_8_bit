class register_transaction;
  //Stimulus fields
  rand bit rst_n;
  rand bit [7:0] d;
  //Observed DUT output
  logic [7:0] q;
  // Constraints
  constraint c_reset_distribution {
    rst_n dist {1'b1 := 80, 1'b0 := 20};
  }
  //Constructor
  function new();
    // Default stimulus values
    rst_n = 1'b1;
    d     = 8'h00;
    q     = 8'hXX;
  endfunction
  //Display transaction
  function void display(string tag = "TRANSACTION");
    $display(
      "[%0t] %s : rst_n = %0b d = %0h q = %0h",
      $time,
      tag,
      rst_n,
      d,
      q
    );
  endfunction
  // Compare Transactions
  function bit compare(register_transaction rhs);
    if (rhs == null)
      return 0;
    if (this.rst_n !== rhs.rst_n)
      return 0;
    if (this.d !== rhs.d)
      return 0;
    if (this.q !== rhs.q)
      return 0;
    return 1;
  endfunction
  //Copy transaction
  function register_transaction copy();
    register_transaction tx_copy;
    tx_copy = new();
    tx_copy.rst_n = this.rst_n;
    tx_copy.d = this.d;
    tx_copy.q = this.q;
    return tx_copy;
  endfunction
endclass
