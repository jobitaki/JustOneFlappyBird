`default_nettype none

module memory (
    input  logic        clock,
    input  logic [31:0] addr_1,
    input  logic [31:0] din_1,
    output logic [31:0] dout_1,
    input  logic        re_1,
    input  logic        we_1,
    input  logic [31:0] addr_2,
    input  logic [31:0] din_2,
    output logic [31:0] dout_2,
    input  logic        re_2,
    input  logic        we_2
);

  memory_simulation u_memory (.*);

endmodule : memory

module memory_simulation (
  input  logic        clock,
  input  logic [31:0] addr_1,
  input  logic [31:0] din_1,
  output logic [31:0] dout_1,
  input  logic        re_1,
  input  logic        we_1,
  input  logic [31:0] addr_2,
  input  logic [31:0] din_2,
  output logic [31:0] dout_2,
  input  logic        re_2,
  input  logic        we_2
);

  logic [31:0] mem[SIM_MEM_SIZE];
  
  always_ff @(posedge clock) begin
      dout_1 <= mem[addr_1];
      dout_2 <= mem[addr_2];
  end

  always_ff @(posedge clock) begin
    if (we_1) mem[addr_1] <= din_1;
    if (we_2) mem[addr_2] <= din_2;
  end

  initial begin
    int fd = $fopen("memory.hex", "r");
    int status;
    logic [$clog2(SIM_MEM_SIZE+1):0] addr;
    logic [31:0] mem_line;
    if (fd) begin
      addr = '0;
      while (!$feof(
          fd
      )) begin
        status = $fscanf(fd, "%h", mem_line);
        if (status == 1) begin
          mem[{addr, 2'b00}] = mem_line;
          addr += 1;
        end
      end
    end else begin
      $display("File not found");
      $fflush();
      $finish(2);
    end

    $fclose(fd);
  end

endmodule : memory_simulation
