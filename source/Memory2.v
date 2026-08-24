module Memory2 (
  input [10:0] address, // Memory address input
  input [15:0] data_in, // Data input
  input rd, // Read control signal
  input wr, // Write control signal
  input clk, // Clock
  output reg [15:0] data_out); // Data output);
  reg [15:0] memory[0:63];
  initial begin
  //    memory[0] = 16'b0001100000001010;
   memory[0] = 16'b0001100000010111;
    memory[1] = 16'b0011100000011000;
    memory[2] = 16'b0011000000000001;
    memory[3] = 16'b0010100000011001;
    memory[4] = 16'b0001100000010101;
    memory[5] = 16'b0101100000010110;
    memory[6] = 16'b0100000000000101;
    memory[7] = 16'b0011100000010100;
    memory[8] = 16'b0110100000011001;
    memory[9] = 16'b0010100000011001;
    memory[20]= 16'b0000000000000010;
    memory[21]= 16'b0000000000000011;
    memory[22]= 16'b0000000000000101;
    memory[23]= 16'b0000000000001000;
    memory[24]= 16'b1111111111111011;
    memory[25]= 16'b0000000000000000;
    
  end
  always @(posedge clk) begin
    if (wr)
      memory[address] <= data_in;
    else if (rd)
      data_out <= memory[address];
  end
endmodule