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