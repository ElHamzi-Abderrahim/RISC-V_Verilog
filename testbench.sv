
module top ;

	logic clk, rst_n ;

  risc_v_basic risc_V_SingleCycle (clk, rst_n );
  

initial begin // clock gererator
	clk = 0 ;
	forever #10 clk = ~clk ;
end 

initial begin 
	rst_n = 0 ;
	#30 rst_n = 1 ;
  	#500 ;
  $finish();
end

  
initial begin
  $dumpfile("d.vcd");
  $dumpvars();
end

  

endmodule