module top_module(
    input wire clk,
    input wire rst,
    input wire [127:0] input_matrix ,// Flattened 1D vector for 256x256 input matrix (256*256*8 bits)
    output wire [31:0] output_matrix // Flattened 1D vector for 254x254 output matrix (254*254*8 bits)
);
    
    //reg [51611:0] output_matrix;
    // Parameters for the convolution
    parameter MATRIX_SIZE = 4;
    parameter KERNEL_SIZE = 3;
    parameter OUTPUT_SIZE = MATRIX_SIZE - KERNEL_SIZE + 1;
    initial begin
    $display("hi i am top");
    end
    // Generate block to instantiate convolution modules in parallel
    genvar i, j;
    generate
        for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin : row_gen
            for (j = 0; j < OUTPUT_SIZE; j = j + 1) begin : col_gen
                convolution conv_inst (
                    .clk(clk),
                    .rst(rst),
                    .input_window({
                        input_matrix[((i*MATRIX_SIZE + j)*8) +: 8], 
                        input_matrix[((i*MATRIX_SIZE + (j+1))*8) +: 8], 
                        input_matrix[((i*MATRIX_SIZE + (j+2))*8) +: 8],
                        input_matrix[(((i+1)*MATRIX_SIZE + j)*8) +: 8], 
                        input_matrix[(((i+1)*MATRIX_SIZE + (j+1))*8) +: 8], 
                        input_matrix[(((i+1)*MATRIX_SIZE + (j+2))*8) +: 8],
                        input_matrix[(((i+2)*MATRIX_SIZE + j)*8) +: 8], 
                        input_matrix[(((i+2)*MATRIX_SIZE + (j+1))*8) +: 8], 
                        input_matrix[(((i+2)*MATRIX_SIZE + (j+2))*16) +: 8]
                    }),
                    .output_pixel(output_matrix[((i*OUTPUT_SIZE + j)*8) +: 8])
                );
            end
        end
        
    endgenerate

endmodule



