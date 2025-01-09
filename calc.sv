`include "alu.sv"
`include "calc_enc.sv"

module calc 
  (output reg [15:0] led,
   input [15:0] sw,
   input clk,btnc,btnl,btnu,btnr,btnd);
  
  reg [15:0] accumulator;
  wire signed [31:0] op1;
  wire signed [31:0] op2;
  wire [3:0] alu_op;
  wire [31:0] result;
  wire zero;
  
  alu alu_instance (
    .op1(op1),
    .op2(op2),
    .alu_op(alu_op),
    .zero(zero),
    .result(result)
  );
    
  calc_enc enc_instance (
    .btnc(btnc),
    .btnr(btnr),
    .btnl(btnl),
    .alu_op(alu_op)
  );
  
 
assign op1 = {{16{accumulator[15]}},accumulator};
assign op2 = {{16{sw[15]}},sw};
  
  always @(posedge clk) begin
    if (btnu) begin
          accumulator <= 16'b0;
    end
  
    else if (btnd) begin
        accumulator <= result[15:0];
    end
    
  end
  
  always @(*)
    begin
      led = accumulator;
    end
  
endmodule