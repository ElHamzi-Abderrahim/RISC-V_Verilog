// full adder 

module adder #(parameter length = 64)
			(
			input 		[length-1:0] input_1,
			input 		[length-1:0] input_2,
			output wire [length-1:0] result 
			);

 assign result = input_1 + input_2 ;

endmodule