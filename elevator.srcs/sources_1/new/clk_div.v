
//??

module clk_3ms(input clk,output reg clk_out);
reg [31:0] cnt;
initial begin  cnt=0;clk_out=0; end
always @(posedge clk)
begin
if(cnt=='d74999) begin clk_out=~clk_out;cnt=0; end
else cnt=cnt+1;
end
endmodule

module clk_100us(input clk,output reg clk_out);
reg [31:0] cnt;
initial begin  cnt=0;clk_out=0; end
always @(posedge clk)
begin
if(cnt=='d2499) begin clk_out=~clk_out;cnt=0; end
else cnt=cnt+1;
end
endmodule

module clk_100ms(input clk,output reg clk_out);
reg [31:0] cnt;
initial begin  cnt=0;clk_out=0; end
always @(posedge clk)
begin
if(cnt=='d2499999) begin clk_out=~clk_out;cnt=0; end
else cnt=cnt+1;
end
endmodule

module clk_200ms(input clk,output reg clk_out);
reg [31:0] cnt;
initial begin  cnt=0;clk_out=0; end
always @(posedge clk)
begin
if(cnt=='d4999999) begin clk_out=~clk_out;cnt=0; end
else cnt=cnt+1;
end
endmodule

module clk_10ms(input clk,output reg clk_out);
reg [31:0] cnt;
initial begin  cnt=0;clk_out=0; end
always @(posedge clk)
begin
if(cnt=='d249999) begin clk_out=~clk_out;cnt=0; end
else cnt=cnt+1;
end
endmodule