
/*********************************************************/
/***********************  ALU   **************************/

module alu #(parameter data_length = 64)
			(	input [3:0] alu_operation ,
				input [data_length-1:0] alu_in1, alu_in2,
				output reg [data_length-1:0] alu_result,
				output zero 
			);
			
	parameter 	and_op 	= 4'b0000,
				or_op 	= 4'b0001,
				add 	= 4'b0010,
				sub 	= 4'b0110,
				slt 	= 4'b0111,
				nor_op 	= 4'b1100;
				
assign zero = (alu_result == 0) ;				
				
always @(*) begin
	case(alu_operation)
		and_op 	: alu_result = alu_in1 & alu_in2 ;
		or_op 	: alu_result = alu_in1 | alu_in2 ;
		add 	: alu_result = alu_in1 + alu_in2 ;
		sub 	: alu_result = alu_in1 - alu_in2 ;
		slt 	: alu_result = (alu_in1 < alu_in2) ? 1 : 0 ;
		nor_op 	: alu_result = ~(alu_in1 | alu_in2) ;
      default : alu_result = 0 ;
    endcase
end
	
endmodule


/*********************************************************/
/**********************ALU-CONTROL************************/

module alu_control (input [1:0] 	ALU_Op,
					input 			funct7, 
					input [2:0]		funct3,
					output reg [3:0]operation
					) ;
				
always @(*) begin
	casex ({ALU_Op, funct7, funct3})      
      	6'b00xxxx : operation = 4'b0010 ;
		6'bx1xxxx : operation = 4'b0110 ;
		6'b1x0000 : operation = 4'b0010 ;
		6'b1x1000 : operation = 4'b0110 ;
		6'b1x0111 : operation = 4'b0000 ;
		6'b1x0110 : operation = 4'b0001 ;
		default   : operation = 4'bzzzz ; 
	endcase
end
endmodule

