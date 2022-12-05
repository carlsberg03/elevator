
//????
module remove_joggle(key_in,clk,key_out);
input key_in,clk;
output reg key_out;
reg q0,q1,q2,q3;
initial begin q0<=1;q1<=1;q2<=1;q3<=1;key_out<=0;end
always @(posedge clk)
begin 
 q3 <= q2;
 q2 <= q1;
 q1 <= q0;
 q0 <= key_in;
end
always@(*)
begin
if(q0&q1&q2&q3&key_out) begin key_out = 0; end
if(~(q0|q1|q2|q3)&~key_out) begin key_out <= 1; end
end
endmodule