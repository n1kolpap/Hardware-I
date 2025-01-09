module alu
  
  #(parameter[3:0] ALUOP_AND = 4'b0000,
  ALUOP_OR = 4'b0001,
  ALUOP_ADD = 4'b0010,
  ALUOP_SUB = 4'b0110,
  ALUOP_SLT = 4'b0100,
  ALUOP_SRL = 4'b1000,
  ALUOP_SLL = 4'b1001,
  ALUOP_SRA = 4'b1010,
  ALUOP_XOR = 4'b0101)
  
  (output reg zero, 
   output reg signed [31:0] result,
   input signed [31:0] op1, 
   input signed [31:0] op2, 
   input wire [3:0] alu_op);
  
  always @(*) 
    begin
            case (alu_op)
             ALUOP_AND: result = op1 & op2;  //Logical AND
             ALUOP_OR: result = op1 | op2;   //Logical OR
             ALUOP_ADD: result = op1 + op2;
             ALUOP_SUB: result = op1 - op2;
             ALUOP_SLT: result = (op1 < op2) ? 1 : 0;
             ALUOP_SRL: result = op1 >> op2[4:0];
             ALUOP_SLL: result = op1 << op2[4:0];
             ALUOP_SRA: result = op1 >>> op2[4:0];
             ALUOP_XOR: result= op1 ^ op2;
             default: result = 32'b0;
            endcase
      zero = (result == 32'b0) ? 1'b1 : 1'b0;
    end
  
endmodule