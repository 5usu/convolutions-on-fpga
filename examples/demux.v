module demux(
	input wire data_in,
	input wire [2:0] select, 
	output reg [7:0] data_out
); 

always @(*) begin 
	data_out = 8'b0; 
	case (select) 
		3'b000: data_out[0] = data_in; 
		3'b001: data_out[1] = data_in; 
		3'b010: data_out[2] = data_in; 
		3'b011: data_out[3] = data_in; 
		3'b100: data_out[4] = data_in; 
		3'b101: data_out[5] = data_in; 
		3'b110: data_out[6] = data_in; 
		3'b111: data_out[7] = data_in; 
	endcase
end 
endmodule 

