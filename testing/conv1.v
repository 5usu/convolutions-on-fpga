module top(
    input wire clk,
    input wire rst,
    input wire [7:0]   img00,
    input wire [15:8]  img01,
    input wire [23:16] img02,
    input wire [39:34] img10,
    input wire [47:40] img11,
    input wire [55:48] img12,
    input wire [71:64] img20,
    input wire [79:72] img21,
    input wire [87:80] img22,
    output wire[31:0] out
);
  
  genvar m,n;
  
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
                     .rst(rst)
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
                      .blurred_pixel(out[(2*(m) + (n))*8 +: 8])
                      );
                      
         end
      end
  
  endgenerate
  
     
endmodule




module gauss(
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_00, pixel_01, pixel_02,
    input wire [7:0] pixel_10, pixel_11, pixel_12,
    input wire [7:0] pixel_20, pixel_21, pixel_22,
    output reg[7:0] blurred_pixel
);

    parameter [7:0] W00 = 8'd1,  W01 = 8'd2,  W02 = 8'd1;
    parameter [7:0] W10 = 8'd2,  W11 = 8'd4,  W12 = 8'd2;
    parameter [7:0] W20 = 8'd1,  W21 = 8'd2,  W22 = 8'd1;

    reg [15:0] sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            blurred_pixel <= 8'd0;
        end else begin
            // Calculating weighted sum
            sum = (pixel_00 * W00) + (pixel_01 * W01) + (pixel_02 * W02) +
                  (pixel_10 * W10) + (pixel_11 * W11) + (pixel_12 * W12) +
                  (pixel_20 * W20) + (pixel_21 * W21) + (pixel_22 * W22);

            blurred_pixel <= sum[11:4];
        end
    end
endmodule


