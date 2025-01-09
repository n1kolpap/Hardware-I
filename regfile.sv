module regfile
  #(parameter DATAWIDTH = 32)
  
  (output reg [DATAWIDTH-1:0] readData1,
   output reg [DATAWIDTH-1:0] readData2,
   input clk,
   input [4:0] readReg1,
   input [4:0] readReg2,
   input [4:0] writeReg,
   input [DATAWIDTH-1:0] writeData,
   input write);
  
  reg [DATAWIDTH-1:0] registers [31:0];
  integer i;
  
  initial begin
    for(i=0; i<32; i=i+1)
      begin
        registers[i] = 0;
      end
  end
  
  always @(posedge clk)
    begin
      readData1 <= registers[readReg1];
      readData2 <= registers[readReg2];
      
      
      if (write)
        begin
          registers[writeReg] <= writeData;
          
          if (writeReg == readReg1)
            readData1 <= writeData; //προτεραιοτητα στο writeData αν η διευθυνση εγγραφης ειναι ιδια με τη διευθυνση αναγνωσης
          if (writeReg == readReg2)
            readData2 <= writeData;
        end
    end
endmodule