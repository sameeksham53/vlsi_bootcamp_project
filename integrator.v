`timescale 1ns / 1ps



module integrator #(parameter W = 32)(
input clk,
input reset,
input wire signed [W-1:0]  din , 
output reg signed [W-1:0]  dout );

always @ ( posedge clk)
begin
if (reset)
  dout <= 0;
else
  dout <= dout + din;
end 


endmodule
