interface register_if(input logic clk);
  // DUT Signals
  logic rst_n;
  logic [7:0] d;
  logic [7:0] q;
  // Transaction valid indicator
  logic valid;
  // Driver clocking block
  clocking driver_cb @(posedge clk);
    output rst_n;
    output d;
    input q;
  endclocking
  // Monitor clocking block
  clocking monitor_cb @(posedge clk);
    input #0 d;
    input #0 q;
    input #0 rst_n;
    input #0 valid;
  endclocking
endinterface
