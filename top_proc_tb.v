`timescale 1ns / 1ps
`include "ram.v"
`include "rom.v"
`include "top_proc.sv"

module top_proc_tb;
  
  reg clk,rst;
  wire [31:0] instr;
  wire [31:0] PC;
  wire [31:0] dAddress;
  wire [31:0] dWriteData;
  wire MemRead,MemWrite;
  wire [31:0] WriteBackData;
  wire [31:0] dReadData;
  
  INSTRUCTION_MEMORY rom(
    .clk(clk),
    .addr(PC[8:0]),
    .dout(instr)
  );
  
  DATA_MEMORY ram(
    .clk(clk),
    .we(MemWrite),
    .addr(dAddress[8:0]),
    .din(dWriteData),
    .dout(dReadData)
  );
  
  top_proc uut (
    .clk(clk),
    .instr(instr),
    .rst(rst),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .WriteBackData(WriteBackData),
    .dReadData(dReadData)
  );
  //Clock generation
  initial clk = 0;
  always #5 clk = ~clk; //10ns period

initial begin 
    rst = 1;
    #10;
    rst = 0;
end
    
    initial begin
    $dumpfile("top_proc_tb.vcd");
    $dumpvars(0, top_proc_tb); 
    #12000;
    $finish;
    end

endmodule