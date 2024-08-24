module traffic_control(
    input wire clk,
    input wire reset,
    output reg [1:0] light
);


parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

parameter RED_TIME = 10;
parameter YELLOW_TIME = 10;
parameter GREEN_TIME = 10;

reg [1:0] state, next_state;
reg [5:0] timer;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= RED;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        RED:
            if (timer == RED_TIME - 1)
                next_state = GREEN;
            else
                next_state = RED;
        YELLOW:
            if (timer == YELLOW_TIME - 1)
                next_state = RED;
            else
                next_state = YELLOW;
        GREEN:
            if (timer == GREEN_TIME - 1)
                next_state = YELLOW;
            else
                next_state = GREEN;
        default: next_state = RED;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset)
        timer <= 0;
    else if ((state == RED && timer == RED_TIME - 1) ||
             (state == YELLOW && timer == YELLOW_TIME - 1) ||
             (state == GREEN && timer == GREEN_TIME - 1))
        timer <= 0;
    else
        timer <= timer + 1;
end

always @(*) begin
    light = state;
end

endmodule
