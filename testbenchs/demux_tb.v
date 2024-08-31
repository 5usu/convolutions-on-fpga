module demux_tb ();
	reg data_in; 
	reg [2:0] select; 
	wire [7:0] data_out; 

demux uut (
	.data_in(data_in), 
	.select(select), 
	.data_out(data_out) 
); 

initial begin 
	data_in = 0; 
	select = 3'b000; 
	#100;
	data_in = 1; 

	data_in = 0; 
	select = 3'b101; 
	
	#10 $finish; 
end
initial begin 
	$dumpfile("demux.vcd"); 
	$dumpvars(0, demux_tb); 
end
endmodule 
