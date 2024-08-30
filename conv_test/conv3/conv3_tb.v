`timescale 1ns / 1ps

module tb_top_module;

  
    parameter MATRIX_SIZE = 4;
    parameter KERNEL_SIZE = 3;
    parameter OUTPUT_SIZE = MATRIX_SIZE - KERNEL_SIZE + 1;

  
    reg clk;
    reg rst;
    reg [127:0] input_matrix; 
    wire [31:0] output_matrix; 

 
    top_module uut (
        .clk(clk),
        .rst(rst),
        .input_matrix(input_matrix),
        .output_matrix(output_matrix)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end
    
    integer i, j;
    
    initial begin
        
        
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                input_matrix[(i * MATRIX_SIZE + j) * 8 +: 8] = (i + j) % 4; 
                //display input matrix
                $write(" %d", input_matrix[(i * MATRIX_SIZE + j) * 8 +: 8]);
            end
            $write(" \n ");
        end

        rst = 1;
        #10;
        rst = 0;

       
        #1000;
        //displaying output matrix
        
        for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin
            for (j = 0; j < OUTPUT_SIZE; j = j + 1) begin
                $display("%d", output_matrix[(i * OUTPUT_SIZE + j) * 8 +: 8]);
            end
        end

        $finish;
    end

endmodule

