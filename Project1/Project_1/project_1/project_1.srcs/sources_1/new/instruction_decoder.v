`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create date: 02/14/2022 04:25:23 PM
// Design Name: 
// Module Name: instruction_decoder
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


module instruction_decoder( input [16:0] instruction,
                            output reg       rw,
                            output reg       rw_out,
                            output reg [2:0] da,
                            output reg [1:0] md,
                            output reg [1:0] bs,
                            output reg       ps,
                            output reg       mw,
                            output reg [3:0] fs,
                            output reg       ma,
                            output reg       mb,
                            output reg [2:0] aa,
                            output reg [2:0] ba,
                            output reg       cs );

    always @(*)
    begin
        case(instruction[16:12])
        5'b00000: begin //nop
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = 3'b0;
            aa = 3'b0;
            ba = 3'b0;
            fs = 4'b0;
        end
        5'b00001: begin //xri
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1010;
        end
        5'b00010: begin //BZ
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b01;
            da = 3'b0;
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1010;
        end
        5'b00011: begin //jmr
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b10;
            da = 3'b0;
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0000;
        end
        5'b00100: begin //add
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b0000;
        end
        5'b00101: begin //and
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b1000;
        end
        5'b00110: begin //in
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b01;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0000;
        end
        5'b00111: begin //ld
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b01;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0000;
            
        end
        5'b01000: begin //sub
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b0001;
        end
        5'b01001: begin //not
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0010;            
        end
        5'b01010: begin //jml
            rw = 1;
            ps = 2'b0;
            mw = 0;
            ma = 1;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b11;
            da = instruction[11:9];
            aa = 3'b0;
            ba = 3'b0;
            fs = 4'b1010;            
        end
        5'b01011: begin //aiu
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1010;
        end
        5'b01100: begin //ori
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1001;            
        end
        5'b01101: begin //st
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 1;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b00;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b0000;            
        end
        5'b01110: begin //out
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 1;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = 3'b0;
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b0000;
        end
        5'b01111: begin //slt
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = instruction[5:3];
            fs = 4'b1000;            
        end
        5'b10000: begin //mov
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1010;            
        end
        5'b10001: begin //adi
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0001;            
        end
        5'b10010: begin //bnz
            rw = 0;
            rw_out = 0;
            ps = 2'b01;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b11;
            da = 3'b0;
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b1010;            
        end
        5'b10011: begin //lsl
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0100;            
        end
        5'b10100: begin //jmp
            rw = 0;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 1;
            cs = 1;
            md = 2'b0;
            bs = 2'b11;
            da = 3'b0;
            aa = 3'b0;
            ba = 3'b0;
            fs = 4'b0000;            
        end
        5'b10101: begin //lsr
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = instruction[11:9];
            aa = instruction[8:6];
            ba = 3'b0;
            fs = 4'b0101;           
        end
        5'b10110: begin // output r3 to r2
            rw = 0;
            rw_out = 1;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b0;
            bs = 2'b0;
            da = 3'b0;
            aa = instruction[8:6];
            ba = instruction[5:3];;
            fs = 4'b1010;
        end
        5'b10111: begin // input r1
            rw = 1;
            rw_out = 0;
            ps = 2'b0;
            mw = 0;
            ma = 0;
            mb = 0;
            cs = 0;
            md = 2'b11;
            bs = 2'b0;
            da = instruction[11:9];
            aa = 3'b0;
            ba = 3'b0;
            fs = 4'b1010;            
        end
        endcase
    end
endmodule
