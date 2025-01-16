`default_nettype none

module tb ();

  logic clock;
  logic rst;

  uniprocessor DUT (.*);

  initial begin
    clock = 0;
    forever #1 clock <= ~clock;
  end

  initial begin
    $readmemh("memory.hex", DUT.u_memory.u_memory.mem);
    rst <= 1;
    @(posedge clock);
    rst <= 0;

    for (int i = 0; i < 1000; i++) begin
      @(posedge clock);
    end

    $finish;
  end

endmodule : tb
