module padding(
input [967:0] matrix,
output reg [647 : 0] conv_img,
input clk,
input rst,
input values,
input convolve,
input enable
);


integer i, j, m, n;
integer counter;
integer temp;
reg signed[7:0] MASK[2:0][2:0];
reg signed[7:0] CONV[8:0][8:0];
reg signed[7:0] IMG[10:0][10:0];
reg exit;

initial begin
MASK[0][0] = 2; MASK[0][1] = 1; MASK[0][2] = 2;
MASK[1][0] = 1; MASK[1][1] = 6; MASK[1][2] = 1;
MASK[2][0] = 2; MASK[2][1] = 1; MASK[2][2] = 2;
$display("\n gaussian kernel:  \n");
for(i=0; i<=2; i=i+1)begin
   for(j=0; j<=2; j=j+1)begin
      $write(MASK[i][j]);
   end
   $write("\n");
end
end

always@(posedge clk or posedge rst or posedge enable)begin
   if(rst == 1)begin
   for(i=0; i<=10; i=i+1)begin
      for(j=0; j<=10; j=j+1)begin
         IMG[i][j] = 8'd0;
      end 
   end
   i = 0;
   j = 0;
   m = 0;
   n = 0;
   temp = 0;
   exit = 0;
   counter = 1;
   end
   else begin
     if(enable == 1)begin
       if(values == 1)begin
         for(i=0; i<=10; i=i+1)begin
            for(j=0; j<=10; j=j+1)begin
               IMG[i][j] = matrix[(i*11 + j)*8 +: 8];  
            end
         end
         i=0;
         j=0; 
         m=0;
         n=0;
         temp = 0; 
         exit = 0;  
       end
       else if(convolve == 1)begin
           temp  = temp + MASK[i][j]*IMG[i+m][j+n];
           if(j==2)begin
             j = 0;
           
             if(i==2)begin
               CONV[m][n] = temp;
               i = 0;
               temp = 0;
               if(n==8)begin
                 n = 0;
                 if(m==8)begin
                   m = 0;
                   $display("\n convolution complete \n");
                 end else begin
                   m = m + 1;                 
                 end
                end else begin
                 n = n + 1;
               end
             end else begin
               i=i+1;
             end
           end else begin
             j=j+1;
             
           end
           counter = counter + 1;
       end
       else if(convolve == 0)begin   
           for(i=0; i<=8; i=i+1)begin
              for(j=0; j<=8; j=j+1)begin
                 conv_img[(i*9 + j)*8 +: 8] = CONV[i][j];
              end
           end   
       end
      end 
   end 
end

endmodule
