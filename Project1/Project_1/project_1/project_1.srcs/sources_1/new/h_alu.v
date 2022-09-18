`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:27:36 02/07/2022 
// Design Name: 
// Module Name:    h_alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module h_alu( input      [7:0] X,Y,    // ALU 8-bit Inputs                 
              input      [3:0] ALU_Sel,// ALU Selection
              input      [2:0] SH,     // shift amount
              output     [7:0] Z,     // ALU 8-bit Output
              output           c_flag,      // Carry Out Flag
              output           zero_flag,   // zero flag
              output           neg_flag,    // negative flag
              output           over_flag    // overflow flag
            );

  reg [7:0] ALU_Result;
  assign Z = ALU_Result; // ALU out
  assign c_flag = 0; // Carryout flag
  assign zero_flag = ~(|ALU_Result);
  assign neg_flag = (ALU_Result[7] == 1 && ALU_Sel == 4'b0001);
  assign over_flag= 0;
  always @(*)
    begin
      case(ALU_Sel)
        4'b0000: // Addition
          ALU_Result = X + Y ; 
        4'b0001: // Subtraction
          ALU_Result = X - Y ;
        4'b0010: // Multiplication
          ALU_Result =!X;
        4'b0011: // Division
          ALU_Result = X/Y;
        4'b0100: // Logical shift left
          ALU_Result = X<<SH;
        4'b0101: // Logical shift right
          ALU_Result = X>>SH;
        4'b0110: // Rotate left
          ALU_Result = {X[6:0],X[7]};
        4'b0111: // Rotate right
          ALU_Result = {X[0],X[7:1]};
        4'b1000: //  Logical and 
          ALU_Result = X & Y;
        4'b1001: //  Logical or
          ALU_Result = X | Y;
        4'b1010: //  Logical xor 
          ALU_Result = X ^ Y;
        4'b1011: //  Logical nor
          ALU_Result = ~(X | Y);
        4'b1100: // Logical nand 
          ALU_Result = ~(X & Y);
        4'b1101: // Logical xnor
          ALU_Result = ~(X ^ Y);
        4'b1110: // Greater comparison
          ALU_Result = (X>Y)?8'd1:8'd0 ;
        4'b1111: // Equal comparison   
          ALU_Result = (X==Y)?8'd1:8'd0 ;
        default: ALU_Result = X + Y ; 
      endcase
    end
  
endmodule


