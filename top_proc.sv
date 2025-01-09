`include "datapath.sv"

module top_proc
  #(parameter [31:0] INITIAL_PC = 32'h00400000
   )
  (
    output wire [31:0] PC,
    output wire [31:0] dAddress,
    output wire [31:0] dWriteData,
    output reg MemRead,
    output reg MemWrite,
    output wire [31:0] WriteBackData,
    input clk,
    input rst,
    input wire [31:0] instr,
    input wire [31:0] dReadData
  );
  
  wire Zero;
  reg PCSrc = 0;
  reg ALUSrc = 0;
  reg RegWrite = 0;
  reg MemToReg = 0;
  reg loadPC = 0;
  reg [3:0] ALUCtrl = 4'b0000;
  
  //Datapath
  
  datapath #(.INITIAL_PC(INITIAL_PC)) datapath_instance(
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl),
    .loadPC(loadPC),
    .PC(PC),
    .Zero(Zero),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .dReadData(dReadData),
    .WriteBackData(WriteBackData)
  );
    
  parameter [2:0] IF = 3'b000;
  parameter [2:0] ID = 3'b001;
  parameter [2:0] EX = 3'b010;
  parameter [2:0] MEM = 3'b011;
  parameter [2:0] WB = 3'b100;
  
  parameter [3:0] ALUOP_AND = 4'b0000;
  parameter [3:0] ALUOP_OR = 4'b0001;
  parameter [3:0] ALUOP_ADD = 4'b0010;
  parameter [3:0] ALUOP_SUB = 4'b0110;
  parameter [3:0] ALUOP_SLT = 4'b0100;
  parameter [3:0] ALUOP_SRL = 4'b1000;
  parameter [3:0] ALUOP_SLL = 4'b1001;
  parameter [3:0] ALUOP_SRA = 4'b1010;
  parameter [3:0] ALUOP_XOR = 4'b0101;
  
  parameter [6:0] BEQ = 7'b1100011;
  parameter [6:0] LW = 7'b0000011;
  parameter [6:0] SW = 7'b0100011;
  parameter [6:0] IMMEDIATE = 7'b0010011;
  parameter [6:0] R = 7'b0110011;
  
  parameter [2:0] ARITHMETIC = 3'b000;
  parameter [2:0] SLT = 3'b010;
  parameter [2:0] XOR = 3'b100;
  parameter [2:0] OR = 3'b110;
  parameter [2:0] AND = 3'b111;
  parameter [2:0] SLL = 3'b001;
  parameter [2:0] SRL = 3'b101;
  
  //FSM
  reg [2:0] current_state,next_state;
  
  always @(posedge clk or posedge clk) begin
    if (rst)
      current_state <= IF;
    else
      current_state <= next_state;
  end
  
  always @(*) begin
      MemRead = 0;
      MemWrite = 0;
      case(current_state)
        //Instruction fetch
        IF: begin
          loadPC = 1;
          next_state = ID;
        end
        //Instruction decode
        ID: begin
          next_state = EX;
        end
        //Execute
        EX: begin
          if(instr[6:0] == LW || instr[6:0] == SW)
            next_state = MEM;
          else
            next_state = WB;
        end
     
        //Memory access
        MEM: begin
          if(instr[6:0] == LW) begin //LW
            MemRead = 1;
          end
        
          else if (instr[6:0] == SW) begin //SW
            MemWrite = 1;
          end
          next_state = WB;
        end
        //Write Back
        WB: begin
          loadPC = 1;
          if(instr[6:0] != SW && instr[6:0] != BEQ) begin
            RegWrite =1;
          end
          if(instr[6:0] == LW) begin //LW
            MemToReg = 1;
          end
        
          if(instr[6:0] == BEQ && Zero == 1) begin
            PCSrc = 1;
          end
           next_state = IF;
        end
      endcase
    end
  
  //ALUSrc
  always @(*) begin
    if(instr[6:0] == LW || instr[6:0] == SW || instr[6:0] == IMMEDIATE)
      ALUSrc = 1;
    else
      ALUSrc = 0;
  end
  
  //ALUCtrl
  always @(*) begin
    if (instr[6:0] == R) begin
      case(instr[14:12]) //funct3
        ARITHMETIC : begin 
          if (instr[30] ==0 )
            ALUCtrl = ALUOP_ADD;
          else
            ALUCtrl = ALUOP_SUB;
        end
        SLT: ALUCtrl = ALUOP_SLT;
        XOR: ALUCtrl = ALUOP_XOR;
        OR: ALUCtrl = ALUOP_OR;
        AND: ALUCtrl = ALUOP_AND;
        SLL: ALUCtrl = ALUOP_SLL;
        SRL: begin
          if ( instr[30] == 0)
            ALUCtrl = ALUOP_SRL;
          else if (instr[30] == 1)
            ALUCtrl = ALUOP_SRA;
        end
      endcase
    end
    else if (instr[6:0] == IMMEDIATE) begin
      case(instr[14:12])
        ARITHMETIC : ALUCtrl = ALUOP_ADD;
        SLT: ALUCtrl = ALUOP_SLT;
        XOR: ALUCtrl = ALUOP_XOR;
        OR: ALUCtrl = ALUOP_OR;
        AND: ALUCtrl = ALUOP_AND;
        SLL: ALUCtrl = ALUOP_SLL;
        SRL: begin
          if ( instr[30] == 0)
            ALUCtrl = ALUOP_SRL;
          else if (instr[30] == 1)
            ALUCtrl = ALUOP_SRA;
        end
      endcase
    end
    else if (instr[6:0] == LW || instr[6:0] == SW) begin
      ALUCtrl = ALUOP_ADD;
    end
    else if (instr[6:0] == BEQ) begin
      ALUCtrl = ALUOP_SUB;
    end
    
  end
  
endmodule 