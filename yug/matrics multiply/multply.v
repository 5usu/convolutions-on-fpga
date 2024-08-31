`timescale 1ns / 1ps

`define BIT_LEN 8
`define RESULT_LEN 16
`define MATRIX_SIZE 3

module MatrixMultiplier#(
    parameter BIT_LEN = `BIT_LEN,
    parameter RESULT_LEN = `RESULT_LEN,
    parameter MATRIX_SIZE = `MATRIX_SIZE
    )(
    output reg [RESULT_LEN-1:0] result,
    input [BIT_LEN-1:0] matrix_a [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    input [BIT_LEN-1:0] matrix_b [0:MATRIX_SIZE-1][0:MATRIX_SIZE-1],
    input start,
    input reset,
    input clk
    );
    
    // Internal registers for computation
    reg [3:0] i, j, k;
    reg [RESULT_LEN-1:0] sum;
    reg [1:0] state;
    
    // State encoding
    localparam IDLE = 2'd0,
               MULTIPLY = 2'd1,
               DONE = 2'd2;

    // State machine logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            result <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
            sum <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= MULTIPLY;
                        i <= 0;
                        j <= 0;
                        sum <= 0;
                    end
                end
                
                MULTIPLY: begin
                    if (i < MATRIX_SIZE) begin
                        if (j < MATRIX_SIZE) begin
                            sum = 0;
                            for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                                sum = sum + (matrix_a[i][k] * matrix_b[k][j]);
                            end
                            result[i * MATRIX_SIZE + j] = sum;
                            j = j + 1;
                        end else begin
                            j = 0;
                            i = i + 1;
                        end
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    // Indicate the completion of the multiplication
                    // Here, you could set a 'done' signal or perform other actions
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

