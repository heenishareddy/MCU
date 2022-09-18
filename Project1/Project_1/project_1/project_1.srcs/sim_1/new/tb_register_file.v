`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2022 04:20:08 PM
// Design Name: 
// Module Name: tb_register_file
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


module tb_register_file(

    );
    /* register_file variables*/ 
    reg        clk;
    reg  [2:0] a_address;
    reg  [2:0] b_address;
    reg  [2:0] d_address;
    reg  [7:0] dataIn;
    reg        write;
    wire [7:0] a_data;
    wire [7:0] b_data;
    register_file UUT2 (clk, a_address, b_address, d_address, dataIn, write, a_data, b_data);
    
    initial
    begin
        clk = 0;
        write = 1;
        a_address = 0;
        b_address = 0;
        d_address = 0;
        dataIn = 55;
        #10;
        d_address = 1;
        dataIn = 255;
        #10;
        a_address = 1;
        b_address = 1;
        d_address = 2;
        dataIn = 254;
        #10;
        a_address = 2;
        b_address = 2;
        d_address = 3;
        dataIn = 253;
        #10;
        a_address = 0;
        b_address = 0;
        d_address = 4;
        dataIn = 252;
        #10;
        a_address = 4;
        b_address = 4;
        d_address = 5;
        dataIn = 251;
        #10;
        a_address = 5;
        b_address = 5;
        d_address = 6;
        dataIn = 250;
        #10;
        a_address = 6;
        b_address = 6;
        d_address = 7;
        dataIn = 249;
        #10;
        write = 0;
        a_address = 7;
        b_address = 7;
        #10;
        d_address = 1;
        dataIn = 171;
        #10;
        d_address = 2;
        dataIn = 171;
        a_address = 1;
        b_address = 1;
        #10;
        a_address = 2;
        b_address = 2;
        #10;
        $finish; 
    end
    
    always 
    begin
        #5;
        clk =~clk;
    end
endmodule
