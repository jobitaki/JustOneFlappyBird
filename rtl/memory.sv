`default_nettype wire

module memory (
    input  logic        clock,
    input  logic        rst,
    input  logic [31:0] addr_1,
    input  logic [31:0] din_1,
    output logic [31:0] dout_1,
    input  logic        en_1,
    input  logic        we_1,
    input  logic [31:0] addr_2,
    input  logic [31:0] din_2,
    output logic [31:0] dout_2,
    input  logic        en_2,
    input  logic        we_2,
    output logic [31:0] mmio_out
);

  parameter bit [31:0] MMIO_ADDR_1 = 32'h1000;
  parameter bit [31:0] MMIO_ADDR_2 = 32'h0fff;

  logic [31:0] mem_dout_1, mem_dout_2;
  logic [31:0] mmio_1_out;

  assign mmio_out = mmio_1_out;
  
  blk_mem_gen_0 blk_memory (
    .clka(clock),    // input wire clka
    .ena(en_1),      // input wire ena
    .wea(we_1),      // input wire [0 : 0] wea
    .addra(addr_1),  // input wire [13 : 0] addra
    .dina(din_1),    // input wire [31 : 0] dina
    .douta(mem_dout_1),  // output wire [31 : 0] douta
    .clkb(clock),    // input wire clkb
    .enb(en_2),      // input wire enb
    .web(we_2),      // input wire [0 : 0] web
    .addrb(addr_2),  // input wire [13 : 0] addrb
    .dinb(din_2),    // input wire [31 : 0] dinb
    .doutb(mem_dout_2)  // output wire [31 : 0] doutb
  );
  
  /*
  memory_simulation u_memory (
      .clock (clock),
      .addr_1(addr_1),
      .din_1 (din_1),
      .dout_1(mem_dout_1),
      .en_1  (en_1),
      .we_1  (we_1),
      .addr_2(addr_2),
      .din_2 (din_2),
      .dout_2(mem_dout_2),
      .en_2  (en_2),
      .we_2  (we_2)
  );
  */

  always_ff @(posedge clock) begin
    if (rst) begin
      mmio_1_out <= '0;
      // mmio_2_out <= '0;
    end else begin
      // Port 1
      if (we_1 && (addr_1 == MMIO_ADDR_1)) mmio_1_out <= din_1;
      // else if (we_1 && (addr_1 == MMIO_ADDR_2)) mmio_2_out <= din_1;
      // Port 2
      if (we_2 && (addr_2 == MMIO_ADDR_1)) mmio_1_out <= din_2;
      // else if (we_2 && (addr_2 == MMIO_ADDR_2)) mmio_2_out <= din_2;
    end
  end

  always_comb begin
    if (!we_1 && (addr_1 == MMIO_ADDR_1)) dout_1 = mmio_1_out;
    // else if (!we_1 && (addr_1 == MMIO_ADDR_2)) dout_1 = mmio_2_out;
    else dout_1 = mem_dout_1;
    
    //if (!we_2 && (addr_2 == MMIO_ADDR_1)) dout_2 = mmio_1_out;
    // else if (!we_2 && (addr_2 == MMIO_ADDR_2)) dout_2 = mmio_2_out;
    //else dout_2 = mem_dout_2;
    dout_2 = mem_dout_2;
  end

endmodule : memory

module memory_simulation (
    input  logic        clock,
    input  logic [31:0] addr_1,
    input  logic [31:0] din_1,
    output logic [31:0] dout_1,
    input  logic        en_1,
    input  logic        we_1,
    input  logic [31:0] addr_2,
    input  logic [31:0] din_2,
    output logic [31:0] dout_2,
    input  logic        en_2,
    input  logic        we_2
);

  parameter int SIM_MEM_SIZE = 65536;

  logic [31:0] mem[SIM_MEM_SIZE];

  logic [31:0] dout_temp_1, dout_temp_2;

  logic [31:0] probe;
  assign probe = mem[4096];

  always_ff @(posedge clock) begin
    if (en_1 && !we_1) dout_temp_1 <= mem[addr_1];
    if (en_2 && !we_2) dout_temp_2 <= mem[addr_2];

    dout_1 <= dout_temp_1;
    dout_2 <= dout_temp_2;
  end

  always_ff @(posedge clock) begin
    if (en_1 && we_1) mem[addr_1] <= din_1;
    if (en_2 && we_2) mem[addr_2] <= din_2;
  end

  initial begin
    $readmemh("even_simpler.hex", mem);
  end

endmodule : memory_simulation