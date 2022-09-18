`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2022 06:09:37 PM
// Design Name: 
// Module Name: mcu
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


module mcu( input        clk,
            input        reset,
			input  [8:0] fpga_in,
            output [9:0] fpga_out
          );
    // Initial Stage
	// Register
	reg [7:0] PC_Reg;
	// Wire
	wire [7:0] MuxC_Out;

	// Instruction Fetch stage
	// Wire
	wire [7:0] Pc_Fetch, Pc_pc1_Fetch;
	wire [16:0] Inst_Fetch;
	wire [16:0] Branch_Fetch;
	// Register
	reg [7:0]  Pc1_IF_Reg;
	reg [16:0] IR_IF_Reg;

	// Assign PC_Fetch
	assign Pc_Fetch = PC_Reg;
	// PC_P1_Fetch Update
	assign Pc_pc1_Fetch = PC_Reg + 8'h1;  

	// Performing ProgramMem Fetch
	program_memory PM (.address(Pc_Fetch),.instruction(Inst_Fetch));

	// Decoder Stage
	// WIRES
	wire [2:0] AA_Decode,BA_Decode, DA_Decode, SH_Decode;
	wire [7:0] A_Data_Decode,B_Data_Decode,PC1_Decode;
	wire RW_Decode,RW_OUT_Decode,PS_Decode,MW_Decode, MA_Decode, MB_Decode,CS_Decode,BS_Invert_wire;
	wire [1:0] MD_Decode, BS_Decode;
	wire [3:0] FS_Decode;
	wire [7:0] busA_Decode, busB_Decode, constant_output_Decode;
	wire [5:0] IM_Decode;
	wire [16:0] IR_Decode;


	// Register 
	reg [7:0] PC2_Decode_Reg, busA_Decode_Reg, busB_Decode_Reg, A_IO_Decode_Reg, B_IO_Decode_Reg;
	reg RW_Decode_Reg,RW_OUT_Decode_Reg,PS_Decode_Reg,MW_Decode_Reg;
	reg [2:0] DA_Decode_Reg,SH_Decode_Reg;
	reg [1:0] MD_Decode_Reg, BS_Decode_Reg;
	reg [3 :0] FS_Decode_Reg;

	// Assignment of Wires
	assign PC1_Decode = Pc1_IF_Reg;
	assign IR_Decode = IR_IF_Reg;
	assign IM_Decode = IR_IF_Reg[5:0];
	assign SH_Decode = IR_IF_Reg[2:0];

	// Call Functions
	// Instruction Decoder
	instruction_decoder ID(.instruction(IR_Decode),.rw(RW_Decode),.rw_out(RW_OUT_Decode),.ps(PS_Decode),.mw(MW_Decode),.ma(MA_Decode),.mb(MB_Decode),.cs(CS_Decode),.md(MD_Decode),.bs(BS_Decode),.da(DA_Decode),.aa(AA_Decode),.ba(BA_Decode),.fs(FS_Decode));
			
	// Constant Unit Call
	constant_unit CU(.IM(IM_Decode),.cs(CS_Decode),.constant(constant_output_Decode));
	
	// Branch Detection Call
	branchDetection BD(.BS_In(BS_Decode),.RW_In(RW_Decode),.MW_In(MW_Decode),.PS_In(PS_Decode),.Inst_In(Inst_Fetch),.BranchD_O(Branch_Fetch),.BS_N(BS_Invert_wire));   

    // Execution Stage
	// WIRES
	wire RW_Execution,RW_OUT_Execution,PS_Execution, MW_Execution;
	wire [2:0] DA_Execution,SH_Execution; 
	wire [1:0] MD_Execution,BS_Execution;
	wire [3:0] FS_Execution; 
	wire [7:0] PC2_Execution;
	wire [7:0] BrA_Execution; 
	wire [7:0] BusB_Execution,RAA_Execution,A_IO_Execution,B_IO_Execution;
	wire [7:0] ALU_FS_Execution,Datamem_Execution,IO_OUT_Execution;
	wire Zero_Execution,Carry_Execution,Neg_Execution,Overflow_Execution;
	wire DHS_Out, DHS_Not_W;

	// REGISTER
	reg RW_Execution_Reg;
	reg [2:0] DA_Execution_Reg;
	reg [1:0] MD_Execution_Reg;
	reg [7:0] ALU_Execution_Reg, Datamem_Execution_Reg,IO_OUT_Execution_Reg;

	//Assignment of Wires
	assign RW_Execution     = RW_Decode_Reg; 
	assign RW_OUT_Execution = RW_OUT_Decode_Reg;
	assign PS_Execution     = PS_Decode_Reg;
	assign MW_Execution     = MW_Decode_Reg;
	assign DA_Execution     = DA_Decode_Reg; 
	assign SH_Execution     = SH_Decode_Reg;
	assign MD_Execution     = MD_Decode_Reg;
	assign BS_Execution     = BS_Decode_Reg;
	assign FS_Execution     = FS_Decode_Reg;
	assign PC2_Execution    = PC2_Decode_Reg; 
	assign BusB_Execution   = busB_Decode_Reg;
	assign RAA_Execution    = busA_Decode_Reg;
	assign A_IO_Execution   = A_IO_Decode_Reg; 
	assign B_IO_Execution   = B_IO_Decode_Reg;

	// MUXC
	muxC MUXC_Call (.PC_1(Pc_pc1_Fetch),.BrA(BrA_Execution),.RAA(RAA_Execution),.BS(BS_Execution),.PS(PS_Execution),.Z(Zero_Execution),.PC(MuxC_Out));
	
	// Adder Call
	branch_addr addr(.PC(PC2_Execution),.BUSB(BusB_Execution),.BrA(BrA_Execution));

	// ALU Call
	h_alu alu(.ALU_Sel(FS_Execution),.SH(SH_Execution),.X(RAA_Execution),.Y(BusB_Execution),.Z(ALU_FS_Execution),.zero_flag(Zero_Execution),.neg_flag(Neg_Execution),.c_flag(Carry_Execution),.over_flag(Overflow_Execution));

	// Data Memory Call
	data_memory DM(.clk(clk),.address(RAA_Execution),.write(MW_Execution),.dataIn(BusB_Execution),.dataOut(Datamem_Execution));
	// IO Module call
	mcu_io IO_MODULE(.clk(clk),.reset(reset),.output_write_enable(RW_OUT_Execution),.output_data_in(B_IO_Execution),.output_data_address(A_IO_Execution),.input_data_out(IO_OUT_Execution),.fpga_in(fpga_in),.fpga_out(fpga_out));

	// DHS Call
	DHS_func DHS(.MA(MA_Decode),.MB(MB_Decode),.RW(RW_Execution),.AA(AA_Decode),.BA(BA_Decode),.DA(DA_Execution),.DHS_O(DHS_Out),.DHS_I(DHS_Not_W));

    // Last stage -- Write Back //

	///WIRES
	wire [7:0] alu_wb,busD_wb,datamem_wb,IO_OUT_wb;
	wire rw_wb;
	wire [2:0] da_wb;
	wire [1:0] md_wb;

	//Assignment
	assign alu_wb = ALU_Execution_Reg;
	assign da_wb = DA_Execution_Reg;
	assign rw_wb = RW_Execution_Reg;
	assign datamem_wb = Datamem_Execution_Reg;
	assign IO_OUT_wb = IO_OUT_Execution_Reg;
	assign md_wb = MD_Execution_Reg;
	// Register file call
	register_file RF(.clk(clk),.a_address(AA_Decode),.b_address(BA_Decode),.d_address(da_wb),.dataIn(busD_wb),.write(rw_wb),.a_data(A_Data_Decode),.b_data(B_Data_Decode));
	// MUX D Call
	muxD muxD_call(.mod_fn_unit(alu_wb),.data_out(datamem_wb),.storeVal(IO_OUT_wb),.flag(1'b0),.MD(md_wb),.BUSD(busD_wb));
	
	// MUX A,
	muxA MUXA_Call(  .PC_1(PC1_Decode),.A_data(A_Data_Decode),.MA(MA_Decode),.BUSA(busA_Decode));
	// MUX B
	muxB MUXB_Call( .constant(constant_output_Decode),.B_data(B_Data_Decode),.MB(MB_Decode),.BUSB(busB_Decode));

	// Initilization of Registers
	initial 
	begin
		PC_Reg = 0;
		Pc1_IF_Reg = 0;
		IR_IF_Reg = 0;

		// Decoder stage

		PC2_Decode_Reg    = 0;
		busA_Decode_Reg   = 0;
		busB_Decode_Reg   = 0;
		A_IO_Decode_Reg   = 0;
		B_IO_Decode_Reg   = 0;
		RW_Decode_Reg     = 0;
		RW_OUT_Decode_Reg = 0;
		PS_Decode_Reg     = 0;
		MW_Decode_Reg     = 0;
		DA_Decode_Reg     = 0;
		SH_Decode_Reg     = 0;
		MD_Decode_Reg     = 0;
		BS_Decode_Reg     = 0;
		FS_Decode_Reg     = 0;

		// Execution stage
		RW_Execution_Reg      = 0;
		DA_Execution_Reg      = 0;
		MD_Execution_Reg      = 0;
		ALU_Execution_Reg     = 0;
		Datamem_Execution_Reg = 0;
		IO_OUT_Execution_Reg  = 0;
	end

	// Register Assignment
	always @(posedge clk)
	begin
		if((DHS_Out == 0) && (!(BS_Decode[0] || BS_Decode[1])))
		begin

			PC_Reg = MuxC_Out;

			// Instruction fetch
			Pc1_IF_Reg = Pc_pc1_Fetch;
			IR_IF_Reg  = Inst_Fetch;

			// Decode stage
			PC2_Decode_Reg    = PC1_Decode;
			busA_Decode_Reg   = busA_Decode;
			busB_Decode_Reg   = busB_Decode;
			if(RW_OUT_Execution) begin
				A_IO_Decode_Reg      = busA_Decode;
				B_IO_Decode_Reg      = busB_Decode;
			end
			RW_Decode_Reg     = RW_Decode;
			RW_OUT_Decode_Reg = RW_OUT_Decode;
			PS_Decode_Reg     = PS_Decode;
			MW_Decode_Reg     = MW_Decode;
			DA_Decode_Reg     = DA_Decode;
			SH_Decode_Reg     = SH_Decode;
			MD_Decode_Reg     = MD_Decode;
			BS_Decode_Reg     = BS_Decode;
			FS_Decode_Reg     = FS_Decode;

			// Execution stage
			RW_Execution_Reg      = RW_Execution;
			DA_Execution_Reg      = DA_Execution;
			MD_Execution_Reg      = MD_Execution;
			ALU_Execution_Reg     = ALU_FS_Execution;
			Datamem_Execution_Reg = Datamem_Execution;
			IO_OUT_Execution_Reg  = IO_OUT_Execution;

	
		end

		else if((DHS_Out == 1) && (!(BS_Decode[0] || BS_Decode[1]))) // DHS
		begin

			// PC_Reg = MuxC_Out;
			
			// Instruction Fetch
			Pc1_IF_Reg = Pc1_IF_Reg;
			IR_IF_Reg  = IR_IF_Reg;
			
			// Decode stage
			PC2_Decode_Reg    = PC2_Decode_Reg;
			busA_Decode_Reg   = busA_Decode;
			busB_Decode_Reg   = busB_Decode;
			if(RW_OUT_Execution) begin
				A_IO_Decode_Reg      = busA_Decode;
				B_IO_Decode_Reg      = busB_Decode;
			end
			RW_Decode_Reg     = RW_Decode && DHS_Not_W;
			RW_OUT_Decode_Reg = RW_OUT_Decode;
			DA_Decode_Reg     = DA_Decode && {2{DHS_Not_W}};
			MD_Decode_Reg     = MD_Decode;
			BS_Decode_Reg     = BS_Decode && {2{DHS_Not_W}};
			PS_Decode_Reg     = PS_Decode;
			MW_Decode_Reg     = MW_Decode && DHS_Not_W;
			FS_Decode_Reg     = FS_Decode;
			SH_Decode_Reg     = SH_Decode;
			
			// Execution Stage
			RW_Execution_Reg      = RW_Execution;
			DA_Execution_Reg      = DA_Execution;
			MD_Execution_Reg      = MD_Execution;
			ALU_Execution_Reg     = ALU_FS_Execution;
			Datamem_Execution_Reg = Datamem_Execution;
			IO_OUT_Execution_Reg  = IO_OUT_Execution;
		end 

		else if ((DHS_Out == 0) && (BS_Decode[0] || BS_Decode[1])) // branch
		begin

			PC_Reg = MuxC_Out;

			// Instruction fetch
			Pc1_IF_Reg = Pc_pc1_Fetch;
			IR_IF_Reg  = Branch_Fetch;

			// Decode stage
			PC2_Decode_Reg    = PC1_Decode;
			busA_Decode_Reg   = busA_Decode;
			busB_Decode_Reg   = busB_Decode;
			if(RW_OUT_Execution) begin
				A_IO_Decode_Reg      = busA_Decode;
				B_IO_Decode_Reg      = busB_Decode;
			end
			RW_Decode_Reg     = RW_Decode && BS_Invert_wire;
			RW_OUT_Decode_Reg = RW_OUT_Decode && BS_Invert_wire;
			DA_Decode_Reg     = DA_Decode;
			MD_Decode_Reg     = MD_Decode;
			BS_Decode_Reg     = BS_Decode;
			PS_Decode_Reg     = PS_Decode;
			MW_Decode_Reg     = MW_Decode && BS_Invert_wire;
			FS_Decode_Reg     = FS_Decode;
			SH_Decode_Reg     = SH_Decode;

			// Execution Stage
			RW_Execution_Reg      = RW_Execution;
			DA_Execution_Reg      = DA_Execution;
			MD_Execution_Reg      = MD_Execution;
			ALU_Execution_Reg     = ALU_FS_Execution;
			Datamem_Execution_Reg = Datamem_Execution;
			IO_OUT_Execution_Reg  = IO_OUT_Execution;

		end
	end
endmodule