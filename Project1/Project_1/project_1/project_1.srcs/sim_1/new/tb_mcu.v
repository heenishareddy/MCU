`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2022 04:31:59 PM
// Design Name: 
// Module Name: tb_mcu
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


module tb_mcu(
    );
    /* REGISTERS */ 
    reg        RW_reg, RW1_reg, PS_reg, MW_reg, xor_1_out_reg;
    reg [1:0]  MD_reg, MD1_reg, BS_reg;
    reg [2:0]  DA_reg, DA1_reg, SH_reg; 
    reg [3:0]  FS_reg;
    reg [7:0]  PC_reg, PC1_reg, PC2_reg, BUSA_reg, BUSB_reg, F_reg, dataMemOut_reg;
    reg [16:0] IR_reg;
    /* Clocked variables */
    wire        xor_1_out, RW, MW, PS;
    wire [1:0]  BS, MD;
    wire [2:0]  DA;
    wire [3:0]  FS;
    wire [7:0]  PC0, PC1, F, dataMemOut;
    wire [16:0] IR;
    reg         RW0;
    reg  [2:0]  DA0, MD0, SH;

    /* variables */
    wire       xor_0_out, or_out, and_out, carry, zero, N, V, MA, MB, CS;
    wire [1:0] MC;
    wire [2:0] AA, BA;
    wire [7:0] BUSA, BUSB, BUSD, BrA, A_data, B_data, constant;
    reg        Z, BS1, BS0, clk, write;
    reg  [3:0] ALU_Sel;


    assign MC = {BS_reg[1],and_out};
    /* gate modules */
    xor2 xor_0(.a(PS_reg), .b(zero), .c(xor_0_out));
    xor2 xor_1(.a(N), .b(V), .c(xor_1_out));
    or2   UUT1(.a(BS_reg[1]), .b(xor_0_out), .c(or_out));
    and2  UUT2(.a(BS_reg[0]), .b(or_out), .c(and_out));
    /* branch modules */
    branch_addr UUT3(.PC(PC2_reg), .BUSB(BUSB), .BrA(BrA));
    branch_inc  UUT4(.PC(PC_reg), .PC_1(PC1));
    /* mux modules */
    muxA UUT5(.PC_1(PC1_reg), .A_data(A_data), .MA(MA), .BUSA(BUSA));
    muxB UUT6(.constant(constant), .B_data(B_data), .MB(MB), .BUSB(BUSB));
    muxC UUT7(.PC_1(PC1), .BrA(BrA), .RAA(BUSA_reg), .MC(MC), .PC(PC0));
    muxD UUT8(.mod_fn_unit(F_reg), .data_out(dataMemOut_reg), .flag(xor_1_out_reg), .MD(MD1_reg), .BUSD(BUSD));
    /* constant_unit modules */
    constant_unit CU(.IM(IR_reg[5:0]), .cs(CS), .constant(constant));
    /* ALU modules */    
    h_alu test_unit( .X(BUSA_reg), .Y(BUSB_reg),      // ALU 8-bit Inputs                 
                     .ALU_Sel(FS_reg), // ALU Selection
                     .SH(SH_reg),           // shift amount
                     .Z(F),             // ALU 8-bit Output
                     .c_flag(carry),    // Carry Out Flag
                     .zero_flag(zero),
                     .neg_flag(N),
                     .over_flag(V)      
                    );
    /* instruction_decoder modules */ 
    instruction_decoder ID(.instruction(IR_reg),.rw(RW),.ps(PS),.mw(MW),.ma(MA),.mb(MB),.cs(CS),.md(MD),.bs(BS),.da(DA),.aa(AA),.ba(BA),.fs(FS));
    /* register_file modules */
    register_file RF (.clk(clk), .a_address(AA), .b_address(BA), .d_address(DA1_reg), .dataIn(BUSD), .write(RW1_reg), .a_data(A_data), .b_data(B_data));
    /* memory modules */
    program_memory PM (.address(PC_reg), .instruction(IR));
    data_memory    DM (.clk(clk), .address(BUSA_reg), .write(MW_reg), .dataIn(BUSB_reg), .dataOut(dataMemOut));

    initial 
    begin
        PC_reg = 0;
        PC1_reg = 0;
        IR_reg = 0;

        PC2_reg = 0;
        BUSA_reg = 0;
        BUSB_reg = 0;
        RW_reg = 0;
        PS_reg = 0;
        MW_reg = 0;
        DA_reg = 0;
        SH_reg = 0;
        MD_reg = 0;
        BS_reg = 0;
        FS_reg = 0;

        RW1_reg = 0;
        DA1_reg = 0;
        MD1_reg = 0;
        xor_1_out_reg = 0;
        F_reg = 0;
        dataMemOut_reg = 0;

        clk = 0;
        #200
        $finish;
    end
    always @(posedge clk)
    begin
            PC_reg = PC0;

            PC1_reg = PC1;
            IR_reg = IR;

            PC2_reg = PC1_reg;
            BUSA_reg = BUSA;
            BUSB_reg = BUSB;
            RW_reg = RW;
            PS_reg = PS;
            MW_reg = MW;
            DA_reg = DA;
            SH_reg = IR[2:0];
            MD_reg = MD;
            BS_reg = BS;
            FS_reg = FS;

            RW1_reg = RW_reg;
            DA1_reg = DA_reg;
            MD1_reg = MD_reg;
            xor_1_out_reg = xor_1_out;
            F_reg = F;
            dataMemOut_reg = dataMemOut;

    end

    always 
    begin
        #5;
        clk =~clk;
    end
endmodule
