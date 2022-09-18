`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 03:48:35 PM
// Design Name: 
// Module Name: tb_memory
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

module tb_memory(

    );
    /* program_memory variables*/
    reg [7:0]  pm_address;
    wire [16:0] instruction;
    /* data_memory variables*/
    reg clk, write;
    reg [7:0] dm_address;
    reg [7:0] dataIn;
    wire [7:0] dataOut;
    
    program_memory UUT0 (pm_address,instruction);
    data_memory    UUT1 (clk, dm_address, write, dataIn, dataOut);
    
    initial
    begin
        clk = 0;
        write = 1;
        #6
        dataIn = 33;
        dm_address = 0;
        pm_address = 01;
        #10;      
        pm_address = 02;
        #5;
        write = 0;
        dm_address = 0;
        dataIn = 22;
        pm_address = 03; 
        #10;
        #10;
        $finish;       
    end
    
    always 
    begin
        #5;
        clk =~clk;
    end
endmodule
