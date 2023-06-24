/********************************************************************/
/*****************		 RISC-V architecture       ******************/
/********************************************************************/
/**************** DESIGNDE BY : ABDERRAHIM EL HAMZI *****************/
/********************************************************************/


module risc_v_basic (input clk, rst_n
					);

/*************SIGNALS-DECLARATION***************/
	parameter 	bus_length = 64 ,
				addr_size = 5,
				data_length = 64,
				MUX_length = 64, 		// alu input length
				Shifter_Length = 64; 	// left shifter input length

// pc_inst signals
	wire	[bus_length -1 :0] 	pc_input;			
	wire 	[bus_length -1 :0]  pc_output;	
	
// mem_instr signals
	wire [bus_length -1:0] 	read_address;
    wire [31:0] 			instruction;
	
// adderPC_inst signals
	wire [bus_length-1:0] PC_in_ADD_1;
	wire [bus_length-1:0] PC_in_ADD_2;
	wire [bus_length-1:0] PC_result;

// adderBR_inst signals
	wire [bus_length-1:0] BR_in_ADD_1;
	wire [bus_length-1:0] BR_in_ADD_2;
	wire [bus_length-1:0] BR_result;
		
// reg_inst signals
	// wire 					reg_write;
	wire [addr_size-1:0] 	read_reg1,read_reg2;
	wire [addr_size-1:0] 	write_reg;
	wire [data_length-1:0] 	RF_write_data;
	wire [data_length-1:0] 	read_data1, read_data2;
	
// alu_inst signals 
	// wire [3:0] alu_op;                       
	wire [data_length-1:0] alu_in1, alu_in2; 
	wire [data_length-1:0] alu_result;    
	wire zero ;
	
// muxALU_inst signals
	// wire 					ALUSrc;
	wire [MUX_length-1:0]	Mux_alu_in_0, Mux_alu_in_1;
	wire [MUX_length-1:0]	Mux_alu_out;
	
// muxMEM_inst signals
	// wire 					MemToReg;
	wire [MUX_length-1:0] 	Mux_Mem_in_0, Mux_Mem_in_1;
	wire [MUX_length-1:0] 	Mux_Mem_out;
	
// muxIMM_inst signals
	// wire 					PCSrc;
	wire [MUX_length-1:0] 	Mux_Imm_in_0, Mux_Imm_in_1;
	wire [MUX_length-1:0] 	Mux_Imm_out;

// dataMem_inst signals
	// wire 					Mem_Read, Mem_Write;
  	wire [63:0] 	DM_address;
    wire [data_length-1:0] 	DM_write_data;
	wire [data_length-1:0] 	read_Data;
	
// ImmGen_inst signals
	wire [data_length-1:0] in_Imm;
    wire [data_length-1:0] extnd_Imm;
	
// shiftLeft_inst signals 
	wire [Shifter_Length-1:0] shifter_data_in;
    wire [Shifter_Length-1:0] shifted_data;
	
// aluControl_inst signals 
	// wire [1:0] 	ALU_Op    ;
	wire 		funct7    ;
	wire [2:0]	funct3    ;
	wire [3:0]	ALU_ctrl_operation ;

  
/****************CONCTROL-SIGNALS****************/
    wire 		PCSrc ;

    wire 		reg_write ;
    wire		ALUSrc ;
    wire 		Branch ;
    wire 		Mem_Read, Mem_Write ;
    wire [1:0] 	ALU_Op ;
    wire 		MemToReg;

    assign		PCSrc = Branch & zero ; // branch if equal Src1 and Src2.


/************COMPONENT-DECLARATION*************/

	pc pc_inst(	.clk       (clk), 
				.rst_n     (rst_n),
				.pc_input  (pc_input),
				.pc_output (pc_output)
				);

	mem_instr memInstr_inst(.clk		  (clk) ,
							.read_address (read_address) ,
							.instruction  (instruction)
							);
	adder adderPC_inst(	.input_1(PC_in_ADD_1),
						.input_2(PC_in_ADD_2),
                       	.result (PC_result)
						);

	adder adderBR_inst(	.input_1(BR_in_ADD_1),
						.input_2(BR_in_ADD_2),
						.result (BR_result)
						);
						
	registers reg_inst(	.clk		(clk), 
						.reg_write	(reg_write),
						.read_reg1	(read_reg1),
						.read_reg2	(read_reg2),
						.write_reg	(write_reg),
						.write_data	(RF_write_data),
						.read_data1	(read_data1), 
						.read_data2	(read_data2)
						);

  	alu alu_inst(	.alu_operation		(ALU_ctrl_operation) ,
					.alu_in1	(alu_in1), 
					.alu_in2	(alu_in2),
					.alu_result	(alu_result),
					.zero		(zero) 
					);		

	Mux muxALU_inst(.sel	(ALUSrc),
					.in_0	(Mux_alu_in_0), 
					.in_1	(Mux_alu_in_1),
					.outmux	(Mux_alu_out)
					);
					
	Mux muxMEM_inst(.sel	(MemToReg),
					.in_0	(Mux_Mem_in_0), 
					.in_1	(Mux_Mem_in_1),
					.outmux	(Mux_Mem_out)
					);

	Mux muxIMM_inst(.sel	(PCSrc),
					.in_0	(Mux_Imm_in_0), 
					.in_1	(Mux_Imm_in_1),
					.outmux	(Mux_Imm_out)
					);

	data_Mem dataMem_inst(	.clk		(clk) ,
							.Mem_Read	(Mem_Read), 
							.Mem_Write	(Mem_Write),
							.address	(DM_address),
							.write_Data	(DM_write_data),
							.read_Data	(read_Data)
							);
	
	Imm_gen ImmGen_inst(.in_Imm		(in_Imm),
						.extnd_Imm	(extnd_Imm)
						);	
					
	shift_left shiftLeft_inst(	.in_data	  (shifter_data_in),
								.shifted_data (shifted_data)
								);
	
	alu_control aluControl_inst(.ALU_Op		(ALU_Op),
								.funct7		(funct7),
								.funct3		(funct3),
								.operation	(ALU_ctrl_operation)
								);
								
/************COMPONENT-INTERCONNECTING*************/	

	// 		Program Counter		<==== muxIMM_inst	
	assign pc_input = Mux_Imm_out ;
	
	
	// 		Program Counter		====> Instruction memory 	
	assign read_address = pc_output ;
	
	//		Program Counter		====> adderPC
	assign PC_in_ADD_1 = 64'd4 ;
	assign PC_in_ADD_2 = pc_output ;
	
	//		Instruction memory 	====> registers
	assign read_reg1 = instruction[19:15];
	assign read_reg2 = instruction[24:20];
	assign write_reg = instruction[11:7];
	
	//		Instruction memory 	<==== muxMEM_inst
	assign RF_write_data = Mux_Mem_out ;
	
	//		Instruction memory 	====> ALU INPUT 1
	assign alu_in1 = read_data1 ;
	
	//		Instruction memory 	====> muxALU
	assign Mux_alu_in_0 = read_data2 ;

  	//		muxALU 	====> 	ALU INPUT 2
	assign alu_in2 = Mux_alu_out ;
  
	//		Instruction memory 	====> data Memory 
	assign DM_write_data = read_data2 ;
	
	//		Imm generator 		====> left shifter
	assign Mux_alu_in_1 = extnd_Imm ;
	
	//		Imm generator 		====> left shift alu mux
	assign shifter_data_in = extnd_Imm ;
	
	//		Imm generator 		<==== instruction Memory 
	assign in_Imm = instruction ;
	
	//		aluControl			====>  ALU 
	// assign ALU_Op = ALU_ctrl_operation ;
	
	//		aluControl			<====   instruction Memory
	assign funct3 = instruction[14:12];
	assign funct7 = instruction[30];
	
	//		adderbBR		<==== Program Counter
	assign BR_in_ADD_1  = pc_output ;
	
	//		adderbBR		<==== Program Counter
	assign BR_in_ADD_2  = shifted_data ;
	
	//		adderbBR		<==== Mux branching
	assign Mux_Imm_in_1 = BR_result ;
	
	//		PC adder		====> Mux branching
	assign Mux_Imm_in_0 = PC_result ;
	
	//		Data memory		<==== ALU
	assign DM_address = alu_result ;
	
	//		Data memory		====> Mux MEM 
	assign Mux_Mem_in_1 = read_Data ;
	
	//		Mux MEM			<==== ALU
	assign Mux_Mem_in_0 = alu_result ;
	
	

	
/*************CU-OF-CPU*************/	
  signle_cycle_CU	CU_SIGNLE_CYCLE	(.opcode(instruction[6:0]),
									.reg_write(reg_write), 
									.ALUSrc(ALUSrc) ,
									.Branch(Branch) ,
									.Mem_Read(Mem_Read), 
									.Mem_Write(Mem_Write) ,
									.ALU_Op(ALU_Op) ,
									.MemToReg(MemToReg)
									);

endmodule



/**************************************************/
/************SINGLE-CYCLE-CONTROL-UNIT*************/

module signle_cycle_CU(	input [6:0]			opcode,
						output reg 			reg_write, 
                        output reg 			ALUSrc ,
                        output reg 			Branch ,
                        output reg 			Mem_Read, Mem_Write ,
                        output reg [1:0] 	ALU_Op ,
                        output reg 			MemToReg
						);

/* The output signals depending on the opcode "I[6:0]".
input
	I[6] 		|| 	0 |	0 |	0 |	1  |
	I[5] 		|| 	1 |	0 |	1 |	1  |
	I[4] 		|| 	1 |	0 |	0 |	0  |
	I[3] 		|| 	0 |	0 |	0 |	0  |
	I[2] 		|| 	0 |	0 |	0 |	0  |
	I[1] 		|| 	1 |	1 |	1 |	1  |
	I[0] 		|| 	1 |	1 |	1 |	1  |
								   
output                	           
	ALUSrc 		||	0 |	1 |	1 |	0  |
	MemtoReg 	||	0 |	1 |	X |	X  |
	reg_write 	||	1 |	1 |	0 |	0  |
	Mem_Read 	||	0 |	1 |	0 |	0  |
	Mem_Write 	||	0 |	0 |	1 |	0  |
	Branch 		||	0 |	0 |	0 |	1  |
	ALUOp1 		||	1 |	0 |	0 |	0  |
	ALUOp0 		||	0 |	0 |	0 |	1  |
*/

//wire output_control_sig = {ALUSrc, MemToReg, reg_write, Mem_Read, Mem_Write, Branch, ALU_Op} ;

 /* assign {ALUSrc, MemToReg, reg_write, Mem_Read, Mem_Write, Branch, ALU_Op} = 	
    							(opcode == 7'b0110011) ? {ALUSrc, MemToReg, reg_write, Mem_Read, Mem_Write, Branch, ALU_Op} :
                                (opcode == 7'b0000011) ? 8'b11110000 :
                                (opcode == 7'b0100011) ? 8'b1x001000 :
                                (opcode == 7'b1100011) ? 8'b0x000101 :
                                8'bzzzzzzzz ;
  */
  always @(*) begin
    case(opcode)
      	7'b0110011 : begin
        	ALUSrc 		=	1'b0 ;
			MemToReg 	=	1'b0 ;
			reg_write 	=	1'b1 ;
			Mem_Read 	=	1'b0 ;
			Mem_Write 	=	1'b0 ;
			Branch 		=	1'b0 ;
			ALU_Op 		=	2'b10 ;
        end 
      	7'b0000011 : begin
           	ALUSrc 		=	1'b1;
			MemToReg 	=	1'b1;
			reg_write 	=	1'b1;
			Mem_Read 	=	1'b1;
			Mem_Write 	=	1'b0;
			Branch 		=	1'b0;
			ALU_Op 		=	2'b00 ;
        end 
		7'b0100011 : begin
           	ALUSrc 		=	1'b1;
			MemToReg 	=	1'bx;
			reg_write 	=	1'b0;
			Mem_Read 	=	1'b0;
			Mem_Write 	=	1'b1;
			Branch 		=	1'b0;
			ALU_Op 		=	2'b00 ;
        end
		7'b1100011 : begin
           	ALUSrc 		=	1'b0 ;
			MemToReg 	=	1'bx ;
			reg_write 	=	1'b0 ;
			Mem_Read 	=	1'b0 ;
			Mem_Write 	=	1'b0 ;
			Branch 		=	1'b1 ;
			ALU_Op 		=	2'b01 ;
        end
       	default : begin 
         	ALUSrc 		=	1'bz ;
			MemToReg 	=	1'bz ;
			reg_write 	=	1'bz ;
			Mem_Read 	=	1'bz ;
			Mem_Write 	=	1'bz ;
			Branch 		=	1'bz ;
			ALU_Op 		=	2'bzz ;
        end
     endcase
  end 
  

endmodule