`timescale 1ns / 1ps


module comb #(parameter W = 32)(
input clk,
input reset,
input tick,
input wire signed [W-1:0]  din ,
output wire signed [W-1:0]  dout);
reg signed [W-1:0] prev;
assign dout = din - prev;

always@( posedge clk or posedge reset)begin
if(reset)begin
prev<=0;
end
else if(tick) begin
prev<=din;
end 
end 

endmodule
