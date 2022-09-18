`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:34:21 02/07/2022
// Design Name:   h_alu
// Module Name:   C:/Users/hxr210022/Desktop/New folder/h_alu/h_alutb.v
// Project Name:  h_alu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: h_alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_alu;
//Inputs
  reg[7:0] X,Y;
  reg[3:0] ALU_Sel;
  reg[2:0] SH;

//Outputs
  wire[7:0] Z;
  wire carry,zero,neg,over;
  
  // Verilog code for ALU
  integer i;
  h_alu test_unit( X,Y,  // ALU 8-bit Inputs                 
                   ALU_Sel,// ALU Selection
                   SH,
                   Z, // ALU 8-bit Output
                   carry,
                   zero,
                   neg,
                   over // Carry Out Flag
                  );
    initial begin
    // hold reset state for 100 ns.
      X = 8'h0A;
      Y = 4'h0B;
      ALU_Sel = 4'h0;
      SH = 2;
      
      for (i=0;i<=15;i=i+1)
      begin
        ALU_Sel = i;
        #10;
      end;
      
      X = 8'hF6;
      Y = 8'h0A;
      #10;
      $finish; 
    end
endmodule
