module top(
    input wire clk,
    input wire rst,
    input wire convolve,
    input wire advance,
    input wire [7:0]   img00,
    input wire [15:8]  img01,
    input wire [23:16] img02,
    input wire [39:34] img10,
    input wire [47:40] img11,
    input wire [55:48] img12,
    input wire [71:64] img20,
    input wire [79:72] img21,
    input wire [87:80] img22,
    output wire[127:0] IMG,
    output wire[31:0] out
);
  
  genvar m,n;
  integer i, j;
  generate 
      for(m=0; m<=1; m=m+1)begin
         for(n=0; n<=1; n=n+1)begin
            gauss g0(
                     .pixel_00(img00[((4*m+n)*8 +  7):((4*m+n)*8 + 0 )]), 
                     .pixel_01(img01[((4*m+n)*8 + 15):((4*m+n)*8 + 8 )]),
                     .pixel_02(img02[((4*m+n)*8 + 23):((4*m+n)*8 + 16)]),
                     .pixel_10(img10[((4*m+n)*8 + 39):((4*m+n)*8 + 32)]),
                     .pixel_11(img11[((4*m+n)*8 + 47):((4*m+n)*8 + 40)]),
                     .pixel_12(img12[((4*m+n)*8 + 55):((4*m+n)*8 + 48)]),
                     .pixel_20(img20[((4*m+n)*8 + 71):((4*m+n)*8 + 64)]),
                     .pixel_21(img21[((4*m+n)*8 + 79):((4*m+n)*8 + 72)]),
                     .pixel_22(img22[((4*m+n)*8 + 87):((4*m+n)*8 + 80)]),
                     .blurred_pixel(),
                     .clk(clk),
                     .rst(rst),
                     .convolve(convolve),
                     .advance(advance),
                     .IMG(IMG)
                     );
                    
             gauss gn(
                      .pixel_00(), 
                      .pixel_01(),
                      .pixel_02(),
                      .pixel_10(),
                      .pixel_11(),
                      .pixel_12(),
                      .pixel_20(),
                      .pixel_21(),
                      .pixel_22(),
                      .blurred_pixel(out[(2*(m) + (n))*8 +: 8]),
                      .clk(clk),
                      .rst(rst),
                      .convolve(convolve),
                      .advance(advance),
                      .IMG(IMG)
                      );    
         end
      end 
      
      
         always@(posedge clk or psedge rst)begin
            if(rst)begin
              IMG[7:0]   = img00; IMG[15:8]  = img01; IMG[23:16] = img02;
              IMG[39:32] = img10; IMG[47:40] = img11; IMG[55:48] = img12;
              IMG[71:64] = img20; IMG[79:72] = img21; IMG[87:80] = img22;  
            end
            else if(advance)begin
              if(j==2)begin
                j = 0;
                if(i==2)begin
                  i = 0;
                end
                else begin
                  i = i+1;
                end
              else begin
                  j = j+1;
              end
            end
         end
  endgenerate
       
endmodule




module gauss(
    input wire clk,
    input wire rst,
    input wire convolve,
    input wire advance,
    input wire [7:0] pixel_00, pixel_01, pixel_02,
    input wire [7:0] pixel_10, pixel_11, pixel_12,
    input wire [7:0] pixel_20, pixel_21, pixel_22,
    output reg[31:0] blurred_pixel,
    //output reg[31:0] IMG_WINDOW,
    output reg [127:0] IMG
);

    parameter [7:0] W00 = 8'd1,  W01 = 8'd2,  W02 = 8'd1;
    parameter [7:0] W10 = 8'd2,  W11 = 8'd4,  W12 = 8'd2;
    parameter [7:0] W20 = 8'd1,  W21 = 8'd2,  W22 = 8'd1;

    reg [15:0] sum;
    integer i,j;
    reg [71:0] IMG_WINDOW;
    
                         
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            blurred_pixel <= 8'd0;
        end 
        else if(convolve) begin
             if(j==2)begin
             j = 0;
               if(i==2)begin
               i = 0;
               end
               else begin
               i = i+1;
               end
             end
             else begin
                // Calculating weighted sum
                 sum = (pixel_00 * W00) + (pixel_01 * W01) + (pixel_02 * W02) +
                       (pixel_10 * W10) + (pixel_11 * W11) + (pixel_12 * W12) +
                       (pixel_20 * W20) + (pixel_21 * W21) + (pixel_22 * W22);
                       
                 blurred_pixel[(2*i + j)*8 +: 8] <= sum[11:4];  
                 j = j+1;
             end
        end      
    end
endmodule



