`default_nettype wire

module vga (
    output logic [9:0] v_idx,
    output logic [9:0] h_idx,
    output logic valid,
    output logic vsync, hsync,

    input logic rst,
    input logic clk
);

assign valid = (v_idx < 480) && (h_idx < 640);

always @(posedge clk) begin
    if (rst) begin
        v_idx <= 0;
        h_idx <= 0;

        vsync <= 1;
        hsync <= 1;
    end
    else begin
        hsync <= 1;
        h_idx <= h_idx + 1;

        // Horizontal sync region
        if (h_idx >= 656 && h_idx < 752) begin
            hsync <= 1'b0;
        end

        // End of row
        if (h_idx >= 800) begin
            h_idx <= 0;
            v_idx <= v_idx + 1;

            // Vertical sync region
            if (v_idx >= 490 && v_idx < 492) begin
                vsync <= 0;
            end
            else begin
                vsync <= 1;
            end

            // End of frame
            if (v_idx >= 525) begin
                v_idx <= 0;
            end
        end
    end
end

endmodule

module vga_hdmi_wrapper(
	input clk,
	input rst,
  input logic [7:0] red, blue, green,
  output logic [9:0] y_pix, x_pix,
	output hdmi_clk_n,
	output hdmi_clk_p,
	output [2:0] hdmi_tx_n,
	output [2:0] hdmi_tx_p
);

	wire clk_25MHz, clk_125MHz;
	wire locked;
	wire hsync, vsync, vde;

	//clock wizard configured with a 1x and 5x clock
	clk_wiz_0 clk_wiz (
		.clk_out1(clk_25MHz),
		.clk_out2(clk_125MHz),
		.reset(rst),
		.locked(locked),
		.clk_in1(clk)
	);


	//VGA Sync signal generator
  vga vga_module(
    .v_idx(y_pix),
    .h_idx(x_pix),
    .valid(vde),
    .vsync(vsync), .hsync(hsync),
    .rst(rst),.clk(clk_25MHz)
);


	//Real Digital VGA to HDMI converter
	hdmi_tx_0 vga_to_hdmi (
		//Clocking and Reset
		.pix_clk(clk_25MHz),
		.pix_clkx5(clk_125MHz),
		.pix_clk_locked(locked),
		//Reset is active HIGH
		.rst(rst),

		//Color and Sync Signals
		.red(red),
		.green(green),
		.blue(blue),
		.hsync(hsync),
		.vsync(vsync),
		.vde(vde),

		//aux Data (unused)
		.aux0_din(4'b0),
		.aux1_din(4'b0),
		.aux2_din(4'b0),
		.ade(1'b0),

		//Differential outputs
		.TMDS_CLK_P(hdmi_clk_p),          
		.TMDS_CLK_N(hdmi_clk_n),          
		.TMDS_DATA_P(hdmi_tx_p),         
		.TMDS_DATA_N(hdmi_tx_n)          
	);

endmodule