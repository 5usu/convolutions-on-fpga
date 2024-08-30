module top(
input clk,
input rst,
input wire [127:0] IMG,
output wire [31:0] CONV

);
    reg[71:0] WINDOW;
    
    genvar m,n;
    genvar i,j;
    generate 
       for(m=0; m<2; m=m+1)begin
          for(n=0; n<2; n=n+1)begin
             WINDOW[(3*m+n)*8 +: 8] = IMG[(4*m+n)*8 +: 8];
          end
       end  
       
       //insantiating individual pixels through window
       convolution c0(.p00(WINDOW[7:0] ),
                      .p01(WINDOW[15:8]),
                      .p02(WINDOW[23:16]),
                      .p10(WINDOW[31:24]),
                      .p11(WINDOW[39:32]),
                      .p12(WINDOW[47:40]),
                      .p20(WINDOW[55:48]),
                      .p21(WINDOW[63:56]),
                      .p22(WINDOW[71:64]),
                      .pixel()
                      .clk(clk),
                      .rst(rst)
                     );
         
         //insantiating "pixel" through CONV
        for(i =0; i<2; i=i+1)begin
           for(j=0; j<2; j=j+1)begin
              convolution c1(.p00(),
                             .p01(),
                             .p02(),
                             .p10(),
                             .p11(),
                             .p12(),
                             .p20(),
                             .p21(),
                             .p22(),
                             .pixel(CONV[(2*m + n)*8 +: 8]),
                             .clk(clk),
                             .rst(rst)
           end
        end      
    endgenerate
    
endmodule




module convolution(
input clk,
input rst,
input wire[7:0] p00,
input wire[7:0] p01,
input wire[7:0] p02,
input wire[7:0] p10,
input wire[7:0] p11,
input wire[7:0] p12,
input wire[7:0] p20,
input wire[7:0] p21,
input wire[7:0] p22,
output reg[15:0] pixel
);

    parameter [3:0] W00 = 4'd1, W01 = 4'd2, W02 = 4'd1;
    parameter [3:0] W10 = 4'd2, W11 = 4'd4, W12 = 4'd2;
    parameter [3:0] W20 = 4'd1, W21 = 4'd2, W22 = 4'd1;
    
    reg[15:0] sum;
    
    always@(posedge clk or posedge rst)begin
         if(rst)begin
            sum = 15'd0;
         end
         else begin
            sum = p00*W00 + p00*W01 + p00*W02 + 
                  p00*W10 + p00*W11 + p00*W12 + 
                  p00*W20 + p00*W21 + p00*W22;                
         end
         pixel = sum;
    end

endmodule




