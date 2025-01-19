// VGA timing signal generator module
module vga
    (input  logic CLOCK_50, reset,
     output logic HS, VS, blank,
     output logic [8:0] row,
     output logic [9:0] col);

    // instantiate two counters, one for h_c and one for vert_c
    logic [10:0] hs_count, vs_count;
    logic clear_hs_count, clear_vs_count;
    logic inc_vs_count;
    Counter #(11) c0(
                     .en(1'b1),
                     .clear(clear_hs_count),
                     .load(1'b0),
                     .up(1'b1),
                     .clock(CLOCK_50),
                     .D('0),
                     .Q(hs_count)
                    );
    Counter #(11) c1(
                     .en(inc_vs_count),
                     .clear(clear_vs_count),
                     .load(1'b0),
                     .up(1'b1),
                     .clock(CLOCK_50),
                     .D('0),
                     .Q(vs_count)
                    );

    // instantiate checks for each possible horiz. and vert. region
    logic hs_pulse, hs_bp, hs_disp, hs_fp; 
    logic vs_pulse, vs_bp, vs_disp, vs_fp;

    RangeCheck #(11) r0(
                        .low(11'd0), 
                        .high(11'd191), 
                        .val(hs_count), 
                        .is_between(hs_pulse)
                       );
    RangeCheck #(11) r1(
                        .low(11'd192), 
                        .high(11'd287), 
                        .val(hs_count), 
                        .is_between(hs_bp)
                       );
    RangeCheck #(11) r2(
                        .low(11'd288), 
                        .high(11'd1567), 
                        .val(hs_count), 
                        .is_between(hs_disp)
                       );
    RangeCheck #(11) r3(
                        .low(11'd1568), 
                        .high(11'd1599), 
                        .val(hs_count), 
                        .is_between(hs_fp)
                       );

    RangeCheck #(11) r4(
                        .low(11'd0), 
                        .high(11'd1), 
                        .val(vs_count), 
                        .is_between(vs_pulse)
                       );
    RangeCheck #(11) r5(
                        .low(11'd2), 
                        .high(11'd30), 
                        .val(vs_count), 
                        .is_between(vs_bp)
                       );
    RangeCheck #(11) r6(
                        .low(11'd31), 
                        .high(11'd510), 
                        .val(vs_count), 
                        .is_between(vs_disp)
                       );
    RangeCheck #(11) r7(
                        .low(11'd511), 
                        .high(11'd520), 
                        .val(vs_count), 
                        .is_between(vs_fp)
                       );

    // logic for determining row, col from hs_count and vs_count
    assign row = (~blank) ? vs_count - 11'd31 : 9'bx;
    assign col = (~blank) ? (hs_count - 11'd288) >> 11'd1 : 10'bx;

    // logic for determining inc_vs
    assign inc_vs_count = (hs_count == 11'd1599);

    // logic for determining clear_hs_count, clear_vs_count
    assign clear_hs_count = (hs_count == 11'd1599) | reset;
    assign clear_vs_count = (vs_count == 11'd520) | reset;

    // logic for determining HS, VS, blank
    assign HS = hs_bp | hs_disp | hs_fp;
    assign VS = vs_bp | vs_disp | vs_fp;
    assign blank = ~(hs_disp & vs_disp);

endmodule: vga
