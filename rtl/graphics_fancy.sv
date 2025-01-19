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

    // init horiz. and vert. checks 
    assign is_r1  = (row == bird_y - 6);
    assign is_r2  = (row == bird_y - 5);
    assign is_r3  = (row == bird_y - 4);
    assign is_r4  = (row == bird_y - 3);
    assign is_r5  = (row == bird_y - 2);
    assign is_r6  = (row == bird_y - 1);

    assign is_r7  = (row == bird_y);
    
    assign is_r8  = (row == bird_y + 1);
    assign is_r9  = (row == bird_y + 2);
    assign is_r10 = (row == bird_y + 3);
    assign is_r11 = (row == bird_y + 4);
    assign is_r12 = (row == bird_y + 5);


    assign is_cg1  = (10'd311 <= col && col >= 10'd311);
    assign is_cg2  = (10'd312 <= col && col >= 10'd312);
    assign is_cg3  = (10'd313 <= col && col >= 10'd317);
    assign is_cg4  = (10'd314 <= col && col >= 10'd314);
    assign is_cg5  = (10'd315 <= col && col >= 10'd319);
    assign is_cg6  = (10'd315 <= col && col >= 10'd315);
    assign is_cg7  = (10'd316 <= col && col >= 10'd316);
    assign is_cg8  = (10'd317 <= col && col >= 10'd317);
    assign is_cg9  = (10'd318 <= col && col >= 10'd319);
    assign is_cg10 = (10'd318 <= col && col >= 10'd318);
    assign is_cg11 = (10'd319 <= col && col >= 10'd319);

    assign is_cg12 = (10'd320 <= col && col >= 10'd320);

    assign is_cg13 = (10'd321 <= col && col >= 10'd321);
    assign is_cg14 = (10'd322 <= col && col >= 10'd323);
    assign is_cg15 = (10'd324 <= col && col >= 10'd324);
    assign is_cg16 = (10'd325 <= col && col >= 10'd325);
    assign is_cg17 = (10'd326 <= col && col >= 10'd326);
    assign is_cg18 = (10'd327 <= col && col >= 10'd327);
    assign is_cg19 = (10'd328 <= col && col >= 10'd328);
    
    // create row checks
    logic is_r1, is_r2, is_r3, is_r4, is_r5, is_r6, is_r7, is_r8, is_r9, is_r10, 
          is_r11, is_r12;

    // create columnn group checks
    logic is_cg1, is_cg2, is_cg3, is_cg4, is_cg5, is_cg6, is_cg7, is_cg8, 
          is_cg9, is_cg10, is_cg11, is_cg12, is_cg13, is_cg14, is_cg15, is_cg16, 
          is_cg17, is_cg18, is_cg19;

    // get colors:
    enum logic [2:0] {BLACK, RED, ORANGE, YELLOW, WHITE, BLUE} curr_color;
    
    // start by casing on row
    always_comb begin

        if (is_r1) begin

            if (is_cg9) curr_color = BLACK; 
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = BLACK;
            else if (is_cg14) curr_color = BLACK;
            else curr_color = BLUE;
        
        end else if (is_r2) begin

            if (is_cg7) curr_color = BLACK; 
            else if (is_cg8) curr_color = BLACK;
            else if (is_cg9) curr_color = YELLOW;
            else if (is_cg12) curr_color = YELLOW;
            else if (is_cg13) curr_color = BLACK;
            else if (is_cg14) curr_color = WHITE;
            else if (is_cg15) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r3) begin

            if (is_cg6) curr_color = BLACK; 
            else if (is_cg7) curr_color = YELLOW;
            else if (is_cg8) curr_color = YELLOW;
            else if (is_cg9) curr_color = YELLOW;
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = WHITE;
            else if (is_cg14) curr_color = WHITE;
            else if (is_cg15) curr_color = WHITE;
            else if (is_cg16) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r4) begin

            if (is_cg4) curr_color = BLACK; 
            else if (is_cg5) curr_color = YELLOW;
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = WHITE;
            else if (is_cg14) curr_color = WHITE;
            else if (is_cg15) curr_color = BLACK;
            else if (is_cg16) curr_color = WHITE;
            else if (is_cg17) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r5) begin

            if (is_cg2) curr_color = BLACK; 
            else if (is_cg4) curr_color = YELLOW;
            else if (is_cg5) curr_color = YELLOW;
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = WHITE;
            else if (is_cg14) curr_color = WHITE;
            else if (is_cg15) curr_color = BLACK;
            else if (is_cg16) curr_color = WHITE;
            else if (is_cg17) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r6) begin

            if (is_cg3) curr_color = BLACK; 
            else if (is_cg9) curr_color = YELLOW;
            else if (is_cg12) curr_color = YELLOW;
            else if (is_cg13) curr_color = BLACK;
            else if (is_cg14) curr_color = WHITE;
            else if (is_cg15) curr_color = WHITE;
            else if (is_cg16) curr_color = WHITE;
            else if (is_cg17) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r7) begin

            if (is_cg1) curr_color = BLACK; 
            else if (is_cg3) curr_color = WHITE;
            else if (is_cg10) curr_color = BLACK;
            else if (is_cg11) curr_color = YELLOW;
            else if (is_cg12) curr_color = YELLOW;
            else if (is_cg13) curr_color = YELLOW;
            else if (is_cg14) curr_color = BLACK;
            else if (is_cg15) curr_color = BLACK;
            else if (is_cg16) curr_color = BLACK;
            else if (is_cg17) curr_color = BLACK;
            else if (is_cg18) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r8) begin

            if (is_cg1) curr_color = BLACK; 
            else if (is_cg3) curr_color = WHITE;
            else if (is_cg10) curr_color = BLACK;
            else if (is_cg11) curr_color = YELLOW;
            else if (is_cg12) curr_color = YELLOW;
            else if (is_cg13) curr_color = BLACK;
            else if (is_cg14) curr_color = RED;
            else if (is_cg15) curr_color = RED;
            else if (is_cg16) curr_color = RED;
            else if (is_cg17) curr_color = RED;
            else if (is_cg18) curr_color = RED;
            else if (is_cg19) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r9) begin

            if (is_cg3) curr_color = BLACK; 
            else if (is_cg9) curr_color = ORANGE;
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = RED;
            else if (is_cg14) curr_color = BLACK;
            else if (is_cg15) curr_color = BLACK;
            else if (is_cg16) curr_color = BLACK;
            else if (is_cg17) curr_color = BLACK;
            else if (is_cg18) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r10) begin

            if (is_cg4) curr_color = BLACK; 
            else if (is_cg6) curr_color = ORANGE;
            else if (is_cg7) curr_color = ORANGE;
            else if (is_cg8) curr_color = ORANGE;
            else if (is_cg9) curr_color = ORANGE;
            else if (is_cg12) curr_color = ORANGE;
            else if (is_cg13) curr_color = BLACK;
            else if (is_cg14) curr_color = RED;
            else if (is_cg15) curr_color = RED;
            else if (is_cg16) curr_color = RED;
            else if (is_cg17) curr_color = RED;
            else if (is_cg18) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r11) begin

            if (is_cg6) curr_color = BLACK; 
            else if (is_cg7) curr_color = BLACK;
            else if (is_cg8) curr_color = ORANGE;
            else if (is_cg9) curr_color = ORANGE;
            else if (is_cg12) curr_color = ORANGE;
            else if (is_cg13) curr_color = ORANGE;
            else if (is_cg14) curr_color = BLACK;
            else if (is_cg15) curr_color = BLACK;
            else if (is_cg16) curr_color = BLACK;
            else if (is_cg17) curr_color = BLACK;
            else curr_color = BLUE;

        end else if (is_r12) begin

            if (is_cg8) curr_color = BLACK; 
            else if (is_cg9) curr_color = BLACK;
            else if (is_cg12) curr_color = BLACK;
            else if (is_cg13) curr_color = BLACK;
            else curr_color = BLUE;
        
        end else curr_color = BLUE;

    // set RGB based on color
    case (curr_color) 

        BLACK: begin
            red = 8'h00;
            green = 8'h00;
            blue = 8'h00;
        end


        RED: begin
            red = 8'hCF;
            green = 8'h17;
            blue = 8'h00;
        end

        ORANGE: begin
            red = 8'hFF;
            green = 8'h60;
            blue = 8'h00;
        end

        YELLOW: begin
            red = 8'hFF;
            green = 8'hE7;
            blue = 8'h00;
        end

        WHITE: begin
            red = 8'hFF;
            green = 8'hFF;
            blue = 8'hFF;
        end

        BLUE: begin
            red = 8'h00;
            green = 8'hCC;
            blue = 8'hFF;
        end

    endcase
  end


endmodule: positionToColor
