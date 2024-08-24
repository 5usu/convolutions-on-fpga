module  padding_tb;
reg clk;
reg rst;
reg values;
reg [967:0] matrix;
reg convolve;
wire [647 : 0] conv_img;
reg enable;



padding uut(
.matrix(matrix),
.clk(clk),
.rst(rst),
.values(values),
.convolve(convolve),
.conv_img(conv_img),
.enable(enable)
);

initial begin
$dumpfile("padding.vcd");
$dumpvars(0, padding_tb);
end

initial begin
clk = 0;
forever #5 clk = ~clk;
end


integer i, j;


initial begin
//RESET VALUES TO ZERO
rst = 1;


//PADDING
#1000;
rst = 0;
enable = 1;
values = 1;

for(i=1; i<=9; i=i+1)begin
   for(j=1; j<=9; j=j+1)begin
       matrix[(i*11 + j)*8 +: 8] = i*3 + j;   
   end
end


//DISPLAYING INPUT MATRIX PRE-PADDING
$display("\n input matrix before padding: ");
for(i=1; i<=9; i=i+1)begin
   for(j=1; j<=9; j=j+1)begin
      $write("%d ",matrix[(i*11 + j)*8 +: 8]);
   end
   $write("\n");
end


i=0;j=0;
for(i=0; i<=10; i=i+1)begin
matrix[(i*11 + j)*8 +: 8] = 8'd0;
end

i=0;j=0;
for(j=0; j<=10; j=j+1)begin
matrix[(i*11 + j)*8 +: 8] = 8'd0;
end

i=10;j=0;
for(j=0; j<=10; j=j+1)begin
matrix[(i*11 + j)*8 +: 8] = 8'd0;
end

i=0;j=10;
for(i=0; i<=10; i=i+1)begin
matrix[(i*11 + j)*8 +: 8] = 8'd0;
end


//DISPLAYING INPUT MATRIX POST-PADDING
i=0; j=0;
$display("\n input matrix after padding: ");
for(i=0; i<=10; i=i+1)begin
   for(j=0;j<=10;j=j+1)begin
      $write("%d ", matrix[(i*11 + j)*8 +: 8]);
   end
   $write("\n");
end


//CONVOLUTION
#10;

rst = 0;
enable = 1;
values = 0;
convolve = 1;

#7290;

i = 0; j = 0;
enable = 1;
convolve = 0;

#10000;
$display("output matrix: ");
for(i=0;i<=8;i=i+1)begin
   for(j=0;j<=8;j=j+1)begin
      $write(" %d", conv_img[(i*9 + j)*8 +: 8]);
   end
   $write("\n");
end

$finish;

end
endmodule
