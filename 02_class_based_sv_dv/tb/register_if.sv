interface register_if(input logic clk);
  //Signals
  logic rst_n;
  logic [7:0] d;
  logic [7:0] q;
  //Driver CB (Drives DUT I/P)
  clocking driver_cb @(posedge clk);
    default input #1step output #1step;
    output rst_n;
    output d;
  endclocking
  //Monitor CB (Observes DUT signals)
  clocking monitor_cb @(posedge clk);
    default input #1step output #1step;
    input rst_n;
    input d;
    input q;
  endclocking
  //DUT Modport
  modport DUT(
    input clk,
    input rst_n,
    input d,
    output q
  );
  //Driver Modport
  modport DRIVER(
    clocking driver_cb
  );
  //Monitor Modport
  modport MONITOR(
    clocking monitor_cb
  );
endinterface
