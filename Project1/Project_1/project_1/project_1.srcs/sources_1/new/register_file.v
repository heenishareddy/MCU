`timescale 1ns / 1ps

module register_file( input            clk,
                      input      [2:0] a_address,
                      input      [2:0] b_address,
                      input      [2:0] d_address, 
                      input      [7:0] dataIn, 
                      input            write,
                      output reg [7:0] a_data,
                      output reg [7:0] b_data );
    /*There will be a zero register and 7 general purpose registers. The zero register will always
    have a value of 0 that cannot be changed (this will be index 0). The 7 remaining registers
    (indices 1-7) will potentially be overwritten. The A and B Data outputs are controlled by
    the A and B Address inputs, respectively. Whatever the value of A Address is determines
    the register value that will be output to the A Data output. The same applies to the B 
    Address input and the B Data output. The D Address, Data In, and Write Enable inputs
    will be used to control the writing of data to the registers. If writing is enabled by the Write
    Enable input, then when the clock pulses the value from Data In will be stored in the register
    associated with the D Address value (with the exception of the zero register). For example,
    if the D Address input is '010', then the value of Data In will be stored in register 2.*/
    reg[7:0] registers[7:0];
    reg[7:0] k = 0;
    initial begin
        registers[0] = 0;//0
        // registers[1] = 0;//a
        // registers[2] = 0;//b
        // registers[3] = 0;//add
        // registers[4] = 0;//sub
        // registers[5] = 0;//not
        // registers[6] = 0;
        // registers[7] = 0;
    end
    
    always @* begin
        a_data = registers[a_address];
        b_data = registers[b_address];
    end
    
    always @(negedge clk ) begin
        if(write)begin
            if(d_address!= 0)
                registers[d_address] = dataIn;
        end
    end
    
endmodule
