`default_nettype none

module uniprocessor(
    input logic clock,
    input logic rst
);

    logic [31:0] addr_1, data_1_in, data_1_out;
    logic        we_1;

    logic [31:0] addr_2, data_2_out, data_2_in;
  
    logic lte_zero;

    logic       sel_addr_1;
    logic [1:0] sel_addr_2;

    logic sel_PC, en_PC;

    logic en_A, en_B, en_B_addr;

    procFSM fsm(.clock(clock),
                .rst(rst),
                .lte_zero(lte_zero),
                .we_1(we_1),
                .en_A(en_A),
                .en_B(en_B),
                .en_B_addr(en_B_addr),
                .sel_addr_1(sel_addr_1),
                .sel_addr_2(sel_addr_2),
                .sel_PC(sel_PC),
                .en_PC(en_PC)
    );

    memory u_memory (
        .clock(clock),
        .addr_1(addr_1),
        .din_1(data_1_in),
        .dout_1(data_1_out),
        .we_1(we_1),
        .addr_2(addr_2),
        .din_2(data_2_in),
        .dout_2(data_2_out),
        .en_1(1'b1),
        .en_2(1'b1),
        .we_2(1'b0)
    );
    
    logic [31:0] PC_in, PC_out;

    assign PC_in = (sel_PC) ? data_2_out : (PC_out + 3);
    
    always_ff @(posedge clock, posedge rst) begin
        if (rst)
            PC_out <= 32'b0;
        else if (en_PC)
            PC_out <= PC_in;
        else
            PC_out <= PC_out;
    end
    
    logic [31:0] reg_A_out, reg_B_out, reg_B_addr_out;

    always_comb begin
        if (!sel_addr_1) begin
            addr_1 = PC_out + 1;
        end else begin
            addr_1 = reg_B_addr_out;
        end

        case (sel_addr_2)
            2'b00: addr_2 = PC_out;
            2'b01: addr_2 = data_2_out;
            2'b10: addr_2 = PC_out + 2;
            default: addr_2 = PC_out;
        endcase
    end

    always_ff @(posedge clock, posedge rst) begin
        if (rst) begin
            reg_A_out      <= '0;
            reg_B_out      <= '0;
            reg_B_addr_out <= '0;
        end
        else begin
            if (en_A) begin
                reg_A_out <= data_2_out;
            end
            if (en_B) begin
                reg_B_out <= data_1_out;
            end
            if (en_B_addr) begin
                reg_B_addr_out <= data_1_out;
            end
        end
    end

    logic signed [31:0] B_minus_A;

    assign B_minus_A = reg_B_out - reg_A_out;
    assign lte_zero = B_minus_A <= 0;

    assign data_1_in = B_minus_A;
  
endmodule: uniprocessor

module procFSM(
    input logic  clock, rst,
    input logic  lte_zero,
    output logic we_1, 
    output logic en_A, en_B, en_B_addr,
    output logic sel_addr_1,
    output logic [1:0] sel_addr_2,
    output logic sel_PC, en_PC);

    enum logic [2:0] {ADDR_AB, WAIT_READ1, LATCH_B_ADDR, DATA_AB, WAIT_READ2, LATCH_DATA_AB, WAIT_READ3, WRITE_BACK} 
        curr_state, next_state;

    always_comb begin
        we_1 = 1'b0;
        en_A = 1'b0;
        en_B = 1'b0;
        en_B_addr  = 1'b0;
        sel_addr_1 = 2'd0;
        sel_addr_2 = 1'b0;
        sel_PC = 1'b0;
        en_PC = 1'b0;
        case(curr_state)
            ADDR_AB: begin
                sel_addr_2 = 2'd0;
                sel_addr_1 = 1'b0;
                next_state = WAIT_READ1;
            end
            WAIT_READ1: begin
                next_state = LATCH_B_ADDR;
            end
            LATCH_B_ADDR: begin
                en_B_addr = 1'b1;
                next_state = DATA_AB;
            end
            DATA_AB: begin
                sel_addr_2 = 2'd1;
                sel_addr_1 = 1'b1;
                next_state = WAIT_READ2;
            end
            WAIT_READ2: begin
                next_state = LATCH_DATA_AB;
            end
            LATCH_DATA_AB: begin
                en_A = 1'b1;
                en_B = 1'b1;
                sel_addr_2 = 2'd2;
                next_state = WAIT_READ3;
            end
            WAIT_READ3: begin
                next_state = WRITE_BACK;
            end
            WRITE_BACK: begin
                we_1 = 1'b1;
                sel_PC = lte_zero;
                en_PC = 1'b1;
                sel_addr_1 = 1'b1;
                next_state = ADDR_AB;
            end
        endcase
    end

    always_ff @(posedge clock, posedge rst) begin
        if (rst)
            curr_state <= ADDR_AB;
        else
            curr_state <= next_state;
    end

endmodule: procFSM
