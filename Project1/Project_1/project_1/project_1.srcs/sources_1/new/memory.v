`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UTD
// Engineer: Steven 
// 
// Create Date: 01/28/2022 06:31:36 PM
// Design Name: 
// Module Name: program_memory
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


module program_memory( input      [7:0]  address, 
                       output reg [16:0] instruction );
    /*
        The program memory will contain an 256x17 bit memory. It will use the program counter
        as the address and output the corresponding 17-bit instruction from the memory.
    */
    reg[16:0]mem[255:0];
    initial begin
        //          5     |3 |3 |3 |3
        //          opcode|DR|RA|RB|nothing
        /* normal */
        // mem[0] = 17'b00000000000000000;//nop
        // mem[1] = 17'b00100011001010000;//add, 3, 1, 2
        // mem[2] = 17'b01000100001010000;//sub, 4, 1, 3
        /* raw */
        // mem[0] = 17'b00000000000000000;//nop
        // mem[1] = 17'b00100011001010000;//add, 3, 1, 2
        // mem[2] = 17'b01000100001011000;//sub, 4, 1, 3
        /* branch detect */
        /* lsl test */
        // mem[0] = 17'b00000000000000000;//nop
        // mem[1] = 17'b10011100001000001;//lsl,
        // mem[2] = 17'b00000000000000000;//nop
        // mem[3] = 17'b10101100001000001;//lsr,5
        /* jmp test */
        // mem[0] = 17'b00000000000000000;//nop
        // mem[1] = 17'b00011000000000000;//jmr

        /* demo code */
        mem[0] = 17'b00000000000000000;    //nop
        mem[1] = 17'b10111_001_000_000_000;// input R1
        mem[2] = 17'b10011_010_001_000_100;// lsl r2,r1,4
        mem[3] = 17'b10101_010_010_000_100;// lsr r2,r2,4
        mem[4] = 17'b10101_011_001_000_100;// lsr r3,r1,4
        mem[5] = 17'b10110_000_010_011_000;// output r2,r3
        mem[6] = 17'b00011000000000000;// jmr r0
        
    end
    always @(address) begin
        instruction = mem[address];
    end
    
endmodule

module data_memory( input            clk,
                    input      [7:0] address, 
                    input            write,
                    input      [7:0] dataIn, 
                    output reg [7:0] dataOut );
    /*
        The data memory will be a 256 byte memory. The address input will be used to determine
        the address being written to or read from. At the edge of the clock, the value of the data
        input will be written to the memory address only if the write enable input is set to
        the correct level. Regardless, the data output will output the byte located in the memory
        at the address being input.
    */
    reg[7:0]mem[255:0];
    always @(negedge clk ) begin
        if(write)
            mem[address] = dataIn;
 
        dataOut = mem[address];
    end
endmodule 

