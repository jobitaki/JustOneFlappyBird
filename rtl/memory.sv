`default_nettype none

module memory (
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

  memory_simulation u_memory (.*);

endmodule : memory


/*
  Clka and Clkb should both be the same shared clock
  ena and enb enable any memory accesses
  wea and web are read when 0 and write when 1
 */
// module blk_memory (
//   input  logic         clka,
//   input  logic         ena,
//   input  logic         wea,            // 1-bit write enable for port A
//   input  logic [13:0]  addra,          // 14-bit address for port A
//   input  logic [31:0]  dina,           // 32-bit data input for port A
//   output logic [31:0]  douta,          // 32-bit data output for port A
//   input  logic         clkb,
//   input  logic         enb,
//   input  logic         web,            // 1-bit write enable for port B
//   input  logic [13:0]  addrb,          // 14-bit address for port B
//   input  logic [31:0]  dinb,           // 32-bit data input for port B
//   output logic [31:0]  doutb           // 32-bit data output for port B
// );
// 
//   blk_mem_wrapper block_memory_wrapper(.*);
// 
// endmodule: blk_memory

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
