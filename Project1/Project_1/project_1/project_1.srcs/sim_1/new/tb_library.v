`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2022 04:23:07 PM
// Design Name: 
// Module Name: library_tb
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

module tb_library(

    );
    /*gate variables*/
    reg a,b;
    wire xor2, or2, and2;

    xor2 UUT0(a,b,xor2);
    or2  UUT1(a,b,or2);
    and2 UUT2(a,b,and2);

    /* branch variables */
    reg [7:0] PC, BUSB;
    wire [7:0] PC_1, BrA;

    branch_addr UUT3(PC,BUSB,BrA);
    branch_inc  UUT4(PC,PC_1);

    /* mux variables */
    reg [7:0] PC_10, A_data, B_data, BrA0, RAA, mod_fn_unit, data_out;
    reg [5:0] constant;
    reg MA,MB;
    reg [1:0] MC, MD;
    wire [7:0] BUSA,BUSB0,PC0, BUSD;

    muxA UUT5(PC_10,A_data,MA,BUSA);
    muxB UUT6(constant,B_data,MB,BUSB0);
    muxC UUT7(PC_10,BrA0,RAA,MC,PC0);
    muxD UUT8(mod_fn_unit,data_out,MD,BUSD);

    /* constant_unit variables */
    reg [5:0] IM;
    reg cs;
    wire [7:0] constant0;

    constant_unit UUT9(IM, cs, constant0);

    initial 
    begin
        //clk = 0;
        a = 0;
        b = 0;
        PC = 0;
        BUSB = 10;
        #5
        a = 1;
        b = 0;
        PC = PC_1;
        BUSB = 10;
        #5
        a = 0;
        b = 1;
        PC = PC_1;
        BUSB = 10;
        #5
        a = 1;
        b = 1;
        PC = PC_1;
        BUSB = 10;
        #5
        PC_10 = 14;
        A_data = 15;
        MA = 0;
        constant = 0;
        B_data = 15;
        MB = 0;
        BrA0 = 16;
        RAA = 17;
        MC = 0;
        mod_fn_unit = 4;
        data_out = 5;
        MD = 0;
        #5
        MA = 1;
        MB = 1;
        MC = 1;
        MD = 1;
        #5
        MC = 2; 
        MD = 2;
        #5
        IM = 6'b010000;
        cs = 1;
        #5
        IM = 6'b110000;
        #5
        $finish;
    end

    always 
    begin
        #5;
        //clk =~clk;
    end
endmodule
