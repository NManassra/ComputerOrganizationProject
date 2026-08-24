module Memory (
  input [10:0] address, // Memory address input
  input [15:0] data_in, // Data input
  input rd, // Read control signal
  input wr, // Write control signal
  input clk, // Clock
  output reg [15:0] data_out); // Data output);
  reg [15:0] memory[0:63];
  initial begin
  //    memory[0] = 16'b0001100000001010;
    memory[0] = 16'b0001100000001010;
    memory[1] = 16'b0101100000001011;
    memory[2] = 16'b0011000000000101;
    memory[3] = 16'b0010100000001100;
    memory[10] = 16'b0000000000001001;
    memory[11] = 16'b1111111111111100;
    memory[12] = 16'b0000000000000000;
  end
  always @(posedge clk) begin
    if (wr)
      memory[address] <= data_in;
    else if (rd)
      data_out <= memory[address];
  end
endmodule