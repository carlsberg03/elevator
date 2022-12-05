module dynamic_display(input[7:0] timer,
input clk,
input [2:0]status,
output reg [7:0]DISPLAYOUT,
output reg [5:0]DIG
);
reg [7:0] D[9:0];
reg [1:0]cnt;
initial begin
    D[0]='h3f;
    D[1]='h06; 
    D[2]='h5b; 
    D[3]='h4f;
    D[4]='h66;   
    D[5]='h6d;   
    D[6]='h7d;  
    D[7]='h07;  
    D[8]='h7f;  
    D[9]='h6f; 
    DIG=6'b000000;
    cnt=2'b00;
    DISPLAYOUT<=0;
    end
    always @(posedge clk) begin 
    cnt=cnt+1;
    end
    always@(posedge clk)
    begin
        case(cnt)
            2'b00:begin DISPLAYOUT<=D[status[0]]; DIG<=6'b111110; end
            2'b01:begin
                if(!status[1])begin
                    DISPLAYOUT<=8'b01000000;
                end
                else begin
                    if(status[0])begin
                        DISPLAYOUT<=8'b00001000;
                    end
                    if(!status[0])begin
                        DISPLAYOUT<=8'b00000001;                        
                    end
                end
                DIG<=6'b111101; 
            end
            2'b10:begin 
                DISPLAYOUT<=D[timer%10];
                DIG<=6'b101111; 
            end
            2'b11:begin
                if(timer=='d0)begin
                    DISPLAYOUT[6:0]<=D[3][6:0];
                    DISPLAYOUT[7]<=1;
                    DIG<=6'b011111; 
                end
                else begin
                DISPLAYOUT[6:0]<=D[(timer-(timer%10))/10][6:0];
                DISPLAYOUT[7]<=1; 
                DIG<=6'b011111; 
                end
            end
        endcase
    end
endmodule