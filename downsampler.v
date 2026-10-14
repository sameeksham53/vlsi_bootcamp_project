`timescale 1ns / 1ps


module downsampler #(parameter R = 512)(
input clk,
input reset,
output wire tick );
reg [$clog2(R)-1:0] count;
reg [$clog2(R)-1:0] load_value;
localparam r_1 = R - 1;

 assign tick = ( count == 0);
 always@(posedge clk or posedge reset )begin
 if(reset)begin
 count <= r_1;
 end else if(tick)begin
 count<=r_1;
 end else begin
 count<=count- 1'b1;
 end 
 end 

endmodule
