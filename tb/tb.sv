`default_nettype wire

module tb ();

  logic clock;
  logic rst;
  logic [31:0] mmio_out;

  uniprocessor DUT (.*);

  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb);
  end

  initial begin
    clock = 0;
    forever #1 clock <= ~clock;
  end

  initial begin
    rst <= 1;
    @(posedge clock);
    rst <= 0;

    for (int i = 0; i < 1000000; i++) begin
      @(posedge clock);
    end

    $finish;
  end

endmodule : tb
