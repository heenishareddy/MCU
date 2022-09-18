`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2022 01:29:46 PM
// Design Name: 
// Module Name: tb_mcu0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mcu0(

    );
    reg clk, reset;
    wire mcu_out;
    reg [8:0] fpga_in;
    wire [9:0] fpga_out;
    mcu top(clk, reset, fpga_in, fpga_out);


    initial
    begin
        clk = 0;
        fpga_in = 9'b101010101;
        reset = 1;
        #200
        fpga_in = 9'b111111111;
        #1000
        $finish;   
    end

    always
    begin
        fpga_in = 9'b000000000;
        #10
        fpga_in = 9'b111111010;
        #10
        fpga_in = 9'b101111101;
        #10
        fpga_in = 9'b100000101;
        #10
        fpga_in = 9'b111111101;
        #10
        fpga_in = 9'b101010000;
        #10;
    end
    
    always 
    begin
        #1;
        clk =~clk;
    end

endmodule
