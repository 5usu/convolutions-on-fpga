module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //
    reg [1:0] state, next_state;
    parameter A=0,B=1,C=2,D=3;
    // State transition logic (combinational)
    always@(*)begin
        case(state)
            A: begin
                if(in[3]==1) next_state=B;
                else next_state=A;
            end
            B: begin
                next_state=C;
            end
            C: begin
                next_state=D;
            end
            D: begin
                if(in[3]==1) next_state=B;
                else next_state=A;
            end
        endcase
    end
    // State flip-flops (sequential)
    always@(posedge clk)begin
        if(reset) 
            state<=A;
        else
            state<=next_state;
    end
    // Output logic
    assign done=(state==D)?1:0;
endmodule
