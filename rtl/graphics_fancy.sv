`default_nettype wire

// module for converting bird-Y positions to RGB colors to display via VGA
module positionToColor
    (input  logic [9:0] row,
     input  logic [9:0] col,
     input logic inverted,
     input  logic [31:0] bird_y,
     output logic [7:0] red, green, blue);

    // create row checks
    logic is_r1, is_r2, is_r3, is_r4, is_r5, is_r6, is_r7, is_r8, is_r9, is_r10, 
          is_r11, is_r12;

    logic is_top_pipe, is_top_flange, is_bottom_flange, is_bottom_pipe;

    // create columnn group checks
    logic is_cg1, is_cg2, is_cg3, is_cg4, is_cg5, is_cg6, is_cg7, is_cg8, 
          is_cg9, is_cg10, is_cg11, is_cg12, is_cg13, is_cg14, is_cg15, is_cg16, 
          is_cg17, is_cg18, is_cg19;

    // init horiz. and vert. checks 
    assign is_top_pipe = (row <= 10'd120) && (10'd305 <= col && col <= 10'd335);
    assign is_top_flange = (10'd120 <= row && row <= 10'd150) && (10'd295 <= col && col <= 10'd345);

    assign is_bottom_flange = (10'd330 <= row && row <= 10'd360) && (10'd295 <= col && col <= 10'd345);
    assign is_bottom_pipe = (row >= 10'd360) && (10'd305 <= col && col <= 10'd335);

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


    assign is_cg1  = (10'd312 <= col && col <= 10'd312);
    assign is_cg2  = (10'd313 <= col && col <= 10'd313);
    assign is_cg3  = (10'd313 <= col && col <= 10'd317);
    assign is_cg4  = (10'd314 <= col && col <= 10'd314);
    assign is_cg5  = (10'd315 <= col && col <= 10'd319);
    assign is_cg6  = (10'd315 <= col && col <= 10'd315);
    assign is_cg7  = (10'd316 <= col && col <= 10'd316);
    assign is_cg8  = (10'd317 <= col && col <= 10'd317);
    assign is_cg9  = (10'd318 <= col && col <= 10'd319);
    assign is_cg10 = (10'd318 <= col && col <= 10'd318);
    assign is_cg11 = (10'd319 <= col && col <= 10'd319);

    assign is_cg12 = (10'd320 <= col && col <= 10'd320);

    assign is_cg13 = (10'd321 <= col && col <= 10'd321);
    assign is_cg14 = (10'd322 <= col && col <= 10'd323);
    assign is_cg15 = (10'd324 <= col && col <= 10'd324);
    assign is_cg16 = (10'd325 <= col && col <= 10'd325);
    assign is_cg17 = (10'd326 <= col && col <= 10'd326);
    assign is_cg18 = (10'd327 <= col && col <= 10'd327);
    assign is_cg19 = (10'd328 <= col && col <= 10'd328);

    // get colors:
    enum logic [2:0] {BLACK, RED, ORANGE, YELLOW, 
                      WHITE, BLUE, GREEN, DGREEN} curr_color;
    
    // start by casing on row
    always_comb begin

        if (is_top_flange || is_bottom_flange)  curr_color = DGREEN;
        else if (is_top_pipe || is_bottom_pipe) curr_color = GREEN;
        else if (is_r1) begin

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
      if (~inverted) begin
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

            GREEN: begin
                red = 8'h37;
                green = 8'hEC;
                blue = 8'h1E;
            end

            DGREEN: begin
                red = 8'h2C;
                green = 8'hB0;
                blue = 8'h1A;
            end
          endcase
        end else begin
          case(curr_color)
            BLACK: begin
                red = 8'hFF;
                green = 8'hFF;
                blue = 8'hFF;
            end

            RED: begin
                red = 8'h30;
                green = 8'hE8;
                blue = 8'hFF;
            end

            ORANGE: begin
                red = 8'h00;
                green = 8'h9F;
                blue = 8'hFF;
            end

            YELLOW: begin
                red = 8'h00;
                green = 8'h18;
                blue = 8'hFF;
            end

            WHITE: begin
                red = 8'h00;
                green = 8'h00;
                blue = 8'h00;
            end

            BLUE: begin
                red = 8'hFF;
                green = 8'h33;
                blue = 8'h00;
            end

            GREEN: begin
                red = 8'hC8;
                green = 8'h13;
                blue = 8'hE1;
            end

            DGREEN: begin
                red = 8'hD3;
                green = 8'h4F;
                blue = 8'hE5;
            end
        endcase
      end

    
  end


endmodule: positionToColor
