`default_nettype none

module chip_interface(
    input logic  clock,
    input logic  rst,
    output       hdmi_clk_n,
    output       hdmi_clk_p,
    output [2:0] hdmi_tx_n,
    output [2:0] hdmi_tx_p
);

  logic [31:0] mmio_out;

  uniprocessor u_uniprocessor(
      .clock   (clock),
      .rst     (rst),
      .mmio_out(mmio_out)
  );

  logic [9:0] row, col;
  logic [7:0] red, blue, green;

  vga_hdmi_wrapper u_vga(
    .clk(clock),
    .rst(rst),
    .red(red),
    .blue(blue),
    .green(green),
    .y_pix(row),
    .x_pix(col),
    .hdmi_clk_n(hdmi_clk_n),
    .hdmi_clk_p(hdmi_clk_p),
    .hdmi_tx_n(hdmi_tx_n),
    .hdmi_clk_p(hdmi_clk_p)
  );

  positionToColor u_positionToColor(
    .row(row),
    .col(col),
    .bird_y(mmio_out),
    .red(red),
    .green(green),
    .blue(blue)
  );

endmodule : chip_interface