// progam counter

module pc 	#(	parameter bus_length = 'd64)
			(input 		clk, rst_n,
             input 		[bus_length -1 :0] pc_input,
             output reg 	[bus_length -1 :0]  pc_output
			);
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		pc_output <= 0 ;
	else
		pc_output = pc_input ;
end
	
endmodule