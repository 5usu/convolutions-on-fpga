module water_reservoir_controller (
    input wire S1,
    input wire S2,
    input wire S3,
    input wire clk,
    input wire reset,
    output reg FR1,
    output reg FR2,
    output reg FR3,
    output reg AFR
);

parameter [1:0] ABOVE_S3 = 2'b00,
                BETWEEN_S3_S2 = 2'b01,
                BETWEEN_S2_S1 = 2'b10,
                BELOW_S1 = 2'b11;

reg [1:0] current_state, next_state;

always @(*) begin
    case (current_state)
        ABOVE_S3: 
            if (!S3) next_state = BETWEEN_S3_S2;
            else next_state = ABOVE_S3;
        BETWEEN_S3_S2:
            if (S3) next_state = ABOVE_S3;
            else if (!S2) next_state = BETWEEN_S2_S1;
            else next_state = BETWEEN_S3_S2;
        BETWEEN_S2_S1:
            if (S2) next_state = BETWEEN_S3_S2;
            else if (!S1) next_state = BELOW_S1;
            else next_state = BETWEEN_S2_S1;
        BELOW_S1:
            if (S1) next_state = BETWEEN_S2_S1;
            else next_state = BELOW_S1;
        default:
            next_state = ABOVE_S3;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= ABOVE_S3;
    else
        current_state <= next_state;
end

always @(*) begin
    FR1 = 0;
    FR2 = 0;
    FR3 = 0;
    AFR = 0;
    case (current_state)
        ABOVE_S3: begin
            FR1 = 0;
            FR2 = 0;
            FR3 = 0;
            AFR = 0;
        end
        BETWEEN_S3_S2: begin
            FR1 = 1;
            FR2 = 0;
            FR3 = 0;
            AFR = 0;
        end
        BETWEEN_S2_S1: begin
            FR1 = 1;
            FR2 = 1;
            FR3 = 0;
            AFR = 0;
        end
        BELOW_S1: begin
            FR1 = 1;
            FR2 = 1;
            FR3 = 1;
            AFR = 1;
        end
    endcase
end

endmodule
