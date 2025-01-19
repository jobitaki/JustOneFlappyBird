`default_nettype none

// ---------- previously, from HW 2 ----------

// [B]: 16-bit combinational barrel shifter (leftwards)
module BarrelShifter
    (input  logic [15:0] V,
     input  logic [3:0]  by,
     output logic [15:0] S);

    assign S = V << by;

endmodule: BarrelShifter

// [E] 8-bit magnitude comparator
module MagComparator
    (input  logic [7:0] A,
     input  logic [7:0] B,
     output logic AltB, AeqB, AgtB);

    // assign AltB depending on A < B
    assign AltB = (A < B);

    // assign AeqB depending on A == B
    assign AeqB = (A == B);

    // assign AgtB depending A > B
    assign AgtB = (A > B);

endmodule: MagComparator


// [F] 4-bit comparator (non-magnitude variety)
module Comparator
    (input  logic [3:0] A,
     input  logic [3:0] B,
     output logic       AeqB);

    // assign AeqB depending on A == B
    assign AeqB = (A == B);

endmodule: Comparator

// ---------- modified for HW 5 (from HW 2) ----------

// X-->1 multiplexer
module Multiplexer
    #(parameter WIDTH = 16, 
                SW = $clog2(WIDTH))
    (input  logic [WIDTH - 1:0] I,
     input  logic [SW - 1:0] S,
     output logic Y);

    assign Y = I[S];

endmodule: Multiplexer


// 2-->1 X-bit multiplexer
module Mux2to1
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] I0, I1,
     input  logic S,
     output logic [WIDTH - 1:0] Y);

    always_comb begin
        case (S)
            1'b0: Y = I0;
            1'b1: Y = I1;
        endcase
    end

endmodule: Mux2to1


// decoder (1-hot if en)
module Decoder
    #(parameter WIDTH = 16,
                IW = $clog2(WIDTH))
    (input  logic [IW - 1:0] I,
     input  logic en,
     output logic [WIDTH - 1:0] D);
    
    always_comb begin
        D = '0;
        if (en) D[I] = 1'b1;
    end

endmodule: Decoder

// ---------- new for HW 5 ----------

// X-bit magnitude comparator
module MagComp
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] A, B,
     output logic AltB, AeqB, AgtB);
    
    always_comb begin
        
        // if A < B
        if (A < B) begin

            AltB = 1'b1;
            AeqB = 1'b0;
            AgtB = 1'b0;

        // if A = B
        end else if (A == B) begin
        
            AltB = 1'b0;
            AeqB = 1'b1;
            AgtB = 1'b0;

        // A not < or = B, so A > B
        end else begin

            AltB = 1'b0;
            AeqB = 1'b0;
            AgtB = 1'b1;

        end

    end

endmodule: MagComp


// X-bit adder
module Adder
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] A, B,
     input  logic cin,
     output logic [WIDTH - 1:0] S,
     output logic cout);

    // create internal WIDTH-bit sum
    // WIDTH-1 bits for the sum, plus a carry
    logic [WIDTH:0] temp_sum;
    assign temp_sum = A + B + cin;

    // use temp_sum to get the final sum and cout
    always_comb begin

        // carry, S = A + B + 1
        if (temp_sum >= 2 ** WIDTH-1) begin
        
            S = temp_sum - (2 ** WIDTH-1);
            cout = 1'b1;

        // no carry, S = A + B 
        end else begin
        
            S = temp_sum;
            cout = 1'b0;

        end

    end

endmodule: Adder


// D flip-flop w/ asynchronous reset, preset
module DFlipFlop
    (input  logic D, clock, preset_L, reset_L,
    // (input  logic D, clock, reset_L,
     output logic Q);

    always_ff @(posedge clock, negedge reset_L, negedge preset_L) begin
       
        if (reset_L == 1'b0) Q <= 1'b0;
        else if (preset_L == 1'b0) Q <= 1'b1;
        else Q <= D;

    end

endmodule: DFlipFlop


// register
module Register
    #(parameter WIDTH = 16)
    (input  logic en, clear, clock,
     input  logic [WIDTH - 1:0] D,
     output logic [WIDTH - 1:0] Q);

    always_ff @(posedge clock) begin

        // if enabled, Q <= D    
        if (en) begin

            Q <= D;

        // if clearing, Q <= WIDTH'b0
        end else if (clear) begin
        
            Q <= '0;

        end

    end

endmodule: Register


// counter
module Counter
    #(parameter WIDTH = 16)
    (input  logic en, clear, load, up, clock,
     input  logic [WIDTH - 1:0] D,
     output logic [WIDTH - 1:0] Q);

    always_ff @(posedge clock) begin
    
        // if clearing, Q <= WIDTH'b0
        if (clear) begin

            Q <= '0;

        // if loading, Q <= D
        end else if (load) begin

            Q <= D;

        // if enabled, update Q
        end else if (en) begin

            // if up, increment Q
            if (up) begin
                Q <= Q + 1'd1;
            // otherwise, decrement Q
            end else begin
                Q <= Q - 1'd1;
            end

        end

    end

endmodule: Counter


// synchronizer
module Synchronizer
    (input  async, clock,
     output sync);

    // create internal signals for linking D flip-flops
    logic A;

    // instantiate 2 D flip-flops to synchronise a signal
    DFlipFlop d0(
                 .Q(A), 
                 .D(async), 
                 .clock(clock), 
                 .reset_L(1'b1), 
                 .preset_L(1'b1)
                ),
              d1(
                 .Q(sync), 
                 .D(A), 
                 .clock(clock), 
                 .reset_L(1'b1), 
                 .preset_L(1'b1)
                );

endmodule: Synchronizer


// shift register (serial in parallel out)
module ShiftRegister_SIPO
    #(parameter WIDTH = 16)
    (input  logic serial, en, left, clock,
     output logic [WIDTH - 1:0] Q);

    // calculate serial + shift
    logic [WIDTH - 1:0] D;
    
    always_comb begin

        if (left) begin
            D = {Q[WIDTH - 2:0], serial};
        end else begin
            D = {serial, Q[WIDTH - 1:1]};
        end

    end

    // determine necessary I/O
    always_ff @(posedge clock) begin

        // if enabled, Q <= D
        if (en) begin
            Q <= D;
        end

    end

endmodule: ShiftRegister_SIPO


// shift register (parallel in parallel out)
module ShiftRegister_PIPO
    #(parameter WIDTH = 16)
    (input  logic en, left, load, clock,
     input  logic [WIDTH - 1:0] D,
     output logic [WIDTH - 1:0] Q);
    
    // calculate shift
    logic [WIDTH - 1:0] shifted;

    always_comb begin
        
        if (left) begin
            shifted = Q << 1;
        end else begin
            shifted = Q >> 1;
        end

    end

    // determine necessary I/O
    always_ff @(posedge clock) begin
    
        if (load) begin
            Q <= D;
        end else if (en) begin
            Q <= shifted;
        end 

    end

endmodule: ShiftRegister_PIPO


// 0-4 X-bit barrel-shift register
module BarrelShiftRegister
    #(parameter WIDTH = 16)
    (input  logic en, load, clock,
     input  logic [1:0] by,
     input  logic [WIDTH - 1:0] D,
     output logic [WIDTH - 1:0] Q);

    // calculate shift
    logic [WIDTH - 1:0] shifted;

    always_comb begin

        // shifting required
        if (by != 0) begin
        
            shifted = Q << by;
        
        // shifting not required
        end else begin

            shifted = Q;

        end
    
    end

    // determine I/O
    always_ff @(posedge clock) begin

        if (load) begin

            Q <= D;

        end else if (en) begin

            Q <= shifted;

        end

    end

endmodule: BarrelShiftRegister


// X-bit bus driver
module BusDriver
    #(parameter WIDTH = 16)
    (input  logic en,
     input  logic [WIDTH - 1:0] data,
     output logic [WIDTH - 1:0] buff, bus);

    // set buff to the bus value
    assign buff = bus;

    // if enabled, drive data onto the bus
    always_comb begin

        if (en) begin
            bus <= data;
        end

    end

endmodule: BusDriver


// // memory
// module Memory
//     #(parameter AW = 1,
//                 W  = 2**AW,
//                 DW = 4)
//     (input logic re, we, clock,
//      input logic [AW - 1: 0] addr,
//      inout tri [DW - 1: 0] data);

//     // create internal variables for the memory array, read data
//     logic [DW - 1:0] M[W];
//     logic [DW - 1:0] rData;

//     assign rData = M[addr];

//     // if writing, write to memory location
//     always_ff @(posedge clock) begin

//         if (we) begin
//             M[addr] <= data;
//         end

//     end

//     // assign I/O data
//     assign data = (re) ? rData : 'z;

// endmodule: Memory

// ----- from lab 4 -----

// module for checking if a value is in a range (given low --> high)
module RangeCheck
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] high, low, val,
     output logic is_between);

    assign is_between = (val >= low && val <= high) ? 1 : 0;

endmodule: RangeCheck


// module for checking if a value is in a range (given low --> low + offset)
module OffsetCheck
    #(parameter WIDTH = 16)
    (input  logic [WIDTH - 1:0] delta, low, val,
     output logic is_between);

    assign is_between = (val >= low && val <= (low + delta)) ? 1 : 0;

endmodule: OffsetCheck
