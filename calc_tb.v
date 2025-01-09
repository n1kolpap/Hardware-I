`timescale 1ns / 1ps
`include "calc.v"


module calc_tb;
  
  reg clk,btnc,btnl,btnu,btnr,btnd;
  reg [15:0] sw;
  wire [15:0] led;
  
  calc uut (
    .clk(clk),
    .btnc(btnc),
    .btnl(btnl),
    .btnu(btnu),
    .btnr(btnr),
    .btnd(btnd),
    .sw(sw),
    .led(led)
  );
  
  
  //Clock generation
  initial clk = 0;
  always #5 clk = ~clk; //10ns period

  
  //Stimulus generation
  initial begin      
      $dumpfile("calc_tb.vcd");
      $dumpvars(0,calc_tb);
      
      //Reset the calculator
      btnu = 1;
      #10;
      btnu = 0;
      
      //ADD
      {btnl,btnc,btnr} = 3'b010;
      sw=16'h354a;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x354a, Got: 0x%h", led);
      
      //SUB
      {btnl,btnc,btnr} = 3'b011;
      sw=16'h1234;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x2316, Got: 0x%h", led);
      
      //OR
      {btnl,btnc,btnr} = 3'b001;
      sw=16'h1001;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x3317, Got: 0x%h", led);
      
      //AND
      {btnl,btnc,btnr} = 3'b000;
      sw=16'hf0f0;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x3010, Got: 0x%h", led);
      
      //XOR
      {btnl,btnc,btnr} = 3'b111;
      sw=16'h1fa2;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x2fb2, Got: 0x%h", led);
      
      //ADD
      {btnl,btnc,btnr} = 3'b010;
      sw=16'h6aa2;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x9a54, Got: 0x%h", led);
      
      //Logical Shift Left
      {btnl,btnc,btnr} = 3'b101;
      sw=16'h0004;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0xa540, Got: 0x%h", led);
      
      //Shift Right Arithmetic
      {btnl,btnc,btnr} = 3'b110;
      sw=16'h0001;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0xd2a0, Got: 0x%h", led);
      
      //Less Than
      {btnl,btnc,btnr} = 3'b100;
      sw=16'h46ff;
      #10;
      btnd=1;
      #10;
      btnd=0;
      $display("Expected: 0x0001, Got: 0x%h", led);
      
      #20;
    $finish;
      
    end
  
endmodule