// adder 

module mem_instr #(	parameter bus_length = 'd64)
  				(input clk ,
                 input [bus_length -1:0] read_address ,
                 output reg [31:0] instruction
				);

  reg [7:0]  memory [0:256];
  reg [31:0] R_type, I_type, S_type, SB_type ;

initial begin
  //  R-type instruction {funct7[6:0], rs2[4:0], rs1[4:0], funct3[2:0], rd[4:0], opcode[6:0]}
                  /*		instr		opcode		funct7		funct3
                  R-type  add			0110011 	0000000 	000 
                  R-type  sub			0110011 	0100000 	000 
                  R-type  and			0110011 	0000000 	111 
                  R-type  or			0110011 	0000000 	110 
                  													*/
	// add x3, x1, x2 ;
  	R_type = {7'b000_0000, 5'b00001 , 5'b00010 , 3'b000 , 5'b00011 , 7'b011_0011 } ;
  	{memory[0], memory[1], memory[2], memory[3] } = R_type ;
	// sub x4, x1, x2 ;  
  	R_type = {7'b010_0000, 5'b00001 , 5'b00010 , 3'b000 , 5'b00100 , 7'b011_0011 } ;
  	{memory[4], memory[5], memory[6], memory[7] } = R_type ;
  
	// and x12, x10, x11 ;  
  	R_type = {7'b000_0000, 5'b01010 , 5'b01011 , 3'b111 , 5'b01100 , 7'b011_0011 } ;
  	{memory[8], memory[9], memory[10], memory[11] } = R_type ;
  
	// or x13, x10, x11 ;  
  	R_type = {7'b000_0000, 5'b01010 , 5'b01011 , 3'b110 , 5'b01101 , 7'b011_0011 } ;
  	{memory[12], memory[13], memory[14], memory[15] } = R_type ;
  	
  
  //  I-type instruction {immediate[11:0], rs1[4:0], funct3[2:0], rd[4:0], opcode[6:0]}
                    /*		instr		opcode		funct3
                    I-type    ld		0000011		xxx		*/
  // ld x13, (offset=12)x0;
  			// 		immediate = 'hC = 1100. 
  			// 		rs1 = 0 = x0. 
  			// 		rd = 13 = 'hD = x13.
  //I_type = {12'b0000_0000_1100, 5'b0 , 3'bXXX , 5'b1_0100 , 7'b000_0011} ; // load data in the address 12='hC
  //{memory[16], memory[17], memory[18], memory[19] } = I_type ; // to the register x20='h14
  
  I_type = {12'b0000_0010_1000, 5'b0 , 3'bXXX , 5'b1_0111 , 7'b000_0011} ; // load data in the address 40='h23
  {memory[16], memory[17], memory[18], memory[19] } = I_type ; // to the register x23 in hex 'h17
  
  
  //  S-type instruction {immediate[11:0], rs2[4:0], rs1[4:0], funct3[2:0], immediate[4:0], opcode[6:0]}
                    /*		instr		opcode		funct3
                    S-type    sd		0100011		xxx		*/
  	//  sd sr2, (immediate)sr1  ;
  // sd x2, (offset=2)x0  ;
  		// immediate = 2 = 0000_0000_0010
  		// rs1 = 2. 
  		// rs2 = 0. 
        // rs2 contains data to be written to the address memory == data{rs1}+immediate
  S_type = {7'b000_0000, 5'b0_0010, 5'b0 , 3'bXXX , 5'b0_0010 , 7'b010_0011} ;
  {memory[20], memory[21], memory[22], memory[23] } = S_type ;
  
  
  // SB-type instruction {immediate[12,10:5], rs2[4:0], rs1[4:0], funct3[2:0], immediate[4:1,11], opcode[6:0]}
                  /*		instr		opcode		funct3
                  SB-type  	beq			0110_0011 	xxx 
      beq rs1, rs2, immediate  */
     			
  // beq x10, x22, 2
  SB_type = {7'b00_0000, 5'd10, 5'd22 , 3'bXXX , 5'b1000_0 , 7'b110_0011} ;
  {memory[24], memory[25], memory[26], memory[27] } = SB_type ;
  
end

  always @(*) begin
	instruction = {memory[read_address], memory[read_address + 1], memory[read_address + 2], memory[read_address + 3]} ;
end

endmodule
