`timescale 10ns /10ps
//status[1:0]: 00 一层 01 二层 10 一层向上 11 二层向下
//status[2]: 1 前进方向反向层有人按电梯 0 前进方向反向层无人按电梯
module state(
input clk,rst,KEY0,KEY1,KEY2,KEY3,timer,
output reg [2:0]status
);
reg flag;
initial begin status<='b000;flag<=0; end
always @(negedge clk) begin
    if(!rst) begin  
        if(status[1:0]==2'b01)begin
            status[1]<=1;
        end
        if(status[1:0]==2'b10)begin
            status[2]<=1;
        end
        if(timer) begin 
             status[1]<=0;
             status[0]<=0;
        end
    end
    else  begin
        if(timer) begin 
            if(!status[2]&status[1])begin
                status[1]<=0;
                status[0]<=~status[0];
            end
            if(status[2]&status[1])begin
                status[0]<=~status;
                status[2]<=0;
            end
        end
        else begin
            if(status[1:0]==2'b00)begin
                if(KEY1|KEY3) begin
                    status[1]<=1;
                end
            end
            if(status[1:0]==2'b01)begin
                if(KEY0|KEY2) begin
                    status[1]<=1;
                end
            end
            if(status[1:0]==2'b10)begin
                if(KEY0|KEY2) begin
                    status[2]<=1;
                end
            end
            if(status[1:0]==2'b11)begin
                if(KEY1|KEY3)begin
                    status[2]<=1;
                end
            end
        end
    end

end
endmodule

//status变化时产生一段脉冲
module buzzer(input status,clk,clk10ms,
output beep
);
reg [26:0]cnt;
reg flag;
wire buz;
initial begin cnt<=0;flag<=0;end
always @(negedge clk) begin
    if(flag!=status)begin
        flag<=status;
        cnt<=0;
    end
    else begin
        if(cnt!='b100000000000000000000000000)begin
            cnt<=cnt+1;
        end
    end
end
assign buz=cnt[0]|cnt[1]|cnt[2]|cnt[3]|cnt[4]|cnt[5]|cnt[6]|cnt[7]|cnt[8]|cnt[9]|cnt[10]|cnt[11]|cnt[12]|cnt[13]|cnt[14]|cnt[15]|cnt[16]|cnt[17]|cnt[18]|cnt[19]|cnt[20]|cnt[21]|cnt[22]|cnt[23]|cnt[24]|cnt[25];
assign beep=buz&clk10ms;
endmodule

module trigger(input IN,clk,output OUT
);
reg [23:0]cnt;
initial begin cnt<=0; end
always @(posedge clk) begin
    if(IN)begin
        if(cnt!='b100000000000000000000000)begin
            cnt<=cnt+1;
        end
    end
    if(!IN)begin
        cnt<=0;
    end
end
assign OUT=cnt[0]|cnt[1]|cnt[2]|cnt[3]|cnt[4]|cnt[5]|cnt[6]|cnt[7]|cnt[8]|cnt[9]|cnt[10]|cnt[11]|cnt[12]|cnt[13]|cnt[14]|cnt[15]|cnt[16]|cnt[17]|cnt[18]|cnt[19]|cnt[20]|cnt[21]|cnt[22];

endmodule


//3s触发计数器
module timer(input [2:0] status,
input clk1,//100ms
output reg[7:0] cnt,
output flag
);
initial begin cnt<=0;end
always@(posedge clk1)begin
    if(status[1]) begin 
        if(cnt<'d30)begin
            cnt<=cnt+1;
        end
        if(cnt=='d30)begin
            cnt<=0;
        end
    end
    if(~status[1]) begin
            cnt<=0;
    end
end
assign flag=~cnt[0]&cnt[1]&cnt[2]&cnt[3]&cnt[4];
endmodule


//LED显示
module LED(input [2:0] status,
input clk,
input KEY0,KEY1,KEY2,KEY3,
output reg LED0,LED1,LED2,LED3
);
initial begin LED0<=0; LED1<=0; LED2<=0; LED3<=0; end
always @(posedge clk) begin
    if(KEY0&&status!=3'b000)begin
        LED0<=1;
    end
    if(KEY2&&status!=3'b000)begin
        LED2<=1;
    end
    if(KEY1&&status!=3'b001)begin
        LED1<=1;
    end
    if(KEY3&&status!=3'b001)begin
        LED3<=1;
    end
    if(status[1:0]=='b00) begin
        LED0<=0;
        LED2<=0;
    end
    if(status[1:0]=='b01) begin
        LED1<=0;
        LED3<=0;
    end
    if(~status[2]&&status[1:0]=='b10)begin
        LED0<=0;
        LED2<=0;
    end
    if(~status[2]&&status[1:0]=='b11)begin
        LED1<=0;
        LED3<=0;
    end
    
end
endmodule



module main(input key0,key1,key2,key3,rst,en,
input clk,
output [7:0]DISPLAYOUT,
output [5:0]DIG,
output LED0,LED1,LED2,LED3,
output buz,
output wire [2:0] status,
output wire timer
);
wire [7:0] timecnt;
wire clk3ms,clk10ms,clk100ms,clk200ms,clk100us;
wire KEY0,KEY1,KEY2,KEY3;
wire k0,k1,k2,k3;
wire flag;
clk_100ms divto100ms(clk,clk100ms);
clk_3ms divto3ms(clk,clk3ms);
clk_10ms divto10ms(clk,clk10ms);
clk_100us divto100us(clk,clk100us);
clk_200ms divto200ms(clk,clk200ms);
remove_joggle K0(key0,clk10ms,KEY0);
remove_joggle K1(key1,clk10ms,KEY1);
remove_joggle K2(key2,clk10ms,KEY2);
remove_joggle K3(key3,clk10ms,KEY3);
assign k0=en&KEY0;
assign k1=en&KEY1;
assign k2=en&KEY2;
assign k3=en&KEY3;
state state(clk100ms,rst,k0,k1,k2,k3,timer,status);
buzzer buzzer(status[0],clk,clk10ms,buz);
timer timecount(status,clk100ms,timecnt,flag);
trigger trigger(flag,clk,timer);
LED led(status,clk,k0,k1,k2,k3,LED0,LED1,LED2,LED3);
dynamic_display display(timecnt,clk3ms,status,DISPLAYOUT,DIG);
endmodule

/*
module testbenchpftimer();
reg[2:0] status;
reg clk;
wire timer;
wire [7:0] timecnt;
initial begin clk<=0; status<=0; #1000 status<=2; end
timer timecount(status,clk,timer,timecnt);
always@(timer) begin
    if(timer)begin
        status[1]<=0;
    end
end
always #1 clk=~clk;
endmodule
*/
/*

module main(input key0,key1,key2,key3,rst,en,
input clk,
output [7:0]DISPLAYOUT,
output [5:0]DIG,
output LED0,LED1,LED2,LED3,
output buz,
output wire [2:0] status,
output wire timer
);

wire [7:0] timecnt;
wire clk3ms,clk100ms;
wire KEY0,KEY1,KEY2,KEY3;
wire k0,k1,k2,k3;
clk_100ms divto100ms(clk,clk100ms);
clk_3ms divto3ms(clk,clk3ms);
remove_joggle K0(key0,clk3ms,KEY0);
remove_joggle K1(key1,clk3ms,KEY1);
remove_joggle K2(key2,clk3ms,KEY2);
remove_joggle K3(key3,clk3ms,KEY3);
assign k0=en&KEY0;
assign k1=en&KEY1;
assign k2=en&KEY2;
assign k3=en&KEY3;
state state(rst,k0,k1,k2,k3,timer,status);
buzzer buzzer(status[0],clk3ms,buz);
timer timecount(status,clk100ms,clk3ms,timer,timecnt);
LED led(status,k0,k1,k2,k3,LED0,LED1,LED2,LED3);
dynamic_display display(timecnt,clk3ms,status,DISPLAYOUT,DIG);
endmodule

*/

/*
module testbench();
reg key0,key1,key2,key3,rst,en,clk;
wire [7:0]DISPLAYOUT;
wire [5:0]DIG;
wire LED0,LED1,LED2,LED3;
wire buz;
wire  [2:0] status;
wire  timer;
wire [7:0] timecnt;
wire clk3ms,clk100ms;
wire KEY0,KEY1,KEY2,KEY3;
wire k0,k1,k2,k3;
always #1 begin clk=~clk; end
initial begin clk<=0; key0<=1 ; key1<=1 ;key2<=1; key3<=1; rst<=1 ; clk<=1; en<=1;
#100000000 key3<=0;
#200000000 key3<=1;
#300000000 key2<=0;
end

clk_100ms divto100ms(clk,clk100ms);
clk_3ms divto3ms(clk,clk3ms);
remove_joggle K0(key0,clk3ms,KEY0);
remove_joggle K1(key1,clk3ms,KEY1);
remove_joggle K2(key2,clk3ms,KEY2);
remove_joggle K3(key3,clk3ms,KEY3);
assign k0=en&KEY0;
assign k1=en&KEY1;
assign k2=en&KEY2;
assign k3=en&KEY3;
state state(rst,k0,k1,k2,k3,timer,status);
buzzer buzzer(status[0],clk3ms,buz);
timer timecount(status,clk100ms,clk3ms,timer,timecnt);
LED led(status,k0,k1,k2,k3,LED0,LED1,LED2,LED3);
dynamic_display display(timecnt,clk3ms,status,DISPLAYOUT,DIG);
endmodule
*/