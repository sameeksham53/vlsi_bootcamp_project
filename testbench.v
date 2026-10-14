`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2025 20:47:37
// Design Name: 
// Module Name: cic_tb
// Project Name:  
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cic_tb();
    reg data [0:4096025];
    
    reg clk,clk2,clk3,clk4, reset,enable;
    wire outready,outready2;
    
    reg  signed [1:0] bits;
    
    wire signed [19:0] cicout; //change according to need
    wire signed [92:0] firout; //change according to need
    
    initial begin
    $readmemh("E:/vlsi bootcamp/hz10.mem", data);
end
    

    initial begin
        clk=0;
        clk2=0;
        clk3=0;
        bits=0;
        enable=0;
        reset = 1;
        #51 reset = 0;
        enable=1;
    end
    always #50 clk=~clk;
    always #25600 clk2=~clk2; //change according to filter output frequencies
    always #102400 clk3=~clk3; //change according to filter output frequencies

    
    integer i;
initial i = 0;

integer fd1,fd2,fd3,fd4;
initial begin
    fd1 = $fopen("E:/vlsi bootcamp/bits.txt","w");
    fd2 = $fopen("E:/vlsi bootcamp/cic512_990.txt","w");
    fd3 = $fopen("E:/vlsi bootcamp/fircomp.txt","w");
    fd4 = $fopen("E:/vlsi bootcamp/cic512_10_by4.txt","w");
end
    always @(posedge clk) begin
        if (i < 4096026) begin
            if(i%2==0)begin
                bits={1'b0,data[i]};
            end else begin
                bits={2{data[i]}};
            end
            i <= i + 1;
        end else begin
            #200;
            $finish;
        end
    end
    always @(posedge clk) begin
        $fwrite(fd1, "%d\n",  bits); 
    end
    always @(posedge clk) begin
        if(outready)begin
            $fwrite(fd2, "%d\n",  $signed(cicout));//keep 20 bits width 
        end
    end
    always @(posedge clk2) begin
            $fwrite(fd3, "%d\n",  $signed(firout)); //keep 20 bits width
    end
    always @(posedge clk3) begin
        $fwrite(fd4, "%d\n",  $signed(cicout));//keep 20 bits width
    end
    cic_decimator #(.N(4), .R(512), .BIN(2)) cic (
    .clk(clk), .reset(reset), .din(bits),
    .dout(cicout), .dvalid(outready));
endmodule