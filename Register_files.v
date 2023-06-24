// Registers

module registers #(parameter data_length = 64, parameter addr_size = 5)
			(	input clk, reg_write,
				input [addr_size-1:0] read_reg1,read_reg2,
				input [addr_size-1:0] write_reg,
				input [data_length-1:0] write_data,
				output wire [data_length-1:0] read_data1, read_data2
				);

  reg [data_length-1:0] register_file [0 : 31]; 

initial begin
	register_file[0] = 64'b0 ;
	register_file[1] = 64'd22 ; // x1 = 22
	register_file[2] = 64'd33 ; // x2 = 33
  	register_file[3] = 64'bXX ; // x3 = xx
  	
	register_file[10] = 64'b0110 ; // x10 = 0110
	register_file[11] = 64'b1111 ; // x11 = 1111
  
	register_file[22] = 64'b0110 ;
  
	
end

assign read_data1 = register_file[read_reg1];
assign read_data2 = register_file[read_reg2];

  always @(*) begin
	if(reg_write)
		register_file[write_reg] <= write_data ;
end 

endmodule