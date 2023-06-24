// Data Memory unit

/********************************************************************/
/********************    Data Memory unit    ************************/

module data_Mem #(parameter addr_size = 64, parameter data_length = 64)
				(input 		clk ,Mem_Read, Mem_Write,
				input 		[addr_size-1:0] address,
				input 		[data_length-1:0] write_Data,
				output reg 	[data_length-1:0] read_Data
				);
				
reg [7:0] memory [ 0 : 224 - 1 ];

/*	DATA Memory  */
/*initial begin
memory[0] = 8'h00;
memory[1] = 8'h01;
memory[2] = 8'h02;
memory[3] = 8'h03;
memory[4] = 8'h04;
memory[5] = 8'h05;
memory[6] = 8'h06;
memory[7] = 8'h07;
//...
end */
  
integer i ;
initial begin
  for(i = 0; i < 2*200 ; i = i+1) begin
    memory[i] = 8'hff;
  end 
  memory[12] = 8'haa ; 
  memory[40] = 8'hbb ;
end


  always @(*)
begin
	if(Mem_Write)
		memory[address] = write_Data ;
	else if(Mem_Read)
		read_Data= memory[address]  ;
end
endmodule

/********************************************************************/
/*****************		Immediate generator	   **********************/
 
module Imm_gen	(input [31:0] in_Imm,
				output [63:0] extnd_Imm
				);
/* 	instruction[6] == 1 then the instruction is I-type.
	instruction[6] == 0 then the instruction is R-type.
		=> instruction[5] == 1 then the instruction is a Store.
		=> instruction[5] == 0 then the instruction is a Load. 
*/
assign extnd_Imm = 	in_Imm[6] == 1 ?  {  {52{in_Imm[31]}} , in_Imm[7], in_Imm[30:25], in_Imm[11:8]  } : 
															
					in_Imm[5] == 1 ? { {52{in_Imm[31]}}  , in_Imm[31:25] , in_Imm[11:7] } :
									
					{ {52{in_Imm[31]}} , in_Imm[31:20]} ;
									

endmodule

/*********************************************************/
/*****************	shift left-1	**********************/

module shift_left #(parameter in_length = 64)
					(input [in_length-1:0] in_data,
					output wire [in_length-1:0] shifted_data
					);

  assign 	shifted_data = { {in_data[in_length-2:0]}, 1'b0 } ;

endmodule

/****************************************************************/
/*****************		 MULTIPLEXOR       **********************/

module Mux #(parameter in_length = 64)
			(input		sel,
			input 		[in_length-1:0] in_0, in_1,
			output reg 	[in_length-1:0] outmux
			);

assign outmux = sel ? in_1 : in_0 ;

endmodule




