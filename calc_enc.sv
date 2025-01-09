module calc_enc
  (output [3:0] alu_op,
   input btnc,btnr,btnl);
  
  wire not_btnc,not_btnr,not_btnl;
  wire y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11;

  
  not(not_btnc,btnc);
  not(not_btnr,btnr);
  not(not_btnl,btnl);
  
  //alu_op[0]
  and(y1,not_btnc,btnr);
  and(y2,btnr,btnl);
  or(alu_op[0],y1,y2);
  
  //alu_op[1]
  and(y3,not_btnl,btnc);
  and(y4,btnc,not_btnr);
  or(alu_op[1],y3,y4);
  
  //alu_op[2]
  and(y5,btnl,not_btnc);
  and(y6,y5,not_btnr);
  and(y7,btnc,btnr);
  or(alu_op[2],y6,y7);
  
  //alu_op[3]
 
  and(y8,btnl,btnc);
  and(y9,btnl,not_btnc);
  and(y10,y8,not_btnr);
  and(y11,y9,btnr);
  or(alu_op[3],y11,y10);
  
endmodule