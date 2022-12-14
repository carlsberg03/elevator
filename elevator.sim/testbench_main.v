//~ `New testbench
`timescale  1ns / 1ps

module tb_state;

// state Parameters
parameter PERIOD  = 10;


// state Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   KEY0                                 = 0 ;
reg   KEY1                                 = 0 ;
reg   KEY2                                 = 0 ;
reg   KEY3                                 = 0 ;
reg   timer                                = 0 ;

// state Outputs
wire  [2:0]  status                        ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

state  u_state (
    .clk                     ( clk           ),
    .rst                     ( rst           ),
    .KEY0                    ( KEY0          ),
    .KEY1                    ( KEY1          ),
    .KEY2                    ( KEY2          ),
    .KEY3                    ( KEY3          ),
    .timer                   ( timer         ),

    .status                  ( status  [2:0] )
);

initial
begin

    $finish;
end

endmodule
