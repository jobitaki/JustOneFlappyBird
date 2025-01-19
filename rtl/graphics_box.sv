`default_nettype none

// module for checking if a value is in a range (given low --> low + offset)
module OffsetCheck
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] delta, low, val,
     output logic is_between);

    assign is_between = (val >= low && val <= (low + delta)) ? 1 : 0;

endmodule: OffsetCheck

// module for converting bird-Y positions to RGB colors to display via VGA
module positionToColor
    (input  logic [9:0] row,
     input  logic [9:0] col,
     input  logic [31:0] bird_y,
     output logic [7:0] red, green, blue);

    logic [9:0] bird_y_truncated;
    assign bird_y_truncated = bird_y[9:0];

    logic in_row;
    OffsetCheck #(10) oc0(.delta(10'd4),
                          .low(bird_y_truncated),
                          .val(row),
                          .is_between(in_row));

    logic in_col;
    OffsetCheck #(10) oc1(.delta(10'd4),
                          .low(10'317),
                          .val(col),
                          .is_between(in_col));


    assign red = (in_row && in_col) ? 8'hFF : 8'h000;
    assign green = (in_row && in_col) ? 8'hFF : 8'h00;
    assign blue = (in_row && in_col) ? 8'hFF : 8'h00;

endmodule: positionToColor
