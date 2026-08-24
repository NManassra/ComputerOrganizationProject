module cpu (
  input clk, // Clock
  input  [15:0] data_in,
  output reg [10:0] PC, // Memory address output
  output reg [10:0] MAR,
  output reg signed  [15:0] AC, // Memory data output
  output reg signed  [15:0] MBR,
  output reg   [15:0] IR, // Memory data output
  output reg read, // Read control signal
  output reg write // Write control signal
);
  parameter LOAD = 4'b0001, STORE = 4'b0010, ADD = 4'b0011, SUB = 4'b0100, MUL = 4'b0101, DIV = 4'b0110, Branch = 4'b0111, BRZ = 4'b1000;
  reg carr = 0;
  reg overflow = 0;
  reg zero = 0;
  reg negative = 0;
  reg [2:0] state = 0;
  reg signed [15:0] data = 16'b0000000000000000; 
  reg signed [15:0] memory [0:63];
  // output reg signed  [15:0] data; // Memory data output
  
  initial begin 
    PC = 11'b00000000000;
    state = 3'b000;
    MBR = 16'b0000000000000000;
    AC = MBR;
    IR = 16'b0000000000000000;
    MAR = 11'b00000000000;
    
    memory[0] = 16'b0001100000001010;
    memory[1] = 16'b0101100000001011;
    memory[2] = 16'b0011000000000101;
    memory[3] = 16'b0010100000001100;
    memory[10] = 16'b0000000000001001;
    memory[11] = 16'b1111111111111100;
    memory[12] = 16'b0000000000000000;
      //-----------> THE SECOND Q.
//    memory[0] = 16'b0001100000010111;
//    memory[1] = 16'b0011100000011000;
//    memory[2] = 16'b0011000000000001;
//    memory[3] = 16'b0010100000011001;
//    memory[4] = 16'b0001100000010101;
//    memory[5] = 16'b0101100000010110;
//    memory[6] = 16'b0100000000000101;
//    memory[7] = 16'b0011100000010100;
//    memory[8] = 16'b0110100000011001;
//    memory[9] = 16'b0010100000011001;
//    memory[20]= 16'b0000000000000010;
//    memory[21]= 16'b0000000000000011;
//    memory[22]= 16'b0000000000000101;
//    memory[23]= 16'b0000000000001000;
//    memory[24]= 16'b1111111111111011;
//    memory[25]= 16'b0000000000000000;
  end

  always @(posedge clk) begin
    case(state)
      3'b000: begin
        // Fetch instruction from memory
        MAR <= PC;
        state <= 3'b001;
      end
      
      3'b001: begin
        // Instruction fetch
        IR <= memory[MAR];
        PC <= PC + 1;
        state <= 3'b010;
      end
      
      3'b010: begin
        // Instruction decode
        state <= 3'b011;
        if (IR[11:11] == 1'b0) begin
          MAR <= IR[10:0];
        end
      end
      
      3'b011: begin
        // Operand fetch
        state <= 3'b100;
        case (IR[15:12])
          LOAD: begin                   
            if (IR[11] == 1'b1) begin    // M=1 => Memory address     M = 0 => constant
              read <= 1'b1; 
              write <= 1'b0;
              MBR <= memory[IR[10:0]];
            end
            if (IR[11] == 1'b0) begin
              read <= 1'b0;
              write <= 1'b0;
              MBR <= IR[10:0];
            end
          end
          
          STORE: begin
              write <= 1'b1;
              memory[MAR] = AC;
          end
          
          ADD: begin
            if (IR[11:11] == 1'b1) begin
              read <= 1'b1;
              write <= 1'b0;
              MBR <= memory[IR[10:0]];
            end
            else if (IR[11:11] == 1'b0) begin
              read <= 1'b0;
              write <= 1'b0;
              MBR <= IR[10:0];
            end
          end
          
          SUB: begin
            if (IR[11:11] == 1'b1) begin
              read <= 1'b1;
              write <= 1'b0;
              MBR <= memory[IR[10:0]];
            end
            else if (IR[11:11] == 1'b0) begin
              read <= 1'b0;
              write <= 1'b0;
              MBR <= IR[10:0];
            end
          end
          
          MUL: begin
            if (IR[11:11] == 1'b1) begin
              read <= 1'b1;
              write <= 1'b0;
              MBR <= memory[IR[10:0]];
            end
            else if (IR[11:11] == 1'b0) begin
              read <= 1'b0;
              write <= 1'b0;
              MBR <= IR[10:0]; 
            end
          end
          
          DIV: begin
            if (IR[11:11] == 1'b1) begin
              read <= 1'b1;
              write <= 1'b0;
              MBR <= memory[IR[10:0]];
            end
            else if (IR[11:11] == 1'b0) begin
              read <= 1'b0;
              write <= 1'b0;
              MBR <= IR[10:0];
            end
          end
          
          Branch: begin
            read <= 1'b0;
            write <= 1'b0;
            MBR <= IR[10:0];
          end
          
          BRZ: begin
            if (zero) begin
              read <= 1'b0;
              write <= 1'b0;
              PC <= IR[10:0];
              state <= 3'b000;
            end
          end
        endcase
      end
      
   3'b100: begin
        state <= 3'b101;
      end
       
  
     3'b101 : begin 
     state <= 3'b110;
             case (IR[15:12])
          LOAD: begin                   
             AC <= MBR;
          end
          ADD: begin
              AC <= AC + MBR;
          end
          
          SUB: begin
              AC <= AC - MBR;
            end
          
          MUL: begin
              AC <= AC * MBR;
          end
          
          DIV: begin
              AC <= AC / MBR;
          end
          
          Branch: begin
            PC <= MBR;
            state <= 3'b000;
          end
        endcase
     end
  
  
  
      
         3'b110: begin
        // Execute operations
        state <= 3'b000;
        case (IR[15:12])
          ADD: begin
            if (IR[11:11] == 1'b1) begin
              {carr, AC} <= AC + IR[10:0];
            end
            if (AC == 0)
              zero <= 1;
            else
              zero <= 0;
            if (carr != AC[15])
              overflow <= 1;
            else
              overflow <= 0;
            if (overflow != 1 && AC[15] == 1)
              negative <= 1;
            else
              negative <= 0;
          end
          
          SUB: begin
            if (IR[11:11] == 1'b1) begin
              {carr, AC} <= AC - IR[10:0];
            end
            if (AC == 0)
              zero <= 1;
            else
              zero <= 0;
            if (carr != AC[15])
              overflow <= 1;
            else
              overflow <= 0;
            if (overflow != 1 && AC[15] == 1)
              negative <= 1;
            else
              negative <= 0;
          end
          
          MUL: begin
            if (IR[11:11] == 1'b1) begin
              {carr, AC} <= AC * IR[10:0];
            end
            if (AC == 0)
              zero <= 1;
            else
              zero <= 0;
            if (carr != AC[15])
              overflow <= 1;
            else
              overflow <= 0;
            if (overflow != 1 && AC[15] == 1)
              negative <= 1;
            else
              negative <= 0;
          end
          
          DIV: begin
            if (IR[11:11] == 1'b1) begin
              {carr, AC} <= AC / IR[10:0];
            end
            if (AC == 0)
              zero <= 1;
            else
              zero <= 0;
            if (carr != AC[15])
              overflow <= 1;
            else
              overflow <= 0;
            if (overflow != 1 && AC[15] == 1)
              negative <= 1;
            else
              negative <= 0;
          end
        endcase
      end
    endcase
    
  end
endmodule