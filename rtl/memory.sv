`default_nettype none

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
    input  logic        we_2
);

  parameter bit [31:0] MMIO_ADDR_1 = 32'h0FFF;
  parameter bit [31:0] MMIO_ADDR_2 = 32'h1000;

  logic [31:0] mem_dout_1, mem_dout_2;
  logic        mem_we_1, mem_we_2;

  /*
  blk_mem_gen_0 blk_memory (
    .clka(clka),    // input wire clka
    .ena(ena),      // input wire ena
    .wea(wea),      // input wire [0 : 0] wea
    .addra(addra),  // input wire [13 : 0] addra
    .dina(dina),    // input wire [31 : 0] dina
    .douta(douta),  // output wire [31 : 0] douta
    .clkb(clkb),    // input wire clkb
    .enb(enb),      // input wire enb
    .web(web),      // input wire [0 : 0] web
    .addrb(addrb),  // input wire [13 : 0] addrb
    .dinb(dinb),    // input wire [31 : 0] dinb
    .doutb(doutb)  // output wire [31 : 0] doutb
  );
  */

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

  // MMIO
  logic [31:0] mmio_1_out, mmio_2_out;

  always_comb begin
    if (!we_1 && (addr_1 == MMIO_ADDR_1)) begin
      dout_1 = mmio_1_out;
    end else if (!we_1 && (addr_1 == MMIO_ADDR_2)) begin
      dout_1 = mmio_2_out;
    end else begin
      dout_1 = mem_dout_1;
    end
  end 

  always_comb begin
    if (!we_2 && (addr_2 == MMIO_ADDR_1)) begin
      dout_2 = mmio_1_out;
    end else if (!we_2 && (addr_2 == MMIO_ADDR_2)) begin
      dout_2 = mmio_2_out;
    end else begin
      dout_2 = mem_dout_2;
    end
  end

  always_ff @(posedge clock) begin
    if (rst) begin
      mmio_1_out <= '0;
      mmio_2_out <= '0;
    end else begin
      if (we_1 && (addr_1 == MMIO_ADDR_1 || addr_1 == MMIO_ADDR_2)) begin
        mmio_1_out <= din_1;
      end
      if (we_2 && (addr_2 == MMIO_ADDR_1 || addr_2 == MMIO_ADDR_2)) begin
        mmio_2_out <= din_2;
      end
    end
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
