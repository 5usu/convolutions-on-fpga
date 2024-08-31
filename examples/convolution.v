module convolution (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [647:0] input_matrix, // Flattened 9x9 matrix, each element is 8 bits
    output reg [647:0] output_matrix, // Flattened 9x9 matrix, each element is 8 bits
    output reg done
);

// Gaussian kernel (normalized)
reg [7:0] KERNEL [0:2][0:2];
initial begin
    KERNEL[0][0] = 4; KERNEL[0][1] = 6; KERNEL[0][2] = 4;
    KERNEL[1][0] = 6; KERNEL[1][1] = 9; KERNEL[1][2] = 6;
    KERNEL[2][0] = 4; KERNEL[2][1] = 6; KERNEL[2][2] = 4;
end

parameter KERNEL_SUM = 49;

// FSM states
localparam IDLE = 2'b00;
localparam CONVOLVE = 2'b01;
localparam FINISH = 2'b10;

reg [1:0] state, next_state;
reg [3:0] row, col;
reg [11:0] sum;
reg [3:0] k_row, k_col;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        row <= 0;
        col <= 0;
        k_row <= 0;
        k_col <= 0;
        sum <= 0;
        done <= 0;
        output_matrix <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (start) begin
                    row <= 0;
                    col <= 0;
                    k_row <= 0;
                    k_col <= 0;
                    sum <= 0;
                    done <= 0;
                end
            end
            CONVOLVE: begin
                if (k_row == 2 && k_col == 2) begin
                    output_matrix[(row*9+col)*8 +: 8] <= sum / KERNEL_SUM;
                    sum <= 0;
                    k_row <= 0;
                    k_col <= 0;
                    if (col == 8) begin
                        col <= 0;
                        if (row == 8) begin
                            row <= 0;
                            next_state <= FINISH;
                        end else begin
                            row <= row + 1;
                        end
                    end else begin
                        col <= col + 1;
                    end
                end else begin
                    // Handling edge cases with zero padding
                    if (row + k_row - 1 >= 0 && row + k_row - 1 < 9 && col + k_col - 1 >= 0 && col + k_col - 1 < 9) begin
                        sum <= sum + input_matrix[((row + k_row - 1) * 9 + (col + k_col - 1)) * 8 +: 8] * KERNEL[k_row][k_col];
                    end
                    if (k_col == 2) begin
                        k_col <= 0;
                        k_row <= k_row + 1;
                    end else begin
                        k_col <= k_col + 1;
                    end
                end
            end
            FINISH: begin
                done <= 1;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = start ? CONVOLVE : IDLE;
        CONVOLVE: next_state = CONVOLVE;
        FINISH: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule

