`include "alu.sv"
`include "regfile.sv"

module datapath 
  #(parameter [31:0] INITIAL_PC = 32'h00400000,
    parameter [6:0] BEQ = 7'b1100011,
    parameter [6:0] LW = 7'b0000011,
    parameter [6:0] SW = 7'b0100011,
    parameter [6:0] IMMEDIATE = 7'b0010011
   )
  
  (output wire Zero,
   output wire [31:0] PC,
   output reg [31:0] dAddress,
   output reg [31:0] dWriteData,
   output reg  [31:0] WriteBackData,
   input clk,
   input rst,
   input wire [31:0] instr,
   input PCSrc,
   input ALUSrc,
   input RegWrite,
   input MemToReg,
   input wire [3:0] ALUCtrl,
   input loadPC,
   input wire [31:0] dReadData);
  
  reg [31:0] PC_reg = INITIAL_PC;
  wire [31:0] readData1,readData2;
  reg [31:0] op2;
  wire [31:0] ALUResult;
  reg [31:0] immediate;
  
  
wire [31:0] immediate_I = {{20{instr[31]}},instr[31:20]};
wire [31:0] immediate_S = {{20{instr[31]}},instr[31:25],instr[11:7]};
wire [31:0] immediate_B = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0}; //13bits 
  
  assign PC = PC_reg;
  
  regfile registers(
    .clk(clk),
    .write(RegWrite),
    .readReg1(instr[19:15]),
    .readReg2(instr[24:20]),
    .writeReg(instr[11:7]),
    .writeData(WriteBackData),
    .readData1(readData1),
    .readData2(readData2)
  );
  
  alu alu_instance(
    .op1(readData1),
    .op2(op2),
    .alu_op(ALUCtrl),
    .zero(Zero),
    .result(ALUResult)
  );
  
  
  //IMMEDIATE GENERATION
  
  always @(*) begin
    if(instr[6:0] == SW )
      immediate = immediate_S;
    else if(instr[6:0] == BEQ)
      immediate = immediate_B << 1;
    else if (instr[6:0] == IMMEDIATE || instr[6:0] == LW )
      immediate = immediate_I;
  end
  
  //PROGRAM COUNTER
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      PC_reg <= INITIAL_PC;
    end
    else if (loadPC) begin
      if (PCSrc)
        PC_reg <= PC_reg + immediate;
      else
        PC_reg <= PC_reg + 4;
    end
  end
  
  
  //ALU
  
  always @(*) begin
    if(ALUSrc == 1) begin
      op2 = immediate;
    end
    else if (ALUSrc == 0) begin
      op2 = readData2;
    end
  end
  
  //MEMORY ACCESS & WRITE BACK
  
  always @(*) begin
    dAddress = ALUResult;
    dWriteData = readData2;
    
    if(MemToReg == 1) begin
      WriteBackData = dReadData;
    end
    else if (MemToReg == 0) begin
      WriteBackData = ALUResult;
    end
  end
  
endmodule