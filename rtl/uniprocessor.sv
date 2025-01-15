`default_nettype none

module uniprocessor(
    input logic clock,
    input logic rst
);

    logic [31:0] addr_1, data_1;
    logic re_1, we_1;

    logic [31:0] addr_2, data_2;
    logic re_2, we_2;
  
    logic lte_zero;

    logic sel_addr_2;

    logic sel_PC, en_PC;
    
    logic wr_diff;

    procFSM fsm(.clock(clock),
                .rst(rst),
                .lte_zero(lte_zero),
                .re_1(re_1),
                .re_2(re_2),
                .en_A(en_A),
                .en_B(en_B),
                .sel_addr_2(sel_addr_2),
                .sel_PC(sel_PC),
                .en_PC(en_PC),
                .wr_diff(wr_diff)
    );

    memory u_memory (
        .clock(clock),
        .addr_1(addr_1),
        .data_1(data_1),
        .re_1(re_1),
        .we_1(we_1),
        .addr_2(addr_2),
        .data_2(data_2),
        .re_2(re_2),
        .we_2(we_2)
    );
    
    logic [31:0] PC_in, PC_out;

    assign PC_in = (sel_PC) ? C : (PC + 3);
    
    always_ff @(posedge clock, posedge rst) begin
        if (rst)
            PC_out <= 32'b0;
        else if (en_PC)
            PC_out <= PC_in;
        else
            PC_out <= PC_out;
    end
    
    assign addr_1 = PC_out + 1;
    assign addr_2 = (sel_addr_2) ? (PC_out + 2) : PC_out;

    logic [31:0] reg_A_out, reg_B_out;
    logic [31:0] B_minus_A;

    always_ff @(posedge clock, posedge rst) begin
        if (rst) begin
            reg_A_out <= '0;
            reg_B_out <= '0;
        end
        else begin
            if (en_A) begin
                reg_A_out <= data_2;
            end
            if (en_B) begin
                reg_B_out <= data_1;
            end
        end
    end

    assign B_minus_A = reg_B_out - reg_A_out;
    assign lte_zero = B_minus_A <= 32'b0;

    assign data_1 = (wr_diff) ? B_minus_A : 'z;
  
endmodule: uniprocessor

module procFSM(
    input logic  clock, rst,
    input logic  lte_zero,
    output logic re_1, re_2, 
    output logic en_A, en_B,
    output logic sel_addr_2,
    output logic sel_PC, en_PC
    output logic wr_diff);

    enum logic [1:0] {PHASE_1A, WAIT_READ1, PHASE_1B, WAIT_READ2, PHASE_2} 
        curr_state, next_state;

    always_comb begin
        re_1 = 1'b0;
        re_2 = 1'b0;
        en_A= 1'b0;
        en_B = 1'b0;
        sel_addr_2 = 1'b0;
        sel_PC = 1'b0;
        en_PC = 1'b0;
        wr_diff = 1'b0;
        case(curr_state)
            PHASE_1A: begin
                re_1 = 1'b1;
                re_2 = 1'b1;
                sel_addr_2 = 1'b0;
                next_state = WAIT_READ1;
            end
            WAIT_READ1: begin
                next_state = PHASE_1B;
            end
            PHASE_1B: begin
                en_A = 1'b1;
                en_B = 1'b1;
                sel_addr_2 = 1'b1;
                re_2 = 1'b1;
                next_state = WAIT_READ2;
            end
            WAIT_READ2: begin
                next_state = PHASE_2;
            end
            PHASE_2: begin
                wr_diff = 1'b1;
                we_1 = 1'b1;
                sel_PC = lte_zero;
                en_PC = 1'b1;
                next_state = PHASE_1A;
            end
        endcase
    end

    always_ff @(posedge clock, posedge rst) begin
        if (rst)
            curr_state <= PHASE_1A;
        else
            curr_state <= next_state;
    end

endmodule: procFSM
